//
//  SpriterTimeline.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterTimeline: SpriterParseable {
    
    var id: Int
    var name: String
    var objectType: SpriterObjectType?
    var keys: [SpriterTimelineKey] = []
    
    
    init?(data: AnyObject) {
        guard let id = data.value(forKey: "id") as? Int,
            let name = data.value(forKey: "name") as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        
        if let type = data.value(forKey: "type") as? String,
            let objectType = SpriterObjectType(rawValue: type) {
            self.objectType = objectType
        }
    }
    
}
