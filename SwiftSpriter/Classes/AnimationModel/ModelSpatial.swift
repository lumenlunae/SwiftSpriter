//
//  ModelSpatial.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import SpriteKit

class ModelSpatial: NSObject {
    
    var id: Int
    var idString: String
    var time: TimeInterval = 0
    
    var spatialType: SpriterSpatialType = .sprite
    var curveType: SpriterCurveType = .linear
    var nextSpatial: ModelSpatial?
    
    var nodeName: String?
    var node: SKNode?
    var parentNodeName: String?
    var parentTimelineID: Int?
    var parentSpatial: ModelSpatial?
    
    var timelineID: Int?
    var isHidden = false
    
    var positionX: CGFloat = 0
    var positionY: CGFloat = 0
    var scaleX: CGFloat = 1
    var scaleY: CGFloat = 1
    var alpha: CGFloat = 1
    var angle: CGFloat = 0
    var zIndex: CGFloat = 0
    
    var spin: SpriterSpinType = .none
    
    var textureID: String?
    var texture: ModelTexture?
    var pivotX: CGFloat = 0
    var pivotY: CGFloat = 1
    
    var actionsByName = [String: [SKAction]]()
    
    init(key: SpriterTimelineKey) {
        self.id = key.id
        self.idString = "\(id)"
        self.time = key.time / 1000.0
        self.isHidden = false
        self.curveType = key.curveType
    }
    
    init(modelSpatial: ModelSpatial) {
        self.id = modelSpatial.id
        self.idString = "\(self.id)+"
        self.time = modelSpatial.time
        self.spatialType = modelSpatial.spatialType
        self.nextSpatial = modelSpatial.nextSpatial
        self.nodeName = modelSpatial.nodeName
        self.parentNodeName = modelSpatial.parentNodeName
        self.parentTimelineID = modelSpatial.parentTimelineID
        self.timelineID = modelSpatial.timelineID
        self.isHidden = modelSpatial.isHidden
        
        self.positionX = modelSpatial.positionX
        self.positionY = modelSpatial.positionY
        
        self.scaleX = modelSpatial.scaleX
        self.scaleY = modelSpatial.scaleY
        
        self.alpha = modelSpatial.alpha
        self.angle = modelSpatial.angle
        
        self.spin = modelSpatial.spin
        
        self.texture = modelSpatial.texture
        
        self.pivotX = modelSpatial.pivotX
        self.pivotY = modelSpatial.pivotY
        self.zIndex = modelSpatial.zIndex
    }
    
    func update(withObject object: SpriterObject) {
        self.spatialType = .sprite
        
        self.positionX = object.positionX
        self.positionY = object.positionY
        self.scaleX = object.scaleX
        self.scaleY = object.scaleY
        self.alpha = object.alpha
        self.angle = CGFloat(GLKMathDegreesToRadians(Float(object.angle)))
    }
    
    func update(withBone object: SpriterBone) {
        self.spatialType = .node
        
        self.positionX = object.positionX
        self.positionY = object.positionY
        
        self.scaleX = object.scaleX
        self.scaleY = object.scaleY
        self.alpha = object.alpha
        
        self.angle = CGFloat(GLKMathDegreesToRadians(Float(object.angle)))
    }
    
    func equals(time: TimeInterval) -> Bool {
        return ScalarNearOtherWithVariance(value: CGFloat(self.time), other: CGFloat(time), variance: 0.0001)
    }
    
    func createNode(forManager manager: AnimationManager) -> SKNode? {
        let node: SKNode
        switch spatialType {
        case .sprite:
            guard let modelTexture = self.texture,
                let fileName = modelTexture.fileName,
                let texture = manager.textureNamed(fileName, path: modelTexture.relativePath) else {
                return nil
            }
            let size = CGSize(width: modelTexture.width, height: modelTexture.height)
            let sprite = SKSpriteNode(texture: texture, size: size)
            sprite.anchorPoint = CGPoint(x: self.pivotX, y: self.pivotY)
            sprite.zPosition = self.zIndex
            node = sprite
        case .node:
            // attempted SKEffectNode but performance went to hell
            node = SKNode()
        default:
            fatalError("Unknown spatial type")
        }
        
        node.name = self.nodeName
        node.isHidden = self.isHidden
   /*
        node.position = CGPoint(x: self.positionX, y: self.positionY)
        node.alpha = self.alpha
        node.zRotation = self.angle
        node.xScale = self.scaleX
        node.yScale = self.scaleY
*/
        self.node = node
        //self.setupNode()
        return node
    }
    
