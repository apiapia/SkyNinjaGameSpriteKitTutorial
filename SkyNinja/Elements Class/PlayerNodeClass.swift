//
//  PlayerNode.swift
//  SkyNinja
//
//  Created by Chen on 2018/6/11.
//  Copyright © 2018 iFiero. All rights reserved.
//


import SpriteKit

class PlayerNodeClass:SKSpriteNode {
    
    private var playerTextureAtlas = SKTextureAtlas()
    private var playerTextures     = [SKTexture]()
    
     // MARK:-玩家
    func initPlayer(){
        /// Ninja.atlas名称 (位于目录Resources->Images)
        playerTextureAtlas = SKTextureAtlas(named: "Ninja")
        /// 把atlas里的图片append到PlayerTextures数组内
        for i in 1...playerTextureAtlas.textureNames.count {
            let imageName = "t1000\(i)"
            playerTextures.append(SKTexture(imageNamed: imageName))
        }
        /// 节点的物理特性 /// SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width / 2, height: self.size.height))
        self.physicsBody?.restitution = 0  // bounciness物体落下时反弹跳力不会消减
        self.physicsBody?.categoryBitMask    = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb | PhysicsCategory.Coin | PhysicsCategory.SkyLine | PhysicsCategory.GroudLine
        self.physicsBody?.collisionBitMask   = PhysicsCategory.GroudLine | PhysicsCategory.SkyLine
    }

    func startPlayer(){
        /// 执行textures动画
        let playerAnimation = SKAction.animate(with: playerTextures, timePerFrame: 0.1)
        /// repeatForever执行
        let repeatAction = SKAction.repeatForever(playerAnimation)
        self.run(repeatAction, withKey: "jogging")
        
    }
    // MARK: - 停止动画
    func stopPlayer(){
        self.removeAction(forKey: "jogging")
    }
    
    // MARK: - 移动玩家 - 和Camera的步调一致
    func movePlayer(){
        self.position.x += CAMERA_MOVE_XPOS
    }
    
    // MARK: - 反转Player
    func reversePlayer(){
        self.yScale *= -1
    }
    
}
