//
//  SpriterSpatialInfo.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import UIKit

struct SpriterSpatialInfo: SpriterParseable {
    
    var x: CGFloat
    var y: CGFloat
    var angle: CGFloat
    var scaleX: CGFloat
    var scaleY: CGFloat
    var alpha: CGFloat
    var spin: SpriterSpinType
    
    init?(data: AnyObject) {
        return nil
    }
}
