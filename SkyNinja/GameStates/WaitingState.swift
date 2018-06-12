//
//  WaitingState.swift
//  SkyNinja
//
//  Created by Chen on 2018/6/10.
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingState:GKState {
    
    unowned let scene:GameScene
    var playButton:SKSpriteNode!
    
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
    }
    //MARK: - 初始化PlayButton,但获得点击事件touchesBegan是在GameScene中进行判断;
    func initPlayButton() {
        /// 取得playButton节点
        playButton = scene.childNode(withName: "PlayButton") as! SKSpriteNode
        /// 播放按钮的动画;
        let zoomOut = SKAction.scale(by: 0.8, duration: 0.75)
        zoomOut.timingMode = .easeInEaseOut
        let zoomIn  = zoomOut.reversed()
        zoomIn.timingMode  = .easeInEaseOut
        /// 播放顺序
        let sequence = SKAction.sequence([zoomOut,zoomIn])
        let repeatAction = SKAction.repeatForever(sequence)
        /// 执行Action
        playButton.run(repeatAction)
        
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.moveAllowed = false /// 初始进入WaitState人物+场景是不可以运动的;
        scene.coinTempNode.isHidden = false 
        scene.bombTempNode.isHidden = false
        initPlayButton()
    }
    // 正确无误 进入一下个State PlayState
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayState.Type
    }
    
    
}
