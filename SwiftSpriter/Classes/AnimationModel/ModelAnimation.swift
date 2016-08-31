//
//  ModelAnimation.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

class ModelAnimation {
    
    var name: String
    var length: TimeInterval
    var isLooping = false
    
    var timelinesByID = [Int: ModelTimeline]()
    var mainline: ModelMainline?
    
    init(spriterAnimation: SpriterAnimation) {
        self.name = spriterAnimation.name
        
        // convert from ms to s
        self.length = spriterAnimation.length / 1000.0
        self.isLooping = spriterAnimation.isLooping
    }
}
