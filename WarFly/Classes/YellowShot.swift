//
//  YellowShot.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 08/07/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class YellowShot: Shot {
    
    init() {
        let textureAtlas = Assets.shared.yellowShotAtlas
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

