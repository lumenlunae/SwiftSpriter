//
//  SpriterBoneTimelineKey.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterBoneTimelineKey: SpriterParseable {
    
    var spatialTimelineKey: SpriterSpatialTimelineKey
    var length: Int = 200
    var width: Int = 10
    
    init?(data: AnyObject) {
        return nil
    }
}
