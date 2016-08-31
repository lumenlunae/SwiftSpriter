//
//  ModelMainline.swift
//  SwiftSpriter
//
//  Created by Matt on 8/29/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

class ModelMainline {
    var refsByTime = [ModelRef]()
    
    init(keys: [SpriterMainlineKey]) {
        for key in keys {
            let ref = ModelRef(key: key)
            refsByTime.append(ref)
        }
    }
    
    func ref(forTime time: TimeInterval) -> ModelRef? {
        guard refsByTime.count > 0 else {
            return nil
        }
        
        var ref: ModelRef?
        var startIndex = 0
        var endIndex = self.refsByTime.count - 1
        while startIndex <= endIndex {
            var midIndex = (startIndex + endIndex) / 2
            var currentRef = self.refsByTime[midIndex]
            if currentRef.equals(time: time) {
                ref = currentRef
                while midIndex < endIndex {
                    midIndex += 1
                    currentRef = self.refsByTime[midIndex]
                    if currentRef.equals(time: time) {
                        ref = currentRef
                    } else {
                        break
                    }
                }
                break
            } else if currentRef.time < time {
                startIndex = midIndex + 1
                if startIndex > endIndex {
                    ref = self.refsByTime[endIndex]
                    break
                }
            } else if currentRef.time > time {
                endIndex = midIndex - 1
                if startIndex > endIndex {
                    if startIndex == 0 {
                        ref = self.refsByTime[0]
                    } else {
                        ref = self.refsByTime[startIndex-1]
                    }
                    break
                }
            } else {
                fatalError("Impossible state")
            }
        }
        
        return ref
    }
}
