//
//  MenuScene.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 08/07/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class MenuScene: ParentScene {
    override func didMove(to view: SKView) {
        // 4tobu powtorno ne zagryžalis atlasu pri wuzowe MenuScene powtorno
         if !Assets.shared.isLoaded {
             Assets.shared.preloadAssets()
             Assets.shared.isLoaded = true
         }
         
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        
//        let header = SKSpriteNode(imageNamed: "header1")
//               header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
//               self.addChild(header)
        setHeader(withName: nil, andBackground: "header1")
        let titles = ["play", "options", "best"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            button.name = title
            button.label.name = title
            addChild(button)
        } 
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       let location = touches.first!.location(in: self)
            let node = self.atPoint(location)
            // perechod na nowyjy sceny
            if node.name == "play" {
                let transition = SKTransition.crossFade(withDuration: 1.0)
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            
            } else if node.name == "options" {
                        
                        let transition = SKTransition.crossFade(withDuration: 1.0)
                        let optionsScene = OptionsScene(size: self.size)
                        optionsScene.backScene = self
                        optionsScene.scaleMode = .aspectFill
                        self.scene!.view?.presentScene(optionsScene, transition: transition)
                        
                    } else if node.name == "best" {
                        
                        let transition = SKTransition.crossFade(withDuration: 1.0)
                        let bestScene = BestScene(size: self.size)
                        bestScene.backScene = self
                        bestScene.scaleMode = .aspectFill
                        self.scene!.view?.presentScene(bestScene, transition: transition)
                    }
                }
        }


