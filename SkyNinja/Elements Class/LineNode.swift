//
//  MiddleNodeClass.swift
//  SkyNinja
//
//  Created by Chen on 2018/6/11.
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit

class LineNode :SKNode {
    
    func initLine(size:CGSize,yPos:CGFloat){ // 传入scene的尺寸
        /// let yPos : CGFloat = size.height * 0.65
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint   = CGPoint(x: size.width * SCENE_NUMBERS, y: yPos)
        self.name = "Line"
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask   = PhysicsCategory.MiddleLine
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        physicsBody?.collisionBitMask  = PhysicsCategory.None    /// 不会弹开
    }
    
    func initSkyLine(size:CGSize,yPos:CGFloat){ // 传入scene的尺寸
        /// let yPos : CGFloat = size.height * 0.65
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint   = CGPoint(x: size.width * SCENE_NUMBERS, y: yPos)
        self.name = "Line"
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask   = PhysicsCategory.SkyLine
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        physicsBody?.collisionBitMask  = PhysicsCategory.None    /// 不会弹开
    }
    
    func initGroundLine(size:CGSize,yPos:CGFloat){ // 传入scene的尺寸
        /// let yPos : CGFloat = size.height * 0.65
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint   = CGPoint(x: size.width * SCENE_NUMBERS, y: yPos)
        self.name = "Line"
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask   = PhysicsCategory.GroudLine
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
        physicsBody?.collisionBitMask  = PhysicsCategory.None    /// 不会弹开
    }

}
