//
//  Cloud.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 14/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit
import GameplayKit

final class Cloud: SKSpriteNode, GameBackgroundSpriteable {
    static func populate(at point: CGPoint?) -> Cloud {
        let cloudImageName = configureName()
        let cloud = Cloud(imageNamed: cloudImageName)
        cloud.setScale(randomScaleFactor)
        cloud.position = point ?? randomPoint()
        cloud.zPosition = CGFloat(Int.random(in: 10 ... 22))
        cloud.name = "sprite"
        // 4tobu nod ydalialsia kogda on dochodit do swoej werchnej granicu
        cloud.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        cloud.run(move(from: cloud.position))
        return cloud
    }
    
    fileprivate static func configureName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomNumber = distribution.nextInt()
        let imageName = "cl" + "\(randomNumber)"
        
        return imageName
    }
    
    fileprivate static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 20, highestValue: 30)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    fileprivate static func move(from point: CGPoint) -> SKAction {
           let movePoint = CGPoint(x: point.x, y: -200)
           let moveDistance = point.y + 200
           let movementSpeed: CGFloat = 150.0
           let duration = moveDistance / movementSpeed
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
       }
}
