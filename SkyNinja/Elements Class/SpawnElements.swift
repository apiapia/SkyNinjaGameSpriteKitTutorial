//
//  SpawnElements.swift
//  SkyNinja
//
//  Created by Chen on 2018/6/12.
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import CoreGraphics

/// 生成class 不用继承任何 SKSpriteNode
class SpawnElements {
   
    private let minY = CGFloat(360)  ///  地板
    private let maxY = CGFloat(1100) ///  天空的底线
    private var randomYPos :CGFloat = 0.0
    
    // MARK:- 生成Bomb+随机移动Bomb
    func spawnBomb(camera:SKCameraNode,scene:SKScene) -> SKSpriteNode{
        
        let item :SKSpriteNode!
        item = SKSpriteNode(imageNamed: "bomb") /// Assests.xcassets存放的图片名称,非场景中的Sprite的Node名称;
        item.name = "bomb"
        item.setScale(0.6) /// 原始图片太大了
        /// 新建节点
        let trailNode = SKNode()
        trailNode.zPosition = 4  /// 此处的位置要 < Bomb的Z-Axis轴
        scene.addChild(trailNode)
        /// 新建粒子效果
        let emitterNode = SKEmitterNode(fileNamed: "Trail")!
        emitterNode.targetNode = trailNode
        item.addChild(emitterNode)
        
        /// 物理引擎 SKPhysicsBody(rectangleOf: item.size)
        let bombTexture = SKTexture(imageNamed: "bomb")
        item.physicsBody = SKPhysicsBody(texture: bombTexture, size: CGSize(width: bombTexture.size().width * 0.7 * 0.8 , height: bombTexture.size().height * 0.7 * 0.8)) /// 大小缩小 0.7 * 0.8(透明区域)
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.allowsRotation = false
        item.physicsBody?.isDynamic = false  /// 碰撞后物理体不进行动态反馈
        item.physicsBody?.categoryBitMask    = PhysicsCategory.Bomb
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        item.physicsBody?.collisionBitMask   = PhysicsCategory.None
        
        /// 随机位置
        randomYPos = CGFloat.random(minY, max: maxY) /// 扩展的CGFloat函数
        item.zPosition = 5
        item.position.x =  camera.position.x + SCENE_WIDTH * 0.7    /// 位于Camera.position的位置右侧
        item.position.y = randomYPos
        
        /// 从右往左的随机速度
        let duration = CGFloat.random(CGFloat(6.0), max: CGFloat(12.0))
        let moveToLeft = SKAction.move(to: CGPoint(x: CGFloat(-item.size.width), y: randomYPos), duration: TimeInterval(duration))
        let remove = SKAction.removeFromParent()
        item.run(SKAction.sequence([moveToLeft,remove,
                                    SKAction.run {
                                        trailNode.removeFromParent() /// 记得也把emitter节点移除;
                                    }
                                   ]))  /// 移出屏幕了;
        
        return item
    }
    
    // MARK:- 生成随机 coin
    func spawnCoin(camera:SKCameraNode) -> SKSpriteNode {
        
        let item:SKSpriteNode
        item = SKSpriteNode(imageNamed: "coin")
        item.name = "coin"
        item.setScale(0.7)
        /// 物理引擎
        item.physicsBody = SKPhysicsBody(circleOfRadius: item.size.width / 3)
        item.physicsBody?.affectedByGravity  = false
        item.physicsBody?.categoryBitMask    = PhysicsCategory.Coin
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        item.physicsBody?.collisionBitMask   = PhysicsCategory.None
        /// 随机yPos位置
        randomYPos = CGFloat.random(minY, max: maxY) /// 扩展的CGFloat函数
        /// 随机xPos位置
        let minX = SCENE_WIDTH + SCENE_WIDTH * 0.1
        let maxX = SCENE_WIDTH + SCENE_WIDTH * 1.2
        let randomX = CGFloat.random(minX, max: maxX)
        
        item.zPosition = 5
        item.position.x = camera.position.x + randomX  /// 位于Camera.position的位置右侧
        item.position.y = randomYPos
        
        /// item上下浮动
        let duration:CGFloat = CGFloat.random(1.5, max: 3.0)
        let moveUp   = SKAction.moveBy(x: 0, y: 50, duration: TimeInterval(duration))
        moveUp.timingMode = .easeInEaseOut
        let moveDown = moveUp.reversed()
        let sequence = SKAction.sequence([moveUp,moveDown])
        let repeatWobble = SKAction.repeatForever(sequence)
        item.run(repeatWobble, withKey: "Wobble")

        return item
    }
    
}
















