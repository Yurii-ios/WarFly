//
//  PowerUp.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 23/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import SpriteKit

class PowerUp: SKSpriteNode {
   fileprivate let initialSize = CGSize(width: 52, height: 52)
    //let textureAtlas = SKTextureAtlas(named: "GreenPowerUp")
   fileprivate let textureAtlas: SKTextureAtlas!
   fileprivate var textureNameBeingsWith = ""
   fileprivate var animationSpriteArray = [SKTexture]()
    
    init(textureAtlas: SKTextureAtlas) {
     self.textureAtlas = textureAtlas
        // poly4aem perwoe izobraženie
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        textureNameBeingsWith = String(textureName.dropLast(6))
        super.init(texture: texture, color: .clear, size: initialSize)
        self.setScale(0.7)
        self.name = "sprite"
        self.zPosition = 20
        
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
              self.physicsBody?.isDynamic = true
              self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp.rawValue
              self.physicsBody?.collisionBitMask = BitMaskCategory.player.rawValue
              self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMovement() {
           performRotation()
           // dwiženie swerchy w niz
           let moveForward = SKAction.moveTo(y: -100, duration: 5)
           self.run(moveForward)
       }
    
   fileprivate func performRotation() {
     for i in 1...15 {
        let number = String(format: "%02d", i)
        animationSpriteArray.append(SKTexture(imageNamed: textureNameBeingsWith + number.description))
        }
        
        SKTexture.preload(animationSpriteArray) {
            
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
           
        }
    }
}

