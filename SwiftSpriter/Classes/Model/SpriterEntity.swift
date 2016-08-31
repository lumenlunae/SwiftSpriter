//
//  SpriterEntity.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterEntity: SpriterParseable {
    
    var id: Int = 0
    var name: String
    var animations: [SpriterAnimation] = []
    
    // TOOD: CharacerMap
    
    init?(data: AnyObject) {
        guard let name = data.value(forKey: "name") as? String else {
                return nil
        }
        
        self.name = name
        
        if let id = data.value(forKey: "id") as? Int {
            self.id = id
        }
        
    }
}
