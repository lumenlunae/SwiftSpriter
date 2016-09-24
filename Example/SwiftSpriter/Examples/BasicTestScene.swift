//
//  BasicTestScene.swift
//  SwiftSpriterExample
//
//  Created by Matt on 8/28/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import UIKit
import SpriteKit
import SwiftSpriter

class BasicTestScene: SKScene, TextureLoader, AnimationNodeDelegate {
    var animationManager: AnimationManager!
    var animationNode: AnimationNode!
    var animationTimeLabel: SKLabelNode!
  
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.commonInit()
    }
    
    func commonInit() {
        
        guard let parser = SconParser(fileName: "BasicTests"),
            let animationData = parser.animationData() else {
            fatalError("Failed to load file")
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        animationManager = AnimationManager(animationData: animationData, textureLoader: self)
        animationNode = AnimationNode()
        
        guard animationNode.loadEntity("TestEntity", fromManager: animationManager) else {
            fatalError("Could not load entity")
        }
        
        self.addChild(animationNode)
        animationNode.animationNodeDelegate = self
        
        self.animationTimeLabel = SKLabelNode()
        self.animationTimeLabel.fontSize = 15
        self.animationTimeLabel.position = CGPoint(x: 10-self.size.width/2, y: 10-self.size.height/2)
        self.addChild(self.animationTimeLabel)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let className = NSStringFromClass(type(of: self))
        let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let animationName = className.replacingOccurrences(of: "\(ns).", with: "")
        guard self.animationNode.playAnimation(animationName) else {
            fatalError("Cannot play animation \(animationName)")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        self.animationManager.update(currentTime)
        self.animationTimeLabel.text = "Animation time (total \(self.animationNode.animationLength) sec): \(self.animationNode.currentAnimationTime)"
    }
    
    func textureNamed(_ textureName: String, path: String?) -> SKTexture? {
        //print("TextureLoader loads \(path) \(textureName)")
        return SKTexture(imageNamed: textureName)
    }
    
    func animationNodeDidFinishPlayback(animationNode: AnimationNode, looping: Bool) {
        //print("Animation did finish playback. Looping: \(looping)")
    }
}
