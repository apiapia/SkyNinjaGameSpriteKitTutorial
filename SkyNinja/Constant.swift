//
//  PhysicsCategory.swift
//  SkyNinja
//
//  Created by Chen on 2018/6/11.
//  Copyright © 2018 iFiero. All rights reserved.
//

import UIKit
import SpriteKit
import CoreGraphics

public let SCENE_WIDTH:CGFloat   = 2048
public let SCENE_HEIGHT:CGFloat  = 1536
public let SCENE_NUMBERS:CGFloat = 2 // 二个场景 HardCode
public let CAMERA_MOVE_XPOS:CGFloat   = 18  /// 相机X-Axis移动的尺寸;

// 物理标识;
struct PhysicsCategory {
    
    static let None: UInt32      = 0x1 << 1
    static let Player: UInt32    = 0x1 << 2
    static let Bomb: UInt32      = 0x1 << 3
    static let Coin:UInt32       = 0x1 << 4
    static let GroudLine: UInt32 = 0x1 << 5
    static let SkyLine: UInt32   = 0x1 << 6
    static let MiddleLine:UInt32 = 0x1 << 7  // 中间物理碰撞线
    
}
