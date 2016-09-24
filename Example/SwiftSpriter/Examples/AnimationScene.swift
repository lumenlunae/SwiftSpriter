//
//  AnimationScene.swift
//  SwiftSpriterExample
//
//  Created by Matt on 8/30/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import UIKit
import SpriteKit
import SwiftSpriter

class AnimationScene: SKScene, TextureLoader, AnimationNodeDelegate {
    var fileName = ""
    var entityName = ""
    var animationManager: AnimationManager!
    var animationNode: AnimationNode!
    let animationTimeLabel = SKLabelNode()
    let animationNameLabel = SKLabelNode()
    var currentAnimationIndex = 0
    var animationNames = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.commonInit()
    }
    
    func commonInit() {
        
        guard let parser = SconParser(fileName: fileName),
            let animationData = parser.animationData() else {
                fatalError("Failed to load file")
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        animationManager = AnimationManager(animationData: animationData, textureLoader: self)
        animationNode = AnimationNode()
        
        guard animationNode.loadEntity(entityName, fromManager: animationManager) else {
            fatalError("Could not load entity")
        }
        
        self.addChild(animationNode)
        animationNode.animationNodeDelegate = self
        
        self.animationNames = self.animationManager.allAnimationNamesForEntity(entityName)
        guard self.animationNames.count > 0 else {
            fatalError("At least one animation should be there to play")
        }
        
        self.animationTimeLabel.fontSize = 15
        self.animationTimeLabel.position = CGPoint(x: 10-self.size.width/2, y: 10-self.size.height/2)
        self.animationTimeLabel.horizontalAlignmentMode = .left
        self.addChild(self.animationTimeLabel)
        
        self.animationNameLabel.fontSize = 20
        self.animationNameLabel.position = CGPoint(x: 0, y: self.size.height/2 - 100)
        self.animationNameLabel.horizontalAlignmentMode = .left
        self.addChild(self.animationNameLabel)
        
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.sizeToFit()
        button.layoutIfNeeded()
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.addTarget(self, action: #selector(tapNextBtn), for: .touchUpInside)
        view.layoutIfNeeded()
        self.startAnimation()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        self.animationManager.update(currentTime)
        self.animationTimeLabel.text = "Animation time (total \(self.animationNode.animationLength) sec): \(self.animationNode.currentAnimationTime)"
    }
    
    func textureNamed(_ textureName: String, path: String?) -> SKTexture? {
        //print("TextureLoader loads \(path) \(textureName)")
        let texture = SKTexture(imageNamed: textureName)
        return texture
    }
    
    func animationNodeDidFinishPlayback(animationNode: AnimationNode, looping: Bool) {
        //print("Animation did finish playback. Looping: \(looping)")
    }
    
    func tapNextBtn() {
        self.currentAnimationIndex += 1
        if (self.currentAnimationIndex >= self.animationNames.count) {
            self.currentAnimationIndex = 0
        }
        self.startAnimation()
    }
    
    func startAnimation() {
        let animationName = self.animationNames[self.currentAnimationIndex]
        guard self.animationNode.playAnimation(animationName) else {
            fatalError("Cannot play animation \(animationName)")
        }
        self.animationNode.loopAnimation = true
        self.animationNameLabel.text = animationName
    }
}
