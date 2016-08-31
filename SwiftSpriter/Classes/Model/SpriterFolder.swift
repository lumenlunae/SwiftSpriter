//
//  SpriterFolder.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterFolder: SpriterParseable {
    
    var id: Int = -1
    var name: String = ""
    var files: [SpriterFile] = []
    
    init?(data: AnyObject) {
        if let name = data.value(forKey: "name") as? String {
            self.name = name
        }
        
        if let id = data.value(forKey: "id") as? Int {
            self.id = id
        }
        
    }
}
