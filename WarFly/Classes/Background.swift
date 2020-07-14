//
//  Background.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 14/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
static func populateBackground(at point: CGPoint) -> Background {
    // sozdaem background
    let background = Background(imageNamed: "background")
    background.position = point
    background.zPosition = 0
    
    return background

}
}
