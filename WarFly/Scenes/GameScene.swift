//
//  GameScene.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 14/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: ParentScene {
    
    var backgroundMusic: SKAudioNode!
    var player: PlayerPlane!
    fileprivate let hud = HUD()
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate var lives = 3 {
        didSet {
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }
    // ---wariant kak postawit na paysy otdelnuj nod
    //fileprivate var pauseNode = SKNode()
    
    //    let scoreBackground = SKSpriteNode(imageNamed: "scores")
    //       let scoreLabel = SKLabelNode(text: "10000")
    //       let menuButton = SKSpriteNode(imageNamed: "menu")
    //       let life1 = SKSpriteNode(imageNamed: "life")
    //       let life2 = SKSpriteNode(imageNamed: "life")
    //       let life3 = SKSpriteNode(imageNamed: "life")
    
    override func didMove(to view: SKView) {
        //---wariant kak postawit na paysy otdelnuj nod
        //addChild(pauseNode)
        // snimaem s payzu
        gameSettings.loadGameSettings()
        
     if gameSettings.isMusic && backgroundMusic == nil {
            if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        } 
        
        self.scene?.isPaused = false
        
        // checking if scene persists
        guard sceneManager.gameScene == nil else { return }
        
        sceneManager.gameScene = self
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configreStartScene()
        spawnClouds()
        spawnIslands()
        // mu yže podgryžaem atlasu w MenuScene
        //        let deadline = DispatchTime.now() + .nanoseconds(1)
        //        DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
        //            self.player.performFly()
        //        }
        //
        spawnPowerUp()
        spawnEnemies()
        createHUD()
        //configureUI()
    }
    
    fileprivate func createHUD() {
        addChild(hud)
        hud.configureUI(screenSize: screenSize)
    }
    
    // nastraiwaem polzowatelskuj interfejs
    //    fileprivate func configureUI() {
    //        scoreBackground.position = CGPoint(x: scoreBackground.size.width + 10, y: self.size.height - scoreBackground.size.height / 2 - 10)
    //        scoreBackground.anchorPoint = CGPoint(x: 1.0, y: 0.5)
    //        scoreBackground.zPosition = 99
    //        addChild(scoreBackground)
    //
    //        scoreLabel.horizontalAlignmentMode = .right
    //        scoreLabel.verticalAlignmentMode = .center
    //        scoreLabel.position = CGPoint(x: -10, y: 3)
    //        scoreLabel.zPosition = 100
    //        scoreLabel.fontName = "AmericanTypewriter-Bold"
    //        scoreLabel.fontSize = 30
    //        scoreBackground.addChild(scoreLabel)
    //
    //        menuButton.position = CGPoint(x: 20, y: 20)
    //        menuButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    //        menuButton.zPosition = 100
    //        addChild(menuButton)
    //
    //        let lifes = [life1, life2, life3]
    //        for (index, life) in lifes.enumerated() {
    //            life.position = CGPoint(x: self.size.width - CGFloat(index + 1) * (life.size.width + 3), y: 20)
    //            life.zPosition = 100
    //            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    //            addChild(life)
    //        }
    //    }
    
    fileprivate func spawnPowerUp() {
        
        let spawnAction = SKAction.run {
            let randomNumber = Int(arc4random_uniform(2)) // ot 0 do 2, 2 newchodit w diapazon
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            let randomPositionX = arc4random_uniform(UInt32(self.size.width - 30))
            // randomnaja pozicuja zaroždenija
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            powerUp.startMovement()
            //---wariant kak postawit na paysy otdelnuj nod
           // pauseNode.isPaused = true
            //self.pauseNode.addChild(powerUp)
            self.addChild(powerUp)
        }
        
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        
        self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
    }
    
    fileprivate func spawnEnemies() {
        let waitAction = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnSpiralOfEnemies()
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnSpiralAction])))
    }
    
    fileprivate func spawnSpiralOfEnemies() {
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas//SKTextureAtlas(named: "Enemy_1")
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas//SKTextureAtlas(named: "Enemy_2")
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNumber]
            
            let waitAction = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run({ [unowned self] in
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[12])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 50)
                self.addChild(enemy)
                enemy.flySpiral()
            })
            
            let spawnAction = SKAction.sequence([waitAction, spawnEnemy])
            let repeatAction = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatAction)
        }
    }
    
    fileprivate func spawnClouds() {
        // interwal kogda ni4ego ne proischodit
        let spawnCloudWait = SKAction.wait(forDuration: 1)
        // generacija nowogo obekta
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        // delaem beskone4nyjy generacijy oblakow
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        run(spawnCloudForever)
    }
    
    fileprivate func spawnIslands() {
        let spawnIslandWait = SKAction.wait(forDuration: 3)
        let spawnIslandAction = SKAction.run {
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        run(spawnIslandForever)
    }
    
    fileprivate func configreStartScene() {
        // ykazuwaem center ekrana
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        //ispolzyem metod iz klasa background
        let background = Background.populateBackground(at: screenCenterPoint)
        background.size = size
        self.addChild(background)
        // razmer ekrana
        let screen = UIScreen.main.bounds
        // ranniaja wersija randomnoj generacii pozicui
        //for _ in 1...5 {
        
        //            let x: CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
        //            let y: CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.height)))
        
        let island1 = Island.populate(at: CGPoint(x: 100, y: 200))
        self.addChild(island1)
        
        let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.height - 200))
        self.addChild(island2)
        
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 100))
        self.addChild(player)
        
        
    }
    override func didSimulatePhysics() {
        player.checkPosition()
        
        // pereberaem nodu s rasli4num imenem
        enumerateChildNodes(withName: "sprite") { (node, stop) in
            if node.position.y <= -50 {
                node.removeFromParent()
                // proweriaem ydalilsia li nod so scenu
                if node.isKind(of: PowerUp.self) {
                    print("PowerUp is removed from scene")
                }
            }
        }
        enumerateChildNodes(withName: "bluePowerUp") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "greenPowerUp") { (node, stop) in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "shotSprite") { (node, stop) in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
    
    fileprivate func playerFire() {
        let shot = YellowShot()
        shot.position = self.player.position
        shot.startMovement()
        self.addChild(shot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause" {
            let transition = SKTransition.doorway(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            // sochraniaem sostojanie scenu
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            playerFire()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
     let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
           let contactPoint = contact.contactPoint
           explosion?.position = contactPoint
           explosion?.zPosition = 25
           let waitForExplosionAction = SKAction.wait(forDuration: 2.0)
           
           let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
           switch contactCategory {
           case [.enemy, .player]: print("enemy vs player")
           
           if contact.bodyA.node?.name == "sprite" {
               if contact.bodyA.node?.parent != nil {
                   contact.bodyA.node?.removeFromParent()
                   lives -= 1
               }
           } else {
               if contact.bodyB.node?.parent != nil {
                   contact.bodyB.node?.removeFromParent()
                   lives -= 1
               }
           }
           addChild(explosion!)
           self.run(waitForExplosionAction){ explosion?.removeFromParent() }
           
           if lives == 0 {
            gameSettings.currentScore = hud.score
            gameSettings.saveScores()
            
               let gameOverScene = GameOverScene(size: self.size)
               gameOverScene.scaleMode = .aspectFill
               let transition = SKTransition.doorsCloseVertical(withDuration: 1.0)
               self.scene!.view?.presentScene(gameOverScene, transition: transition)
               }
               
           case [.powerUp, .player]: print("powerUp vs player")
           
           if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
               
               if contact.bodyA.node?.name == "bluePowerUp" {
                   contact.bodyA.node?.removeFromParent()
                   lives = 3
                   player.bluePowerUp()
               } else if contact.bodyB.node?.name == "bluePowerUp" {
                   contact.bodyB.node?.removeFromParent()
                   lives = 3
                   player.bluePowerUp()
               }
               
               if contact.bodyA.node?.name == "greenPowerUp" {
                   contact.bodyA.node?.removeFromParent()
                   player.greenPowerUp()
               } else {
                   contact.bodyB.node?.removeFromParent()
                   player.greenPowerUp()
               }
           }
               
           case [.enemy, .shot]: print("enemy vs shot")
           
         if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
               contact.bodyA.node?.removeFromParent()
               contact.bodyB.node?.removeFromParent()
               self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
               hud.score += 5
               addChild(explosion!)
               self.run(waitForExplosionAction){ explosion?.removeFromParent() }
           }
               
           default: preconditionFailure("Unable to detect collision category")

       }
    

        //        let bodyA = contact.bodyA.categoryBitMask
        //        let bodyB = contact.bodyB.categoryBitMask
        //        let player = BitMaskCategory.player
        //        let enemy = BitMaskCategory.enemy
        //        let shot = BitMaskCategory.shot
        //        let powerUp = BitMaskCategory.powerUp
        //
        //        if bodyA == player && bodyB == enemy || bodyB == player && bodyA == enemy {
        //            print("enemy vs player")
        //        } else if bodyA == player && bodyB == powerUp || bodyB == player && bodyA == powerUp {
        //            print("powerUp vs player")
        //        } else if bodyA == shot && bodyB == enemy || bodyB == shot && bodyA == enemy {
        //            print("enemy vs shot")
        //        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
