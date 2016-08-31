//
//  SpriterBoneRef.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterBoneRef: SpriterParseable {
    
    var id: Int
    var parentID: Int = SpriterRefNoParentValue
    var timelineID: Int
    var timeline: SpriterTimeline?
    var keyID: Int
    var timelineKey: SpriterTimelineKey?
    
    init?(data: AnyObject) {
        guard let id = data.value(forKey: "id") as? Int,
            let timelineID = data.value(forKey: "timeline") as? Int,
            let keyID = data.value(forKey: "key") as? Int else {
                return nil
        }
        
        self.id = id
        self.timelineID = timelineID
        self.keyID = keyID
        
        if let parentID = data.value(forKey: "parent") as? Int {
            self.parentID = parentID
        }
        
    }
}
