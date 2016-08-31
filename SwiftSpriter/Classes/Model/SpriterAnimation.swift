//
//  SpriterAnimation.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterAnimation: SpriterParseable {
    
    var id: Int
    var name: String
    var length: TimeInterval
    var isLooping: Bool = true
    var mainline: SpriterMainline?
    var timelines: [SpriterTimeline] = []
    
    init?(data: AnyObject) {
        guard let id = data.value(forKey: "id") as? Int,
            let name = data.value(forKey: "name") as? String,
            let length = data.value(forKey: "length") as? TimeInterval else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.length = length
        
        if let loopingString = data.value(forKey: "looping") as? String {
            switch loopingString {
            case "true": self.isLooping = true
            case "false": self.isLooping = false
            default:
                break
            }
        }
    }
}
