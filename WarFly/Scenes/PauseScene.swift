//
//  PauseScene.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 11/07/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class PauseScene: ParentScene {
    
   
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        
//        let header = ButtonNode(titled: "pause", backgroundName: "header_background")
//        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
//        self.addChild(header)
         setHeader(withName: "pause", andBackground: "header_background")
        
        let titles = ["restart", "options", "resume"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            button.name = title
            button.label.name = title
            addChild(button)
        }
    }
    //4tobu  pri nažatii na payzy koli4estwo nodow ne yweli4iwalos
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused {
                gameScene.isPaused = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "restart" {
            
            sceneManager.gameScene = nil// nyžno dli korectnoj rabotu posle nažatija na restart
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
            
        } else if node.name == "resume" {
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let gameScene = sceneManager.gameScene else { return }
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
}

