//
//  SpriterParser.swift
//  SwiftSpriter
//
//  Created by Matt on 8/26/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import SpriteKit

public protocol SpriterParser {
    
    var fileName: String? { get set }
    var fileVersion: String? { get set }
    var generator: String? { get set }
    var generatorVersion: String? { get set}
    var spriterData: SpriterData? { get set }
    
    var fileNameExtension: String { get }
    
    func parse(fileName: String) throws
    func parse(fileContent: Data) throws
    func animationData() -> ModelData?
}

extension SpriterParser {
    
    private func resetProperties() {
        
    }
    
    public func parse(fileName: String) throws {
        
        let filePath = Bundle.main.path(forResource: fileName, ofType: self.fileNameExtension)
        let fileURL = URL(fileURLWithPath: filePath!)
        let data = try Data(contentsOf: fileURL)
        
        try self.parse(fileContent: data)
        
    }
    
    func parse(spriterData: Data) throws {
        try self.parse(fileContent: spriterData)
    }
    
    public func animationData() -> ModelData? {
        guard let spriterData = spriterData else {
            return nil
        }
        
        let data = ModelData()
        for folder in spriterData.folders {
            for file in folder.files {
                let texture = ModelTexture()
                let textureID = "\(folder.id)_\(file.id)"
                texture.textureID = textureID
                texture.width = file.width
                texture.height = file.height
                texture.relativePath = folder.name
                let folderName = "\(folder.name)/"
                texture.fileName = file.name.replacingOccurrences(of: folderName, with: "")
                data.texturesByID[textureID] = texture
            }
        }
        
        for spriterEntity in spriterData.entities {
            let entity = ModelEntity()
            let name = spriterEntity.name
            entity.name = name
            data.entitiesByName[name] = entity
            
            for spriterAnimation in spriterEntity.animations {
                let animation = ModelAnimation(spriterAnimation: spriterAnimation)
                entity.animationsByName[animation.name] = animation
                
                for spriterTimeline in spriterAnimation.timelines {
                    let timeline = ModelTimeline(spriterTimeline: spriterTimeline)
                    animation.timelinesByID[timeline.id] = timeline
                    
                    let spatialName = ModelSpatial.composeName(withTimelineID: spriterTimeline.id, animationID: spriterAnimation.id, entityID: spriterEntity.id)
                    
                    var spatialsByTime = [ModelSpatial]()
                    
                    for spriterKey in spriterTimeline.keys {
                        let spatial = ModelSpatial(key: spriterKey)
                        spatialsByTime.append(spatial)
                        spatial.nodeName = spatialName
                        spatial.timelineID = spriterTimeline.id
                        if let object = spriterKey.object {
                            spatial.update(withObject: object)
                            spatial.spin = spriterKey.spin
                            spatial.textureID = "\(object.folderID)_\(object.fileID)"
                            
                            if let textureID = spatial.textureID {
                                spatial.texture = data.texturesByID[textureID]
                            }
                            
                            guard let spriterFile = self.spriterFile(withFileID: object.fileID, folderID: object.folderID) else {
                                fatalError("Spriter file should exist")
                            }
                            
                            if object.pivotX == SpriterObjectNoPivotValue {
                                spatial.pivotX = spriterFile.pivotX
                            } else {
                                spatial.pivotX = object.pivotX
                            }
                            
                            if object.pivotY == SpriterObjectNoPivotValue {
                                spatial.pivotY = spriterFile.pivotY
                            } else {
                                spatial.pivotY = object.pivotY
                            }
                        } else if let bone = spriterKey.bone {
                            spatial.update(withBone: bone)
                            spatial.spin = spriterKey.spin
                        } else {
                            fatalError("Unsupported spatial type")
                        }
                        
                        guard spatialsByTime.count > 0 else {
                            fatalError("Requires at least one spatial")
                        }
                        timeline.spatialsByTime = spatialsByTime
                    }
                    
                    guard animation.timelinesByID.count > 0 else {
                        fatalError("Requires at least one timeline")
                    }
                }
                
                if let mainlineKeys = spriterAnimation.mainline?.keys {
                    animation.mainline = ModelMainline(keys: mainlineKeys)
                    
                    for spriterKey in mainlineKeys {
                        for spriterObjectRef in spriterKey.objectRefs {
                            self.updateSpatial(forMainlineKey: spriterKey, spriterTimelineID: spriterObjectRef.timelineID, spriterParentID: spriterObjectRef.parentID, timelinesByID: animation.timelinesByID, spriterZIndex: spriterObjectRef.zIndex)
                        }
                        
                        for spriterBoneRef in spriterKey.boneRefs {
                            self.updateSpatial(forMainlineKey: spriterKey, spriterTimelineID: spriterBoneRef.timelineID, spriterParentID: spriterBoneRef.parentID, timelinesByID: animation.timelinesByID)
                        }
                    }
                    
                    for timeline in animation.timelinesByID.values {
                        var firstSpatial = timeline.spatialsByTime[0]
                        if !firstSpatial.equals(time: 0.0) {
                            let zeroSpatial = ModelSpatial(modelSpatial: firstSpatial)
                            zeroSpatial.time = 0.0
                            zeroSpatial.isHidden = true
                            timeline.spatialsByTime.insert(zeroSpatial, at: 0)
                            firstSpatial = zeroSpatial
                        }
                        if let endSpatial = timeline.spatialsByTime.last {
                            if !endSpatial.equals(time: animation.length) {
                                if animation.isLooping {
                                    // insert a copy of the first as the last
                                    let spatial = ModelSpatial(modelSpatial: firstSpatial)
                                    spatial.time = animation.length
                                    timeline.spatialsByTime.append(spatial)
                                    
                                    // if pivot changes the pivot of the first keyframe is not correct
                                    spatial.pivotX = endSpatial.pivotX
                                    spatial.pivotY = endSpatial.pivotY
                                } else {
                                    // insert a copy of the last frame as a new frame
                                    let spatial = ModelSpatial(modelSpatial: endSpatial)
                                    spatial.time = animation.length
                                    timeline.spatialsByTime.append(spatial)
                                }
                            }
                        }
                        
                        // create shortcut links between spatials
                        for idx in 0..<timeline.spatialsByTime.count-1 {
                            let spatial = timeline.spatialsByTime[idx]
                            spatial.nextSpatial = timeline.spatialsByTime[idx+1]
                        }
                        
                        // always connect the last with the first spatial regardless of the current looping state
                        if let lastSpatial = timeline.spatialsByTime.last {
                            lastSpatial.nextSpatial = timeline.spatialsByTime.first
                        }
                    }
                    
                    // add any hiding spatials
                    let timelineIDs: [Int] = Array(animation.timelinesByID.keys)
                    if let spriterMainlineKeys = spriterAnimation.mainline?.keys {
                        for spriterMainlineKey in spriterMainlineKeys {
                            
                            // add refs to animation
                            var unusedTimelineIDs = timelineIDs
                            for spriterObjectRef in spriterMainlineKey.objectRefs {
                                if let idx = unusedTimelineIDs.index(of: spriterObjectRef.timelineID) {
                                    unusedTimelineIDs.remove(at: idx)
                                }
                            }
                            for spriterBoneRef in spriterMainlineKey.boneRefs {
                                if let idx = unusedTimelineIDs.index(of: spriterBoneRef.timelineID) {
                                    unusedTimelineIDs.remove(at: idx)
                                }
                            }
                            
                            // add hiding spatials for the unused IDs
                            for timelineID in unusedTimelineIDs {
                                if let timeline = animation.timelinesByID[timelineID]  {
                                    self.addHiddenSpatial(to: timeline, at: spriterMainlineKey.time)
                                }
                            }
                        }
                    }
                    
                    // update position and scale values
                    // TODO optimize cycle
                    var updatedSpatials = Set<ModelSpatial>()
                    var cycle = true
                    while cycle {
                        cycle = false
                        for timeline in animation.timelinesByID.values {
                            for spatial in timeline.spatialsByTime {
                                
                                if updatedSpatials.contains(spatial) {
                                    // already updated
                                } else if spatial.parentNodeName == nil {
                                    updatedSpatials.insert(spatial)
                                    cycle = true
                                } else {
                                    if let parentTimelineID = spatial.parentTimelineID {
                                        let parentTimeline = animation.timelinesByID[parentTimelineID]
                                        guard let parentSpatial = parentTimeline?.spatial(forTime: spatial.time) else {
                                            fatalError("There must always be a parent spatial")
                                        }
                                        if !updatedSpatials.contains(parentSpatial) {
                                            continue
                                        }
                                        spatial.transform(withParent: parentSpatial)
                                        
 
                                        updatedSpatials.insert(spatial)
                                        cycle = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return data
    }
    
    func spriterFile(withFileID fileID: Int, folderID: Int) -> SpriterFile? {
        guard let folder = self.spriterData?.folders.first(where: { inFolder -> Bool in
            return inFolder.id == folderID
        }) else {
            return nil
        }
        
        let file = folder.files.first { (file) -> Bool in
            return file.id == fileID
        }
        
        return file
    }
    
    
    func updateSpatial(forMainlineKey spriterMainlineKey: SpriterMainlineKey, spriterTimelineID: Int, spriterParentID: Int, timelinesByID: [Int: ModelTimeline], spriterZIndex: Int? = nil) {
        guard let timeline = timelinesByID[spriterTimelineID] else {
            fatalError("Timeline expected")
        }
        
        let time = spriterMainlineKey.time / 1000.0
        guard let spatial = timeline.spatial(forTime: time) else {
            fatalError("Spatial expected")
        }
        
        if spriterParentID == SpriterRefNoParentValue {
            // no parent
            spatial.parentNodeName = nil
            spatial.parentTimelineID = nil
        } else {
            // has parent
            guard let parentRef = spriterMainlineKey.boneRefs.first(where: { (boneRef) -> Bool in
                return boneRef.id == spriterParentID
            }) else {
                fatalError("Reference should point to a bone")
            }
            
            guard let parentTimeline = timelinesByID[parentRef.timelineID],
                let parentSpatial = parentTimeline.spatial(forTime: time) else {
                fatalError("No parent timeline or spatial found")
            }
            
            spatial.parentNodeName = parentSpatial.nodeName
            spatial.parentTimelineID = parentTimeline.id
        }
        
        if let zIndex = spriterZIndex {
            spatial.zIndex = CGFloat(zIndex)
        }
    }
    
    func addHiddenSpatial(to timeline: ModelTimeline, at spriterTime: TimeInterval) {
        let time = spriterTime / 1000.0
        guard let spatial = timeline.spatial(forTime: time) else {
            fatalError("Spatial expected")
        }
        if spatial.equals(time: time) {
            return
        }
        
        guard let idx = timeline.spatialsByTime.index(of: spatial) else {
            fatalError("Spatial should have an index")
        }
        
        let newSpatial = ModelSpatial(modelSpatial: spatial)
        newSpatial.time = time
        newSpatial.isHidden = true
        spatial.nextSpatial = newSpatial
        
        timeline.spatialsByTime.insert(newSpatial, at: idx + 1)
    }
    
}
