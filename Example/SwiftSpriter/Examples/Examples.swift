//
//  Examples.swift
//  SwiftSpriterExample
//
//  Created by Matt on 8/28/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftSpriter

class TextureReplacement: BasicTestScene {
    
}

class TexturePivotChanges: BasicTestScene {
    override init(size: CGSize) {
        super.init(size: size)
        let origin = SKSpriteNode(color: SKColor.white, size: CGSize(width: 3, height: 3))
        self.addChild(origin)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SimplePositionTranslation: BasicTestScene {
    
}

class SynchronMovement: BasicTestScene {
    
}

class ScaleAndPivot: BasicTestScene {
    
}

class ChangePositionScaleAngleAlpha: BasicTestScene {
    
}

class NegativeAnimationSpeed: BasicTestScene {
    override init(size: CGSize) {
        super.init(size: size)
        self.animationNode.animationSpeed = -1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NonLoopingAnimation: BasicTestScene {
    
}

class DisableAnimationLooping: BasicTestScene {
    override init(size: CGSize) {
        super.init(size: size)
        let label = SKLabelNode()
        label.fontSize = 20
        label.text = "The head should end in the start position (facing normally in a horizontal position)"
        label.position = CGPoint(x:0, y: size.height/2 - 100)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        guard self.animationNode.loopAnimation else {
            fatalError("Normally this node should be designed for looping")
        }
        
        self.animationNode.loopAnimation = false
    }
}

class LoopANonLoopingAnimation: BasicTestScene {
    override init(size: CGSize) {
        super.init(size: size)
        let label = SKLabelNode()
        label.fontSize = 20
        label.text = "The head should jump back to the start position without any smooth animation"
        label.position = CGPoint(x:0, y: size.height/2 - 100)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        guard self.animationNode.loopAnimation == false else {
            fatalError("Normally this node should not be designed for looping")
        }
        
        self.animationNode.loopAnimation = true
    }
}

class SimpleBoneAnimation: BasicTestScene {
    
}
class SimpleMultiBoneAnimation: BasicTestScene {
    
}

class ComplexBoneAnimation: BasicTestScene {
    
}

class BoneScale: BasicTestScene {
    
}

class ZOrderChanges: BasicTestScene {
    override init(size: CGSize) {
        super.init(size: size)
        let label = SKLabelNode()
        label.fontSize = 20
        label.text = "The z-order of some parts should change, but that's not implemented."
        label.position = CGPoint(x:0, y: size.height/2 - 100)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BoneScale2: SKScene {
    var angle: CGFloat = 0
    var nodes = [SKNode]()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.commonInit()
    }
    
    func commonInit() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let main = SKNode()
        
        
        let node1 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 1, height: 1))
        node1.position = CGPoint(x: 100, y: 100)
        node1.xScale = 0.1852
        // 153
        node1.zRotation = 2.7
        node1.position = CGPoint(x: 0, y: 5)
    
        let node2 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 1, height: 1))
        node2.xScale = 1.322
        // 336
        node2.zRotation = 5.9
        node2.position = CGPoint(x: 207, y: 1.5)
        
        let node3 = SKSpriteNode(color: UIColor.red, size: CGSize(width: 1, height: 1))
        node3.xScale = 0.815
        // 97
        node3.zRotation = 1.7
        node3.position = CGPoint(x: 184, y: 13)
        
        let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "p_arm_idle"))
        sprite.xScale = 5
        //  62
        sprite.zRotation = 1.08
        //sprite.anchorPoint = CGPoint(x: 0.338, y: 0.509)
        sprite.position = CGPoint(x: 60, y: 1.5)
        
        /*
        self.addChild(node1)
        self.addChild(node2)
        self.addChild(node3)
        self.addChild(sprite)
        
        node3.removeFromParent()
        node2.addChild(node3)
        
        node1.removeFromParent()
        self.addChild(node1)
        
        sprite.removeFromParent()
        node3.addChild(sprite)
        
        node2.removeFromParent()
        node1.addChild(node2)
        */
        
        /*
        self.addChild(node1)
        node1.addChild(node2)
        node2.addChild(node3)
        node3.addChild(sprite)
        */
        
        node3.addChild(sprite)
        node2.addChild(node3)
        node1.addChild(node2)
        main.addChild(node1)
        self.addChild(main)
        
        nodes = [node1, node2, node3, sprite]
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let random = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        //let angle = random * 6.28
        
        //let idx = Int(arc4random_uniform(UInt32(4)))
        self.angle += 0.1
        let node = nodes.last!
        node.zRotation = self.angle
        
        
        print("Random angle \(angle)\n\(node)")
    }
}
