//
//  GameScene.swift
//  SkyNinja
/*
 *  *** 游戏元素使用条款及注意事项 ***
 *
 *  游戏中的所有元素全部由iFIERO所原创(除注明引用之外)，包括人物、音乐、场景等;
 *  创作的初衷就是让更多的游戏爱好者可以在开发游戏中获得自豪感 -- 让手机游戏开发变得简单;
 *  秉着开源分享的原则,iFIERO发布的游戏都尽可能的易懂实用，并开放所有源码;
 *  任何使用者都可以使用游戏中的代码块，也可以进行拷贝、修改、更新、升级，无须再经过iFIERO的同意;
 *  但这并不表示可以任意复制、拆分其中的游戏元素:
 *  用于[商业目的]而不注明出处;
 *  用于[任何教学]而不注明出处;
 *  用于[游戏上架]而不注明出处；
 *  另外,iFIERO有商用授权游戏元素，获得iFIERO官方授权后，即无任何限制;
 *  请尊重帮助过你的iFIERO的知识产权，非常感谢;
 *
 *  Created by VANGO杨 && ANDREW陈
 *  Copyright © 2018 iFiero. All rights reserved.
 *  www.iFIERO.com
 *  iFIERO -- 让手机游戏开发变得简单
 *
 *  SkyNinja 天猪之城 在此游戏中您将获得如下技能:
 *
 *  1、LaunchScreen       学习如何设置游戏启动画面
 *  2、Scene              学习如何切换游戏的游戏场景
 *  3、Scene Edit         学习直接使用可见即所得操作编辑游戏场景
 *  4、Random             利用可复用的随机函数生成Enemy
 *  5、SpriteNode class   学习建立独立的class精灵并引入场景scene
 *  6、Collision          学习有节点与节点之间的碰撞的原理及处理方法
 *  7、Animation&Atlas    学习如何导入动画帧及何为Atlas
 *  8、Camera             使用Camera实现endless背景滚动
 *  9、Grarity            学习如何点击屏幕时反转重力
 *  10、StateMachine      GameplayKit 运用之场景切换;(**** 中级技能)
 *  11、Partilces         学习如何做特效及把特效发生碰撞时移出场景;(**** 中级技能)
 *
 */

import SpriteKit
import GameplayKit

class GameScene: SKScene ,SKPhysicsContactDelegate{
    
    var moveAllowed = false /// 场景是否可以移动了;
    
    //MARK: - StateMachine 场景中各个舞台State
    lazy var stateMachine:GKStateMachine = GKStateMachine(states: [
        WaitingState(scene: self), //self 为 GameScene ,把GameScene专入State
        PlayState(scene: self),
        GameOverState(scene: self)
        ])
    
    //MARK: - 场景中的所有SpriteNode
    /*
     * 1.调用 Elements Class 的节点,须在GameScene的把节点的Custom Class设为PlayerNode
     * 2.Module 设为项目名称 SkyNinja
     * 3.为何要设置独立的class精灵,可以为GameScene减少代码,并有利于代码的复用;
     */
    var playerNode:PlayerNodeClass!
    var learnTemp:SKSpriteNode!
    var coinTempNode:SKSpriteNode!
    var bombTempNode:SKSpriteNode!
    var mainCamera:SKCameraNode!
    var groundNode:SKSpriteNode!    /// 地面
    var skyNode:SKSpriteNode!       /// 天空
    var spawnElements = SpawnElements() /// 生成节点工具 特别注意，这里非 spawnElements = SpawnElements!
    
