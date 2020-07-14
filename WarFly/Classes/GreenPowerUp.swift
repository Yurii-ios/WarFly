//
//  GreenPowerUp.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 07/07/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class GreenPowerUp: PowerUp {
    init() {
          let textureAtlas = Assets.shared.greenPowerUpAtlas
          super.init(textureAtlas: textureAtlas)
         name = "greenPowerUp"
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
