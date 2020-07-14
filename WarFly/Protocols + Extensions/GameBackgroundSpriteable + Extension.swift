//
//  GameBackgroundSpriteable + Extension.swift
//  WarFly
//
//  Created by Yurii Sameliuk on 23/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//
import SpriteKit
import GameplayKit

protocol GameBackgroundSpriteable {
    //Self - wozwras4aet libo tip protocola libo tip clasa wnytri kotorogo wu ero ispolzyete
    static func populate(at point: CGPoint?) -> Self
    static func randomPoint() -> CGPoint
}
// dlia togo 4tobu pojawilsia odin obs4ij metod w Island i Cloud klasach
extension GameBackgroundSpriteable {
    static func randomPoint() -> CGPoint {
        // poly4aem granicu ekrana
        let screen = UIScreen.main.bounds
        // ysnanawliwaem diapazon ot nižnej granicudo werchnej, poza ekranom swerchy oblaka i ostrowa
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 400, highestValue: Int(screen.size.height) + 500)
        // poly4aem sly4ajno sgeneriryemoe 4islo
        let y = CGFloat(distribution.nextInt())// nextInt() - ispolz dlia generacii kakogoto zna4enija
        //ysnanawliwaem diapazon ot 0 do ykazanogo zna4enija, poza ekranom swerchy oblaka i ostrowa
        let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
        return CGPoint(x: x, y: y)
    }
}
