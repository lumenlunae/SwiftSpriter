//
//  SpriterBone.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterBone: SpriterParseable {
    
    var positionX: CGFloat = 0
    var positionY: CGFloat = 0
    var angle: CGFloat = 0
    var scaleX: CGFloat = 1
    var scaleY: CGFloat = 1
    var alpha: CGFloat = 1
    
    init?(data: AnyObject) {
        if let x = data.value(forKey: "x") as? CGFloat {
            self.positionX = x
        }
        
        if let y = data.value(forKey: "y") as? CGFloat {
            self.positionY = y
        }
        
        if let angle = data.value(forKey: "angle") as? CGFloat {
            self.angle = angle
        }
        
        if let scaleX = data.value(forKey: "scale_x") as? CGFloat {
            self.scaleX = scaleX
        }
        
        if let scaleY = data.value(forKey: "scale_y") as? CGFloat {
            self.scaleY = scaleY
        }
        
        if let alpha = data.value(forKey: "a") as? CGFloat {
            self.alpha = alpha
        }
    }
}
