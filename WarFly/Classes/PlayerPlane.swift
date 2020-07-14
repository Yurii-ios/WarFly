//
//  PlyerPlaine.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 17/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit
import CoreMotion

class PlayerPlane: SKSpriteNode {
    // orsležuwanie poworotow
    let motionManager = CMMotionManager()
    // yskorenie poworotow
    var xAcceleration: CGFloat = 0
    let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    // masiwu s animacuej
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    // opred dwiženija
    var moveDirection: TurnDirection = .none
    var stillTurning = false
    
    let animationSpriteStrides = [(13, 1, -1), (13, 26, 1), (13, 13, 1)]
    
    // sozdaem samolet
    static func populate(at point: CGPoint) -> PlayerPlane {
        let playerPlaneTexture = Assets.shared.playerPlaneAtlas.textureNamed("airplane_3ver2_13")//SKTexture(imageNamed: "airplane_3ver2_13")
        let playerPlane = PlayerPlane(texture: playerPlaneTexture)
        // ymenshaem w 2 raza izobraženie
        playerPlane.setScale(0.5)
        playerPlane.position = point
        playerPlane.zPosition = 40
        
         playerPlane.physicsBody = SKPhysicsBody(texture: playerPlaneTexture, alphaThreshold: 0.5, size: playerPlane.size)
               playerPlane.physicsBody?.isDynamic = false
               playerPlane.physicsBody?.categoryBitMask = BitMaskCategory.player.rawValue
               playerPlane.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
               playerPlane.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
               
        
        return playerPlane
    }
    //
    func checkPosition() {
        // peremes4aem samolet
        self.position.x += xAcceleration * 50
        // ograni4iwaem peremes4enie samoleta
        if self.position.x < -70 {
            self.position.x = screenSize.width + 70
        } else if self.position.x > screenSize.width + 70 {
            self.position.x = -70
        }
    }
    
    func performFly() {
        //planeAnimationFillArray()
        preloadTextureArrays()
        //kak 4asto akselerometr zameriaet yskorenie
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [unowned self](data, error) in
            // izwlekaem poly4enue dannue
            if let data = data {
                let acceleration = data.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
                //print(self.xAcceleration)
            }
        }
        // tak kak performFly() wuzuwaetsia 1 raz, mu movementDirectionCheck metod wuzuwaem
        let planeWaitAction = SKAction.wait(forDuration: 1.0)
        let planeDirectionCheckAction = SKAction.run { [unowned self] in
           
                self.movementDirectionCheck()
        }
        let planeSequence = SKAction.sequence([planeWaitAction, planeDirectionCheckAction])
        let planeSequenceForever = SKAction.repeatForever(planeSequence)
        self.run(planeSequenceForever)
    }
    
    fileprivate func preloadTextureArrays() {
        for i in 0...2 {
            self.preloadArray(_stride: animationSpriteStrides[i], callback: { [unowned self] array in
                switch i {
                case 0: self.leftTextureArrayAnimation = array
                case 1: self.rightTextureArrayAnimation = array
                case 2: self.forwardTextureArrayAnimation = array
                default: break
                }
            })
        }
    }
    
    fileprivate func preloadArray(_stride: (Int, Int, Int), callback: @escaping (_ array: [SKTexture]) -> ()) {
        var array = [SKTexture]()
        for i in stride(from: _stride.0, through: _stride.1, by: _stride.2) {
            let number = String(format: "%02d", i)
            let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
            array.append(texture)
        }
        SKTexture.preload(array) {
            callback(array)
        }
    }
    
//    fileprivate func planeAnimationFillArray() {
//    //podgryžaem atlas, 4tobu izbežat frisa w samom na4ale igru
//        SKTextureAtlas.preloadTextureAtlases([SKTextureAtlas(named: "PlayerPlane")]) {
//
//            self.leftTextureArrayAnimation = {
//
//                var array = [SKTexture]()
//                // perebiraem ot 13 nomera do 1 s shagom -1
//                for i in stride(from: 13, through: 1, by: -1) {
//                    // poly4aem 4islo
//                    let number = String(format: "%02d", i)
//                    // sozdaem tekstyry
//                    let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
//                    array.append(texture)
//                    print(array)
//                }
//                // podgryžaem masiw, 4tobu izbežat frizow
//                SKTexture.preload(array, withCompletionHandler: {
//                    print("preload is done")
//                })
//                return array
//
//            }()
//
//            self.rightTextureArrayAnimation = {
//
//                var array = [SKTexture]()
//                for i in stride(from: 13, through: 26, by: 1) {
//                    let number = String(format: "%02d", i)
//                    let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
//                    array.append(texture)
//                    print(array)
//                }
//
//                SKTexture.preload(array, withCompletionHandler: {
//                    print("preload is done")
//                })
//                return array
//
//            }()
//
//            self.forwardTextureArrayAnimation = {
//
//                var array = [SKTexture]()
//                let texture = SKTexture(imageNamed: "airplane_3ver2_13")
//                array.append(texture)
//                print(array)
//
//                SKTexture.preload(array, withCompletionHandler: {
//                    print("preload is done")
//                })
//                return array
//
//            }()
//        }
//    }
    // opredeliaet w kakyjy storony pora zaptskat animacujy
    fileprivate func movementDirectionCheck() {
        if xAcceleration > 0.001, moveDirection != .right, stillTurning == false {
                stillTurning = true
                moveDirection = .right
                turnPlane(direction: .right)
            } else if xAcceleration < -0.001, moveDirection != .left, stillTurning == false {
                stillTurning = true
                moveDirection = .left
                turnPlane(direction: .left)
            } else if stillTurning == false {
                turnPlane(direction: .none)
            }
        
        }
        // metod wuzuwaetsia dlia každogo konkretnogo poworota
        fileprivate func turnPlane(direction: TurnDirection) {
            //sozdaem wrem masiw w kotorom bydem sochraniat tekstyru
            var array = [SKTexture]()

            if direction == .right {
                array = rightTextureArrayAnimation
            } else if direction == .left {
                array = leftTextureArrayAnimation
            } else {
                array = forwardTextureArrayAnimation
            }
            // priamaja animacuja
            let forwardAction = SKAction.animate(with: array, timePerFrame: 0.05, resize: true, restore: false)
            // obratnaja animacuja
            let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.05, resize: true, restore: false)
            let sequenceAction = SKAction.sequence([forwardAction, backwardAction])
            self.run(sequenceAction) { [unowned self] in
                self.stillTurning = false
            }
        }
    
    func greenPowerUp() {
        // miganie samoleta danum cwetom posle kontakta s PowerUp
           let colorAction = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2)
           let uncolorAction = SKAction.colorize(with: .green, colorBlendFactor: 0.0, duration: 0.2)
           let sequenceAction = SKAction.sequence([colorAction, uncolorAction])
           let repeatAction = SKAction.repeat(sequenceAction, count: 5)
           self.run(repeatAction)
       }
       
       func bluePowerUp() {
           let colorAction = SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.2)
           let uncolorAction = SKAction.colorize(with: .blue, colorBlendFactor: 0.0, duration: 0.2)
           let sequenceAction = SKAction.sequence([colorAction, uncolorAction])
           let repeatAction = SKAction.repeat(sequenceAction, count: 5)
           self.run(repeatAction)
       }
    }


    enum TurnDirection {
        case left
        case right
        case none
    }