    func setupNode() {
        guard let node = self.node else {
            return
        }
        node.isHidden = self.isHidden
        
        node.position = CGPoint(x: self.positionX, y: self.positionY)
        node.alpha = self.alpha
        node.zRotation = self.angle
        node.xScale = self.scaleX
        node.yScale = self.scaleY
        
        if spatialType == .sprite {
            guard let spriteNode = node as? SKSpriteNode else {
                fatalError("Expected SKSpriteNode")
            }
            spriteNode.anchorPoint = CGPoint(x: self.pivotX, y: self.pivotY)
            spriteNode.zPosition = self.zIndex
        } else if spatialType == .node {
            
        }
    }
    
    func updateNode(_ node: SKNode, objectRef: SpriterObjectRef?, interpolation: CGFloat, animationManager: AnimationManager, currentTime: TimeInterval, isUsingActions: Bool = false) {
        guard let nextSpatial = self.nextSpatial,
            interpolation >= 0.0,
            interpolation <= 1.0,
            (self.time < nextSpatial.time || interpolation == 0.0) else {
                fatalError("Requires next spatial, interpolation range 0 to 1")
        }
        
        node.isHidden = self.isHidden
        if node.isHidden {
            return
        }
        
        
        if interpolation == 0.0 {
            node.alpha = self.alpha
            
            if !isUsingActions {
                node.position = CGPoint(x: self.positionX, y: self.positionY)
                node.zRotation = self.angle
            }
            
        } else {
            let alpha = LinearInterpolation(a: self.alpha, b: nextSpatial.alpha, t: interpolation)
            if node.alpha != alpha {
                node.alpha = alpha
            }
            
            if !isUsingActions {
                let nodePosX = LinearInterpolation(a: self.positionX, b: nextSpatial.positionX, t: interpolation)
                let nodePosY = LinearInterpolation(a: self.positionY, b: nextSpatial.positionY, t: interpolation)
                node.position = CGPoint(x: nodePosX, y: nodePosY)
                
                
                let spatialAngle = LinearAngleInterpolationRadian(angleA: self.angle, angleB: nextSpatial.angle, spin: self.spin.rawValue, t: interpolation)
                node.zRotation = spatialAngle
            }
        }
        
        // update node depending values
        if self.spatialType == .sprite {
            guard let spriteNode = node as? SKSpriteNode else {
                fatalError("Node expected to be a sprite node")
            }
            
            if interpolation == 0.0 {
                spriteNode.anchorPoint = CGPoint(x: self.pivotX, y: self.pivotY)
                
            } else {
                let anchorX = LinearInterpolation(a: self.pivotX, b: nextSpatial.pivotX, t: interpolation)
                let anchorY = LinearInterpolation(a: self.pivotY, b: nextSpatial.pivotY, t: interpolation)
                spriteNode.anchorPoint = CGPoint(x: anchorX, y: anchorY)
            }
            
            if !isUsingActions {
                if interpolation == 0.0 {
                    node.xScale = self.scaleX
                    node.yScale = self.scaleY
                } else {
                    node.xScale = LinearInterpolation(a: self.scaleX, b: nextSpatial.scaleX, t: interpolation)
                    node.yScale = LinearInterpolation(a: self.scaleY, b: nextSpatial.scaleY, t: interpolation)
                }
            }
            // set zIndex
            if let objectRef = objectRef,
                let zIndex = objectRef.zIndex {
                spriteNode.zPosition = CGFloat(zIndex)
            }
            
            if let fileName = self.texture?.fileName {
                let texture = animationManager.textureNamed(fileName, path: self.texture?.relativePath)
                if spriteNode.texture != texture {
                    spriteNode.texture = texture
                }
            }
        } else if self.spatialType == .node {
            // nothing
            /*
            
            */
        } else {
            fatalError("Unknown spatial type")
        }
    }
    
