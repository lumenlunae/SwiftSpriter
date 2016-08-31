//
//  GreyGuy.swift
//  SwiftSpriterExample
//
//  Created by Matt on 8/28/16.
//  Copyright © 2016 BiminiRoad. All rights reserved.
//


import UIKit
import SpriteKit
import SwiftSpriter

class GreyGuy: AnimationScene {
    override func commonInit() {
        self.fileName = "greyguy"
        self.entityName = "Player"
        super.commonInit()
    }
}
