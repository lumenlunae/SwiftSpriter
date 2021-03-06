//
//  SpriterConstants.swift
//  SwiftSpriter
//
//  Created by Matt on 8/27/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//

import Foundation
import UIKit

let SpriterRefNoParentValue: Int = -1
let SpriterObjectNoPivotValue: CGFloat = CGFloat.leastNormalMagnitude

enum SpriterObjectType: String {
    case sprite
    case bone
    case box
    case point
    case sound
    case entity
    case variable
}

enum SpriterSpinType: Int {
    case none = 0
    case counterClockwise = -1
    case clockwise = 1
}

enum SpriterCurveType: Int {
    case instant = 0
    case linear
    case quadratic
    case cubic
    
    init?(string: String) {
        switch string.lowercased() {
        case "instant": self = .instant
        case "linear":  self = .linear
        case "quadratic": self = .quadratic
        case "cubic": self = .cubic
        default: return nil
        }
    }
}

enum SpriterSpatialType: Int {
    case sprite = 0
    case node
    case collisionBox
    case point
    case sound
}

protocol SpriterParseable {
    init?(data: AnyObject)
}
