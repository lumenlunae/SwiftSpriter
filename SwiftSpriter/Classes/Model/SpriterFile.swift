//
//  SpriterFile.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterFile: SpriterParseable {
    
    var id: Int
    var name: String
    var width: CGFloat
    var height: CGFloat
    var pivotX: CGFloat = 0
    var pivotY: CGFloat = 1
    
    init?(data: AnyObject) {
        
        guard let id = data.value(forKey: "id") as? Int,
            let name = data.value(forKey: "name") as? String,
            let width = data.value(forKey: "width") as? CGFloat,
            let height = data.value(forKey: "height") as? CGFloat else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.width = width
        self.height = height
    
        if let pivotX = data.value(forKey: "pivot_x") as? CGFloat {
            self.pivotX = pivotX
        }
        
        if let pivotY = data.value(forKey: "pivot_y") as? CGFloat {
            self.pivotY = pivotY
        }
        
    }
}
