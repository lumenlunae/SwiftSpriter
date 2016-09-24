//
//  SpriterTimelineKey.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import UIKit

struct SpriterTimelineKey: SpriterParseable {
    
    var id: Int
    var time: TimeInterval = 0
    var spin: SpriterSpinType = .clockwise
    var curveType: SpriterCurveType = .linear
    var c1: CGFloat?
    var c2: CGFloat?
    var object: SpriterObject?
    var bone: SpriterBone?
    
    init?(data: AnyObject) {
        guard let id = data.value(forKey: "id") as? Int else {
                return nil
        }
        
        self.id = id
        
        if let time = data.value(forKey: "time") as? TimeInterval {
            self.time = time
        }
        if let spinInt = data.value(forKey: "spin") as? Int,
            let spin = SpriterSpinType(rawValue: spinInt) {
            self.spin = spin
        }
        
        if let curveTypeInt = data.value(forKey: "curve_type") as? Int,
            let curveType = SpriterCurveType(rawValue: curveTypeInt) {
            self.curveType = curveType
        }
        
        if let c1 = data.value(forKey: "c1") as? CGFloat,
            let c2 = data.value(forKey: "c2") as? CGFloat {
            self.c1 = c1
            self.c2 = c2
        }
    }
}