    func interpolationRatio(forTime time: TimeInterval) -> CGFloat {
        guard let nextSpatial = self.nextSpatial,
            (time < nextSpatial.time || self.equals(time: time)),
            (time >= self.time && time <= nextSpatial.time) else {
                fatalError("Needs next spatial and correct interpolation")
        }
        
        return CGFloat((time - self.time) / (nextSpatial.time - self.time))
    }
    
    func createActions(for name: String) {
        guard self.actionsByName[name] == nil else {
            return
        }
        // loop through all your spatials
        var actions = [SKAction]()
        guard var next = nextSpatial else {
            return
        }
        
        var cur: ModelSpatial = self
        while next.idString != "0" {
            let duration = next.time - cur.time
            var group = [SKAction]()
            
            let moveAction = SKAction.move(to: CGPoint(x: next.positionX, y: next.positionY), duration: duration)
            if self.curveType == .instant {
                moveAction.timingFunction = self.instantTimingFunction
            }
            
            group.append(moveAction)
            if cur.angle != next.angle {
                var angle = next.angle
                if spin == .clockwise {
                    //angle = angle - cur.angle
                    
                } else {
                    
                    //angle = cur.angle - angle
                }
                if spin == .clockwise {
                    if next.angle < cur.angle {
                        angle += CGFloat(2 * M_PI)
                    }
                } else if spin == .counterClockwise {
                    if next.angle > cur.angle {
                        angle -= CGFloat(2 * M_PI)
                    }
                } else {
                    angle = next.angle
                }
                //group.append(SKAction.rotate(byAngle: angle, duration: duration))
                group.append(SKAction.rotate(toAngle: angle, duration: duration, shortestUnitArc: true))
            }
            if cur.scaleX != next.scaleX {
                let scaleX = SKAction.scaleX(to: next.scaleX, duration: duration)
                if self.curveType == .instant {
                    scaleX.timingFunction = self.instantTimingFunction
                }
                group.append(scaleX)
            }
            if cur.scaleY != next.scaleY {
                let scaleY = SKAction.scaleY(to: next.scaleY, duration: duration)
                scaleY
                group.append(scaleY)
            }

            if group.count > 0 {
                actions.append(SKAction.group(group))
            }
            
            cur = next
            next = next.nextSpatial!
        }
        self.actionsByName[name] = actions
    }
    
    func transform(withParent parent: ModelSpatial) {
        self.parentSpatial = parent
        
        // parent updated, so update this spatial
     
        
        var parentAngle: CGFloat = 0
        var parentScaleX: CGFloat = 1
        var parentScaleY: CGFloat = 1
        var parentPosX: CGFloat = 0
        var parentPosY: CGFloat = 0
        parentAngle = parent.angle
        
        parentScaleX = parent.scaleX
        parentScaleY = parent.scaleY
        parentPosX = parent.positionX
        parentPosY = parent.positionY
        
        self.scaleX *= parentScaleX
        self.scaleY *= parentScaleY
        self.positionX *= parentScaleX
        self.positionY *= parentScaleY
    }
    
    static func composeName(withTimelineID timelineID:Int, animationID: Int, entityID: Int) -> String {
        return "Spatial_\(entityID)_\(animationID)_\(timelineID)"
    }
    
    func instantTimingFunction(time: Float) -> Float {
        if time == 1.0 {
            return 1.0
        }
        return 0.99999
    }
}

extension ModelSpatial {
    
    override public var description: String {
        return "Spatial: \(self.idString) Next: \(self.nextSpatial?.idString) Type: \(self.spatialType) Name: \(self.nodeName) Parent: \(self.parentNodeName) Time: \(self.time) Pos: \(self.positionX),\(self.positionY), Scale: \(self.scaleX),\(self.scaleY) Alpha: \(self.alpha) Hidden: \(self.isHidden) Angle: \(self.angle) Spin: \(self.spin) Pivot: \(self.pivotX),\(self.pivotY) z: \(self.zIndex)\n"
    }
    
}
