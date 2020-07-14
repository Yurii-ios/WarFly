//
//  Enemy.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 24/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    static var textureAtlas: SKTextureAtlas?
    var enemyTexture: SKTexture!
    
   init(enemyTexture: SKTexture) {
          let texture = enemyTexture
          super.init(texture: texture, color: .clear, size: CGSize(width: 221, height: 204))
          self.xScale = 0.5
          self.yScale = -0.5
          self.zPosition = 20
          self.name = "sprite"
    
    self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
           self.physicsBody?.isDynamic = true
           self.physicsBody?.categoryBitMask = BitMaskCategory.enemy.rawValue
           self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
           self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue | BitMaskCategory.shot.rawValue
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // sozdaem dwiženie po spirali
    func flySpiral() {
        let screenSize = UIScreen.main.bounds
        let timeHorizontal: Double = 3
        let timeVertical: Double = 5
        let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)
        //4tobu wrag plawno otskakiwal ot kraew ekrana
        moveLeft.timingMode = .easeInEaseOut//easeInEaseOut - dejstwie kotoroe zamedliaetsia k koncy i yskoriaetsia ot na4ala
        let moveRight = SKAction.moveTo(x: screenSize.width - 50, duration: timeHorizontal)
        moveRight.timingMode = .easeInEaseOut
        
        let randomNumber = Int(arc4random_uniform(2))
        
        // sozdaem posledowatelnost dwiženij
         let asideMovementSequence = randomNumber == EnemyDirection.left.rawValue ? SKAction.sequence([moveLeft, moveRight]) : SKAction.sequence([moveRight, moveLeft])
        let foreverAsideMovement = SKAction.repeatForever(asideMovementSequence)
        // dwiženie nawstre4y
        let forwardMovement = SKAction.moveTo(y: -105, duration: timeVertical)
        let groupMovement = SKAction.group([foreverAsideMovement, forwardMovement])
        self.run(groupMovement)
    }
}

enum EnemyDirection: Int {
    case left = 0
    case right
}
