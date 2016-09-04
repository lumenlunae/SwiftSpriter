//
//  AnimationNode.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import SpriteKit

public protocol AnimationNodeDelegate {
    func animationNodeDidFinishPlayback(animationNode: AnimationNode, looping: Bool)
}

public class AnimationNode: SKNode {
    
    var animationManager: AnimationManager?
    var entity: ModelEntity?
    var animation: ModelAnimation?
    var currentAnimationName: String? {
        return self.animation?.name
    }
    public var animationSpeed: CGFloat = 1.0
    
    public var animationLength: TimeInterval = 0
    public var loopAnimation: Bool = false
    var animationPlayback: Bool = false
    public var animationNodeDelegate: AnimationNodeDelegate?
    
    var isUsingActions = true

    public func loadEntity(_ entityName: String, fromManager manager: AnimationManager) -> Bool {
        self.animationManager?.removeAnimationNode(self)
        
        self.animationManager = manager
        guard let entity = self.animationManager?.entityNamed(entityName) else  {
            return false
        }
        
        self.entity = entity
        self.animationManager?.addAnimationNode(self)
        return true
        
    }
    
    public func playAnimation(_ animationName: String) -> Bool {
        if self.animation != nil {
            self.stopAnimation()
        }
        
        guard let animation = self.entity?.animationsByName[animationName] else {
            self.animation = nil
            return false
        }
        
        self.animation = animation
        self.animationLength = animation.length
        if animationName == "Dying" {
            animation.isLooping = false
        }
        self.loopAnimation = animation.isLooping
        self.buildNodeTreeFromTimelines(animationName: animationName)
        self.currentAnimationTime = 0
        self.animationPlayback = true
        
        return true
    }
    
    public func stopAnimation() {
        self.animation = nil
        self.animationPlayback = false
        self.removeAllChildren()
    }
    
    public var currentAnimationTime: TimeInterval = 0 {
        didSet {
            self.animationPlayback = true
            var animationEndReached = false
            var animationLooped = false
            
            if self.animationLength == 0.0 {
                currentAnimationTime = 0.0
                self.animationPlayback = false
                animationEndReached = true
            } else if self.currentAnimationTime >= self.animationLength {
                animationEndReached = true
                if self.loopAnimation {
                    currentAnimationTime -= self.animationLength * floor(self.currentAnimationTime / self.animationLength)
                    animationLooped = true
                } else {
                    // stop at last keyframe
                    currentAnimationTime = self.animationLength
                    self.animationPlayback = false
                }
            } else if self.currentAnimationTime < 0.0 {
                // animation time below zero
                animationEndReached = true
                if self.loopAnimation {
                    currentAnimationTime += self.animationLength * (1 + floor(-self.currentAnimationTime / self.animationLength))
                    animationLooped = true
                } else {
                    currentAnimationTime = 0.0
                    self.animationPlayback = false
                }
            }
            
            self.updateNodes()
            if animationEndReached {
                self.animationNodeDelegate?.animationNodeDidFinishPlayback(animationNode: self, looping: animationLooped)
            }
        }
    }
    
    func buildNodeTreeFromTimelines(animationName: String) {
        guard let animation = self.animation,
            let manager = self.animationManager else {
            fatalError("Animation required")
        }
        
        // first build nodes and actions
        for timeline in animation.timelinesByID.values {
            let spatial = timeline.spatialsByTime[0]
            if isUsingActions {
                spatial.createActions(for: animationName)
            }
            if let node = spatial.createNode(forManager: manager) {
                self.addChild(node)
                if self.isUsingActions {
                    spatial.setupNode()
                    if let actions = spatial.actionsByName[animationName], actions.count > 0 {
                        if self.loopAnimation {
                            var repeatActions = SKAction.repeatForever(SKAction.sequence(actions))
                            node.run(repeatActions)
                        } else {
                            node.run(SKAction.sequence(actions))
                        }
                    }
                }
            }
        }
    }


    func updateTime(deltaTime: TimeInterval) {
        if !self.animationPlayback || self.animation == nil {
            return
        }
        
        self.currentAnimationTime += deltaTime * TimeInterval(self.animationSpeed)
    }
    
    func updateNodes() {
        guard let animation = self.animation,
            let manager = self.animationManager else {
            return
        }
        
        for timeline in animation.timelinesByID.values {
            guard let spatial = timeline.spatial(forTime: self.currentAnimationTime) else {
                fatalError("Should find spatial")
                return
            }
            
            guard let mainlineRef = animation.mainline?.ref(forTime: self.currentAnimationTime) else {
                fatalError("Should be a mainline ref")
            }
            
            guard let nodeName = spatial.nodeName else {
                continue
            }
            
            let spatialNode: SKNode
            if let node = spatial.node {
                spatialNode = node
            } else {
                let searchString = "//\(nodeName)"
                guard let searchedNode = self.childNode(withName: searchString) else {
                    fatalError("There should be a node for each spatial")
                    return
                }
                spatialNode = searchedNode
            }
            
            if spatial.parentNodeName == nil {
                // no parent, move to root if not already
                if spatialNode.parent != nil && spatialNode.parent != self {
                    spatialNode.removeFromParent()
                    self.addChild(spatialNode)
                }
            } else {
                if spatial.parentNodeName != spatialNode.parent?.name {
                    guard let parentNodeName = spatial.parentNodeName else {
                        continue
                    }
                    let searchString = "//\(parentNodeName)"
                    guard let parentNode = self.childNode(withName: searchString) else {
                        fatalError("There should be a parent node")
                    }
                    
                    spatialNode.removeFromParent()
                    parentNode.addChild(spatialNode)
                }
            }
            
            var objectRef: SpriterObjectRef? = nil
            if let timelineID = spatial.timelineID {
                objectRef = mainlineRef.objectRef(forTimelineID: timelineID)
            }
            
            if spatial.equals(time: self.currentAnimationTime) {
                spatial.updateNode(spatialNode, objectRef: objectRef, interpolation: 0.0, animationManager: manager, currentTime: self.currentAnimationTime, isUsingActions: self.isUsingActions)
            } else {
                let interpolation = spatial.interpolationRatio(forTime: self.currentAnimationTime)
                spatial.updateNode(spatialNode, objectRef: objectRef, interpolation: interpolation, animationManager: manager, currentTime: self.currentAnimationTime, isUsingActions: self.isUsingActions)
            }
        }
    }
}
