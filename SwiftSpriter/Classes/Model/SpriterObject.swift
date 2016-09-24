//
//  SpriterObject.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import UIKit

struct SpriterObject: SpriterParseable {
    
    var folderID: Int
    var fileID: Int
    var positionX: CGFloat = 0
    var positionY: CGFloat = 0
    var angle: CGFloat = 0
    var scaleX: CGFloat = 1
    var scaleY: CGFloat = 1
    var pivotX: CGFloat = SpriterObjectNoPivotValue
    var pivotY: CGFloat = SpriterObjectNoPivotValue
    var alpha: CGFloat = 1
    
    init?(data: AnyObject) {
        guard let folderID = data.value(forKey: "folder") as? Int,
            let fileID = data.value(forKey: "file") as? Int else {
                return nil
        }
        
        self.folderID = folderID
        self.fileID = fileID
        
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
        
        if let pivotX = data.value(forKey: "pivot_x") as? CGFloat {
            self.pivotX = pivotX
        }
        
        if let pivotY = data.value(forKey: "pivot_y") as? CGFloat {
            self.pivotY = pivotY
        }
        
        if let alpha = data.value(forKey: "a") as? CGFloat {
            self.alpha = alpha
        }
    }
}
