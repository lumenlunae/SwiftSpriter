//
//  SpriterMainlineKey.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterMainlineKey: SpriterParseable {
    
    var id: Int
    var time: TimeInterval = 0
    var objectRefs: [SpriterObjectRef] = []
    var boneRefs: [SpriterBoneRef] = []
    
    init?(data: AnyObject) {
        guard let id = data.value(forKey: "id") as? Int else {
                return nil
        }
        
        self.id = id
        
        if let time = data.value(forKey: "time") as? TimeInterval {
            self.time = time
        }
    }
}
