//
//  GameOverState.swift
//  SkyNinja
//
//  Created by Chen on 2018/6/10.
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState:GKState {
    
    unowned let scene:GameScene
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.moveAllowed = false
        scene.stopSpawning()
        print("GameOver State 游戏结束")
        initGameOver()
        
    }
    
    func initGameOver(){
        ///CAMERA有移动了;
        let xPos = scene.mainCamera.position.x
        let yPos = scene.mainCamera.position.y
        
        let loseNode = SKSpriteNode(imageNamed: "youlose")
        loseNode.setScale(0.7)
        loseNode.zPosition = 6
        loseNode.position = CGPoint(x: xPos, y: yPos + 60)
        scene.addChild(loseNode)
        
        let tapNode = SKSpriteNode(imageNamed: "tapToPlay")
        tapNode.name = "tapToPlay"
        tapNode.position = CGPoint(x: xPos, y: yPos - 60)
        tapNode.setScale(0.7)
        tapNode.zPosition = 6 
        scene.addChild(tapNode)
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayState.Type
    }
}
