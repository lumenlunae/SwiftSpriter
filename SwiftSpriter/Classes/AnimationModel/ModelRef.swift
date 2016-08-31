//
//  ModelRef.swift
//  SwiftSpriter
//
//  Created by Matt on 8/29/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

class ModelRef {
    var id: Int
    var time: TimeInterval = 0
    var objectRefs: [SpriterObjectRef] = []
    
    init(key: SpriterMainlineKey) {
        self.id = key.id
        self.time = key.time / 1000.0
        self.objectRefs = key.objectRefs
    }
    
    func objectRef(forTimelineID timelineID: Int) -> SpriterObjectRef? {
        let ref = objectRefs.first { (objectRef) -> Bool in
            return objectRef.timelineID == timelineID
        }
        return ref
    }
    
    func equals(time: TimeInterval) -> Bool {
        return ScalarNearOtherWithVariance(value: CGFloat(self.time), other: CGFloat(time), variance: 0.0001)
    }
}

extension ModelRef: CustomStringConvertible {
    public var description: String {
        return "ID: \(self.id) time: \(self.time)"
    }
}
