//
//  SceneViewController.swift
//  SwiftSpriter
//
//  Created by Matt on 8/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SpriteKit

class SceneViewController: UIViewController {
    var sceneName: String?
    let skView = SKView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.sceneName
        
        self.view.addSubview(self.skView)
        self.skView.translatesAutoresizingMaskIntoConstraints = false
        self.skView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.skView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.skView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.skView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.skView.showsFPS = true
        self.skView.showsNodeCount = true
        self.skView.showsDrawCount = true
        self.skView.ignoresSiblingOrder = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let sceneName = self.sceneName else {
            fatalError("Scene name required")
        }
        if skView.scene == nil {
            let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let className = "\(ns).\(sceneName)"
            let sceneClass = NSClassFromString(className) as! SKScene.Type
            let scene: SKScene = sceneClass.init(size: skView.bounds.size)
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.skView.presentScene(nil)
        
    }
}
