//
//  GameViewController.swift
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
 *  SkyNinja 天猪之城 在此游戏中您将获得如下技能：
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

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                scene.size = CGSize(width: SCENE_WIDTH, height: SCENE_HEIGHT)
                scene.anchorPoint = CGPoint(x: 0, y: 0)  /// 设置anchorPoint为(0,0)
                view.presentScene(scene)
            }
            /* ***** 千万嫑嫑嫑小看了这一句的强大功效(监测物理体外框) ***** */
           // view.showsPhysics = true
            view.ignoresSiblingOrder = true  /// 是否忽略图层自动排列 true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
