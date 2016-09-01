//
//  TextureAtlasScene.swift
//  SwiftSpriter
//
//  Created by Matt on 9/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SpriteKit
import SwiftSpriter

class TextureAtlasTest: AnimationScene {
    override func commonInit() {
        self.fileName = "greyguyatlas"
        self.entityName = "Player"
        super.commonInit()
    }
}
