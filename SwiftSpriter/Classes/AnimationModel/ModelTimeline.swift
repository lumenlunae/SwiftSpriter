//
//  ModelTimeline.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

class ModelTimeline {
    
    var id: Int
    var spatialsByTime = [ModelSpatial]()
    
    init(spriterTimeline: SpriterTimeline) {
        self.id = spriterTimeline.id
    }
    
    func spatial(forTime time: TimeInterval) -> ModelSpatial? {
        guard spatialsByTime.count > 0 else {
            return nil
        }
        
        var spatial: ModelSpatial?
        var startIndex = 0
        var endIndex = self.spatialsByTime.count - 1
        while startIndex <= endIndex {
            var midIndex = (startIndex + endIndex) / 2
            var currentSpatial = self.spatialsByTime[midIndex]
            if currentSpatial.equals(time: time) {
                spatial = currentSpatial
                while midIndex < endIndex {
                    midIndex += 1
                    currentSpatial = self.spatialsByTime[midIndex]
                    if currentSpatial.equals(time: time) {
                        spatial = currentSpatial
                    } else {
                        break
                    }
                }
                break
            } else if currentSpatial.time < time {
                startIndex = midIndex + 1
                if startIndex > endIndex {
                    spatial = self.spatialsByTime[endIndex]
                    break
                }
            } else if currentSpatial.time > time {
                endIndex = midIndex - 1
                if startIndex > endIndex {
                    if startIndex == 0 {
                        spatial = self.spatialsByTime[0]
                    } else {
                        spatial = self.spatialsByTime[startIndex-1]
                    }
                    break
                }
            } else {
                fatalError("Impossible state")
            }
        }
        
        return spatial
    }
}

extension ModelTimeline: CustomStringConvertible {
    public var description: String {
        return "Timeline \(self.id):\n\(self.spatialsByTime)"
    }
}
