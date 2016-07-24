//
//  GameConstants.swift
//  MyGame
//
//  Created by Kurt Nistelberger on 26/04/16.
//  Copyright © 2016 Kurt Nistelberger. All rights reserved.
//

import Foundation
import UIKit


// ***CONSTANTS*****************************************************************

// Font Sizes
let BIG_FONTSIZE: CGFloat = 70.0
let MIDDLE_FONTSIZE: CGFloat = 50.0
let SMALL_FONTSIZE: CGFloat = 40.0
let TEST_FONTSIZE: CGFloat = 30.0

// Collision Detection
let HERO_CATEGORY: UInt32 = 0x1 << 0
let SQUARE_CATEGORY: UInt32 = 0x1 << 1
let BASELINE_CATEGORY: UInt32 = 0x1 << 2

// Square Size
let SQUARE_SIDE: CGFloat = 30.0

// Obstacle creation Speed
let OBST_SPEED: NSTimeInterval = 0.6666666


// ***Fixed VARS****************************************************************
var SCENE_WIDTH: CGFloat = 0.0
var SCENE_HEIGHT: CGFloat = 0.0


// ***Variable VARS*************************************************************
var SQUARE_SPEED: CGFloat = 200.0 
var DEBUG_WINDOW: Bool = true