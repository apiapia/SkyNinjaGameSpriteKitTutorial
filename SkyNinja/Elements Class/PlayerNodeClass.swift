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
    private var playerUpDown = false
    
    // MARK:-玩家
    func initPlayer(){
        /// Ninja.atlas名称 (位于目录Resources->Images)
        playerTextureAtlas = SKTextureAtlas(named: "Ninja")
        /// 把atlas里的图片append到PlayerTextures数组内
        for i in 1...playerTextureAtlas.textureNames.count {
            let imageName = "t1000\(i)"
            playerTextures.append(SKTexture(imageNamed: imageName))
        }
        /// 节点的物理特性
        /// 1.调用rectangleOf矩形物理外框
        /// self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        ///2.调用物理体本身的图片 因为头重脚轻 上升到顶部时导致站不稳;
        //        self.physicsBody =  SKPhysicsBody(texture: SKTexture(imageNamed: "t10001"), size:CGSize(width: SKTexture(imageNamed: "t10001").size().width * 0.7, height: SKTexture(imageNamed: "t10001").size().height * 0.7))
        ///3.精确定制物理体t1Mask
        let playerMask = SKTexture(imageNamed: "t1Mask")
        self.physicsBody = SKPhysicsBody(texture: playerMask, size:  CGSize(width: playerMask.size().width * 0.7, height: playerMask.size().height * 0.7)) /// 0.7 的意思是缩小0.7倍
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
        // print(self.position.y,(scene?.size.height)! * 0.4)
        
        if self.position.y > (scene?.size.height)! * 0.6 {
            self.yScale = -1 * 0.7
        }
        
        if self.position.y < (scene?.size.height)! * 0.4 {
            self.yScale  = 1 * 0.7
        }
        
        
    }
    
}