    private var dt:TimeInterval = 0  /// 每一frame的时间差
    private var lastUpdateTimeInterval:TimeInterval = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)  /// 物理世界的重力
        self.physicsWorld.contactDelegate = self               /// 碰撞代理
        
        initCamera()   /// Camera
        initBgMusic()  /// 背景音乐
        initPlayer()   /// 初始化玩家
        initCoinBomb() /// 临时的Coin+Bomb
        initSkyGroundLine() // 建立物理天空+地面
        stateMachine.enter(WaitingState.self) /// 初始化以上的各个精灵SpriteNode后，再进入WaitingState 场景舞台State
    }
    //MARK: - 加入Camera
    func initCamera(){
        mainCamera = childNode(withName: "MainCamera") as! SKCameraNode
    }
    //MARK: - 移动Camera
    func moveCamera(){
        self.mainCamera.position.x += CAMERA_MOVE_XPOS ///向右移动
    }
    //MARK: - 停止Camera
    func stopCamera(){
        self.mainCamera.removeAllActions()
    }
    // MARK:-初始化玩家
    func initPlayer(){
        
        playerNode = childNode(withName: "Player") as! PlayerNodeClass
        playerNode.physicsBody?.affectedByGravity = true
        playerNode.initPlayer()
    }
    // MARK:-背景音乐
    func initBgMusic(){
        
        let bgMusic = SKAudioNode(fileNamed: "background.mp3")
        bgMusic.autoplayLooped = true
        addChild(bgMusic)
    }
    
    func initCoinBomb(){
        coinTempNode = childNode(withName: "CoinTemp") as! SKSpriteNode
        bombTempNode = childNode(withName: "BombTemp") as! SKSpriteNode
        learnTemp   = childNode(withName: "learnTemp") as! SKSpriteNode
    }
    //MARK: - 物理线
    func initSkyGroundLine(){
        
        skyNode = childNode(withName: "Sky") as! SKSpriteNode
        let sykLine = LineNode()  /// 生成新的节点 比如 let newNode = SKNode()
        sykLine.initSkyLine(size: size, yPos: skyNode.position.y + 10)
        addChild(sykLine)
        
        
        groundNode = childNode(withName: "Ground") as! SKSpriteNode
        let groundLine = LineNode()
        groundLine.initGroundLine(size: size, yPos: groundNode.position.y + groundNode.size.height - 10)
        addChild(groundLine)
        
    }
    
    // MARK: - 反转物理世界;
    func reverseGravity(){
        physicsWorld.gravity *= -1
    }
    
    // MARK: - 根据 camera.position.x 移动所有页面元素;
    ///因为节点anchorPoint为(0,0)，且相机的初始位置为 1024,所以要把相机的位置扣除1024 即(camera.position.x - self.size.width / 2)
    func moveSprites(camera:SKCameraNode){
        /// 所有的天空精灵
        enumerateChildNodes(withName: "Sky") { (node, error) in
            if  node.position.x + self.size.width < (camera.position.x - self.size.width / 2) {
                node.position.x += self.size.width * SCENE_NUMBERS
            }
        }
        /// 所有的地面精灵;
        enumerateChildNodes(withName: "Ground") { (node, error) in
            if  node.position.x + self.size.width < (camera.position.x - self.size.width / 2 ) {
                node.position.x += self.size.width * SCENE_NUMBERS
            }
            /// print("所有的地面精灵",node.position.x,(camera.position.x - self.size.width / 2 ))
        }
        /// 所有线和Camera同步
        enumerateChildNodes(withName: "Line") { (node, error) in
            // let node = node as! SKNode
            node.position.x += CAMERA_MOVE_XPOS
            if  node.position.x < -self.size.width {
                node.position.x += self.size.width * SCENE_NUMBERS
            }
        }
        /// 所有树
        /// 树为何不：(camera.position.x - self.size.width / 2 ),请注意树的 anchorPoint(0.5,0.5)
        enumerateChildNodes(withName: "Tree") { (node, error) in
            if  node.position.x + self.size.width < (camera.position.x ) {
                node.position.x += self.size.width * SCENE_NUMBERS
            }
        }
        /// 所有背景
        enumerateChildNodes(withName: "Bg") { (node, error) in
            
            if  node.position.x + self.size.width < (camera.position.x - self.size.width / 2 ) {
                node.position.x += self.size.width * SCENE_NUMBERS
            }
        }
    }
    // MARK: - 生成节点工具 class
    @objc func spawnCoins(){
        /// print(spawnElements.spawnCoin(camera: mainCamera))
        if moveAllowed {
            self.addChild(spawnElements.spawnCoin(camera: mainCamera)) /// 传入主相机位置
        }
        
    }
    
    @objc func spawnBombs(){
        if moveAllowed {
            addChild(spawnElements.spawnBomb(camera: mainCamera,scene: self)) /// 传入主相机位置
        }
    }
    
    @objc func removeCoins(){
        enumerateChildNodes(withName: "coin") { (node, error) in
            if node.position.x < self.mainCamera.position.x - self.size.width {
                /// print("移除coin")
                node.removeFromParent()
            }
        }
    }
    // MARK: - 不再生成了;
    func stopSpawning(){
        
        playerNode.removeAction(forKey: "jogging")  /// 移除人物的运动;
        
        enumerateChildNodes(withName: "coin") { (node, error) in
            node.removeAllActions()
        }
        enumerateChildNodes(withName: "bomb") { (node, error) in
            node.removeAllActions()
        }
    }
    
    //MARK: - 重新开始游戏;
    func restartGame(){
        
        let newScene = GameScene(fileNamed: "GameScene")!
        newScene.size = CGSize(width: SCENE_WIDTH, height: SCENE_HEIGHT)
        newScene.anchorPoint = CGPoint(x: 0, y: 0)
        newScene.scaleMode   = .aspectFill
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(newScene, transition:transition)
    }
    
    // MARK: - 监测屏幕点击事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self) ///获得点击的位置
        /// 判断目前的GameScene场景舞台是哪个state
        switch stateMachine.currentState {
        case is WaitingState:
            /// 获得按钮的点击位置
            guard let body = physicsWorld.body(at: touchLocation) else {
                return
            }
            /// 判断是否是点击了PlayButton
            guard  let playButton = body.node?.childNode(withName: "PlayButton") as? SKSpriteNode else {
                return
            }
            /// 如果点击位置是在PlayButton
            if (playButton.contains(touchLocation)){
                playButton.isHidden = true
                stateMachine.enter(PlayState.self) /// 进入开始游戏;
            }
            
            guard let learnTempNode = body.node?.childNode(withName: "learnTemp") as? SKSpriteNode else {
                return
            }
            if (learnTempNode.contains(touchLocation)){
                UIApplication.shared.open(URL(string: "http://www.iFIERO.com")!, options: [:], completionHandler: { (error) in
                    print("jump to http://www.iFiero.com")
                })
            }
            
        case is PlayState:
            reverseGravity() /// 反转物理世界;
            
        case is GameOverState:
            
            guard let body = physicsWorld.body(at: touchLocation) else {
                return
            }
            // TapToPlay按钮;
            if let tapToPlay  = body.node?.childNode(withName: "tapToPlay"){
                
                if tapToPlay.contains(touchLocation){
                    print("重新开始游戏！")
                    restartGame()
                }
            }
        default:
            break;
        }
    }
    // MARK: - 监测碰撞
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA:SKPhysicsBody
        let bodyB:SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        }else{
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        ///检测碰到中间线
        /*
         if bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.MiddleLine {
         /// print("碰到屏幕线人物反转")
         playerNode.reversePlayer()
         }
         */
        
        ///检测碰到coin
        if bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.Coin {
            /// print("碰到屏幕线人物反转")
            let coinAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(coinAction)
            bodyB.categoryBitMask = PhysicsCategory.None /// 去除双响;
            
             /// 加入收集coin特效;
            let coinNode = SKNode()
            coinNode.position = (bodyB.node?.position)!
            self.addChild(coinNode)
            
            let coinEmitter = SKEmitterNode(fileNamed: "CollectNormal")
            coinNode.addChild(coinEmitter!)
            
            bodyB.node?.removeFromParent()
            
            coinEmitter?.run(SKAction.sequence([
                SKAction.wait(forDuration: TimeInterval(0.7)),
                SKAction.removeFromParent(),
                
                ]))
        }
        
        /// 检测碰到Bomb
        if bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.Bomb {
            /// 播放音乐
            /// let bombAction = SKAction.playSoundFileNamed("ninjaHit.wav", waitForCompletion: false)
            /// 无法播放音乐 在Build Phases -> Copy Bundle Resources 导入即可;
            let bombAction = SKAction.playSoundFileNamed("death.caf", waitForCompletion: false)
            run(bombAction)
            bodyA.categoryBitMask = PhysicsCategory.None  /// 防止一直和Bomb碰撞 产生多重声音;
            /// 加入death 特效;
            let deathNode = SKNode()
            deathNode.position = (bodyA.node?.position)!
            self.addChild(deathNode)
            
            let deathEmitter = SKEmitterNode(fileNamed: "death")
            deathEmitter?.targetNode = deathNode
            deathNode.addChild(deathEmitter!)
            bodyA.node?.removeFromParent()
            deathEmitter?.run(SKAction.sequence([
                SKAction.wait(forDuration: TimeInterval(2.0)),
                SKAction.removeFromParent(),
                ]))
            bodyB.node?.removeFromParent() /// 移除Bomb
            
            stateMachine.enter(GameOverState.self)
        }
    }
    // MARK: - 时时更新update
    override func update(_ currentTime: TimeInterval) {
        
        /// 获取时间差
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        stateMachine.update(deltaTime: dt)  /// 把update传进各个State里;
    }
}
















