//
//  AnimationManager.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import SpriteKit

public protocol TextureLoader {
    func textureNamed(_ textureName: String, path: String?) -> SKTexture?
    func textureAtlases(animationManager: AnimationManager) -> [SKTextureAtlas]?
}

public extension TextureLoader {
    func textureAtlases(animationManager: AnimationManager) -> [SKTextureAtlas]? {
        return nil
    }
}

public class AnimationManager {
    public let animationData: ModelData
    var animationNodes = [AnimationNode]()
    var lastSystemTime: TimeInterval
    var textureCache: NSCache<NSString, SKTexture>
    let textureLoader: TextureLoader?
    var textureAtlases: [SKTextureAtlas]?
    
    public init(animationData: ModelData, textureLoader: TextureLoader?, entityName: String? = nil) {
        self.animationData = animationData
        self.textureLoader = textureLoader
        
        self.textureCache = NSCache()
        self.lastSystemTime = 0
        
        let delegateAtlases = textureLoader?.textureAtlases(animationManager: self)
        if let delegateAtlases = delegateAtlases {
            textureAtlases = delegateAtlases
        } else  if let atlasNames = self.animationData.atlasNames {
            var atlases = [SKTextureAtlas]()
            for atlasName in atlasNames {
                let atlas = SKTextureAtlas(named: atlasName)
                atlases.append(atlas)
            }
            if atlases.count > 0 {
                textureAtlases = atlases
            } else {
                textureAtlases = nil
            }
        } else {
            textureAtlases = nil
        }
        
        // this is for overwriting the file's entity name with another value
        // only if there is one entity in the file
        if let entityName = entityName,
            self.animationData.entitiesByName.count == 1,
            let oldKey = self.animationData.entitiesByName.keys.first,
            oldKey != entityName {
            
            let value = self.animationData.entitiesByName[oldKey]
            self.animationData.entitiesByName[entityName] = value
            self.animationData.entitiesByName.removeValue(forKey: oldKey)
            
        }
    }
    
    public func update(_ currentTime: TimeInterval) {
        var deltaTime: TimeInterval = 0
        if self.lastSystemTime > 0{
            deltaTime = currentTime - self.lastSystemTime
        }
        self.lastSystemTime = currentTime
        
        for node in self.animationNodes {
            node.updateTime(deltaTime: deltaTime)
        }
    }
    
    public func allEntityNames() -> [String] {
        return Array(self.animationData.entitiesByName.keys)
    }
    
    public func allAnimationNamesForEntity(_ entityName: String) -> [String] {
        guard let entity = self.animationData.entitiesByName[entityName] else {
            return []
        }
        return Array(entity.animationsByName.keys)
    }
    
    public func allTextureNames() -> [String: [String]] {
        var paths = [String: [String]]()
        for texture in animationData.texturesByID.values {
            if let relativePath = texture.relativePath {
                var fileNames = paths[relativePath]
                if fileNames == nil {
                    fileNames = []
                    paths[relativePath] = fileNames
                }
                if let fileName = texture.fileName {
                    fileNames!.append(fileName)
                }
            }
        }
        return paths
    }
    
    func entityNamed(_ entityName: String) -> ModelEntity? {
        return self.animationData.entitiesByName[entityName]
    }
    
    func addAnimationNode(_ animationNode: AnimationNode) {
        self.animationNodes.append(animationNode)
    }
    
    func removeAnimationNode(_ animationNode: AnimationNode) {
        if let idx = self.animationNodes.index(of: animationNode) {
            self.animationNodes.remove(at: idx)
        }
    }
    
    func textureNamed(_ textureName: String, path: String?) -> SKTexture? {
        let key: NSString
        if let keyPath = path, keyPath.characters.count > 0 {
            key = NSString(string: keyPath.appending("/\(textureName)"))
        } else {
            key = NSString(string: textureName)
        }
        
        // Try SKTextureAtlas first
        if let textureAtlases = self.textureAtlases {
            for atlas in textureAtlases {
                if atlas.textureNames.contains(key as String) {
                    let texture = atlas.textureNamed(key as String)
                    //texture.filteringMode = .nearest
                    //texture.usesMipmaps = true;
                    return texture
                }
            }
        }
        
        // Then try the cache
        let texture = self.textureCache.object(forKey: key)
        if texture != nil {
           return texture
        }
        
        // Then call SKTexture on delegate
        if let texture = self.textureLoader?.textureNamed(textureName, path: path) {
            self.textureCache.setObject(texture, forKey: key)
            //texture.filteringMode = .nearest
            //texture.usesMipmaps = true;
            return texture
        }
        
        return nil
    }
}
