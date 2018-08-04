//
//  PlayState.swift
//  SkyNinja
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayState:GKState {
    unowned let scene:GameScene
    
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
         print("Play State")
    }
    
    /// 前一State是WaitState
    override func didEnter(from previousState: GKState?) {
        scene.moveAllowed = true /// 场景可以移动了
        scene.bombTempNode.isHidden = true
        scene.coinTempNode.isHidden = true
        scene.learnTemp.isHidden = true 
        scene.playerNode.startPlayer()
         
        initTopBottomLineNode()           /// 加入上线二条碰撞线
        // 用Timer每隔1s调用 spawnBomb 注意此处是在State里，则target要为scene.self而不是self
        Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: scene.self, selector: #selector(scene.spawnBombs), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(2.0), target: scene.self, selector: #selector(scene.spawnCoins), userInfo: nil, repeats: true)
        
        
    }
    // MARK:- 加入上线二条碰撞线
    func initTopBottomLineNode(){
        
//        let topLine = LineNode()
//        topLine.initLine(size: scene.size, yPos: scene.size.height * 0.7)
//        scene.addChild(topLine)
//        
//        let bottomLine = LineNode()
//        bottomLine.initLine(size: scene.size, yPos: scene.size.height * 0.3)
//        scene.addChild(bottomLine)
        
    }
    /// 下一State是GameOver
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type
    }
    /// update
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if scene.moveAllowed {
            scene.moveCamera() /// 移动camera
            scene.playerNode.movePlayer() /// 移动玩家
            scene.moveSprites(camera: scene.mainCamera!) /// 移动天空及地面;
            scene.playerNode.reversePlayer()
        }else {
            scene.stopCamera() /// 停止camera
        }
        
        scene.removeCoins()
        
    }
    
}
