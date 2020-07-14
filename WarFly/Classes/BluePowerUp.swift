//
//  BluePowerUp.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 07/07/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class BluePowerUp: PowerUp {
    init() {
           let textureAtlas = Assets.shared.bluePowerUpAtlas
           super.init(textureAtlas: textureAtlas)
        name = "bluePowerUp"
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
