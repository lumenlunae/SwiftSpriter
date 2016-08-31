//
//  SpriterSpriteTimelineKey.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterSpriteTimelineKey: SpriterParseable {
    
    var spatialTimelineKey: SpriterSpatialTimelineKey
    var folder: Int
    var file: Int
    var useDefaultPivot: Bool
    var pivotX: CGFloat
    var pivotY: CGFloat
    
    init?(data: AnyObject) {
        return nil
    }
}
