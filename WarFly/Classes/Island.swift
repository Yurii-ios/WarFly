//
//  Island.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 14/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit
import GameplayKit

 final class Island: SKSpriteNode, GameBackgroundSpriteable {
    // sozdaem ostrow
    // wnytri static func mu nemožem wuzuwat obu4nue func
    static func populate(at point: CGPoint?) -> Island {
        let islandImageName = configureIslandName()
        // sozdaem ostrom
        let island = Island(imageNamed: islandImageName)
        island.setScale(randomScaleFactor)
        island.position = point ?? randomPoint()
        island.zPosition = 1
        island.run(rotateForRandomAngle())
        island.name = "sprite"
        // 4tobu nod ydalialsia kogda on dochodit do swoej werchnej granicu
        island.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        island.run(move(from: island.position))
        return island
    
    }
    // wozwras4aem randomnoe nazwanie ostrowa
   fileprivate static func configureIslandName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    // randomno izmeniaem mashtab ostrowa
   fileprivate static var randomScaleFactor: CGFloat {
        // sozdaem randomnoe 4islo
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        // generiryem randomnoe 4islo
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
   fileprivate static func rotateForRandomAngle() -> SKAction {
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt())
        // toAngle - wras4enie protiw4asowoj strelki
        return SKAction.rotate(toAngle: randomNumber * CGFloat(Double.pi / 180), duration: 0)
    }
    // dwiženija ostrowow
    fileprivate static func move(from point: CGPoint) -> SKAction {
        // koordinatu dwiženija strogo po linii
        let movePoint = CGPoint(x: point.x, y: -200)
        let moveDistance = point.y + 200
        let movementSpeed: CGFloat = 100.0
        let duration = moveDistance / movementSpeed
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
}
