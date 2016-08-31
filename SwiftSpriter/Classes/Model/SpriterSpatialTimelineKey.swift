//
//  SpriterSpatialTimelineKey.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterSpatialTimelineKey: SpriterParseable {
    
    var timelineKey: SpriterTimelineKey
    var info: SpriterSpatialInfo
    
    init?(data: AnyObject) {
        return nil
    }
}
