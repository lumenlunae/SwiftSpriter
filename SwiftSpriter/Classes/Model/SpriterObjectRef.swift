//
//  SpriterObjectRef.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation

struct SpriterObjectRef: SpriterParseable {
    
    var id: Int
    var parentID: Int = SpriterRefNoParentValue
    var timelineID: Int
    var keyID: Int
    var zIndex: Int?
    
    // 
    var folderID: String?
    var fileID: String?
    var absX: CGFloat?
    var absY: CGFloat?
    var absPivotX: CGFloat?
    var absPivotY: CGFloat?
    var absScaleX: CGFloat?
    var absScaleY: CGFloat?
    
    // TODO: edititme features
    init?(data: AnyObject) {
        guard let id = data.value(forKey: "id") as? Int,
            let timelineString = data.value(forKey: "timeline") as? String,
            let timelineID = Int(timelineString),
            let keyID = data.value(forKey: "key") as? Int else {
                return nil
        }
        
        self.id = id
        self.timelineID = timelineID
        self.keyID = keyID
        
        if let zIndexString = data.value(forKey: "z_index") as? String,
            let zIndex = Int(zIndexString) {
            self.zIndex = zIndex
        }
        
        if let parentID = data.value(forKey: "parent") as? Int {
            self.parentID = parentID
        }
    }
}
