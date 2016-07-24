//
//  GameScene.swift
//  MyGame
//
//  Created by Kurt Nistelberger on 24/04/16.
//  Copyright (c) 2016 Kurt Nistelberger. All rights reserved.
//

import SpriteKit

// they are global, so that we can handle when we switch to 
// background or became active again
var obstacle_handler: ObstacleHandler!
var gsc = GameStateClass()

// SKPhysicsContactDelegate
// for physics action, like collision detection
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var menu_manager: MenuManager!
    var hero: Hero!
    var point_counter = 0
    var highscore = 0
    
    override func didMoveToView(view: SKView) {
        
        // global Vars 
        SCENE_WIDTH = self.size.width
        SCENE_HEIGHT = self.size.height        
        
        // add physics world, for collision detection
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        
        // create MenuManager and setup First Start
        menu_manager = MenuManager(scene: self)
        menu_manager.setupFirstStart()
        
        // load highscore
        highscore = HighscoreSave.getHighscore()
        menu_manager.setHighscoreLabel(highscore)
        
        // create ObstacleHandler
        obstacle_handler = ObstacleHandler(scene: self)
        
        // create Hero
        hero = Hero(scene: self)
    }
    
    // fired every screen touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        if( gsc.game_state == GAME_STATE.START_SCREEN){
            startGame()
        }
        else if( gsc.game_state == GAME_STATE.GAME_PLAY){
            hero.jumpPhysics()
        }
        else if( gsc.game_state == GAME_STATE.GAME_DEAD){
            backToMenu(touches)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        if( gsc.game_state != GAME_STATE.GAME_PLAY){
            return;
        }
        
        // increase the game speed slowly
        SQUARE_SPEED += 0.05
        
        // update to count points
        if obstacle_handler.squares_tracker.count > 0 {
            
            let square = obstacle_handler.squares_tracker[0] as ObstacleSquare
            let square_pos = square.convertPoint(square.position, toNode: self)
            
            if square_pos.x < hero.position.x + 10 {
                obstacle_handler.squares_tracker.removeAtIndex(0)
                point_counter += 1
                obstacle_handler.act_points = point_counter
                menu_manager.updatePointsLabel(point_counter)
            }
        }
        
        // NSLog("hero pos: \(hero.position.x),\(hero.position.y)")
        
        // check if hero is in scene
        if(hero.position.x < -hero.size.width/2.0){
            
            // Game Over
            hero.jumping = false;
            hero.stopRun()
            obstacle_handler.pauseGeneratingSquares()
            obstacle_handler.act_points = 0
            menu_manager.gameOver()
             
            gsc.game_state = GAME_STATE.GAME_DEAD; 
            
            // check for new Highscore, if then save
            if(point_counter > highscore){
                // todo: congrats to new highscore or similar
                highscore = point_counter
                HighscoreSave.saveHighscore(highscore)
            }
        }
    }
    
    // SKPhysicsContactDelegate - fires when hero runs against square
    // not needed anymore, but leave code here, maybe I need it again
    func didBeginContact(contact: SKPhysicsContact) {

       /* var first_body, second_body: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            first_body = contact.bodyA
            second_body = contact.bodyB
        } else {
            first_body = contact.bodyB
            second_body = contact.bodyA
        }
        
        if((first_body.categoryBitMask & HERO_CATEGORY) != 0 &&
            (second_body.categoryBitMask & SQUARE_CATEGORY) != 0){
            // NSLog("SQUARE\n")
            
            // check for a frontal crash
            for i in 0...6 {
                
                if(obstacle_handler.squares_tracker.count <= i){
                    break;
                }
                
                if(( hero.position.x - obstacle_handler.squares_tracker[i].position.x ) < 0 ){
                    // frontal crash detected
                    NSLog("hero pos: \(hero.position.x),\(hero.position.y)")
                    NSLog("obst pos: \(obstacle_handler.squares_tracker[i].position.x),\(obstacle_handler.squares_tracker[i].position.y)")
                    
                    // Game Over Action
                    // add hero fall animation
                 /* hero.jumping = false;
                    hero.stopRun()
                    obstacle_handler.pauseGeneratingSquares()
                    obstacle_handler.act_points = 0
                    menu_manager.gameOver()
                    
                    game_state = GameState.GAME_DEAD
                    return;*/
                }
            }
        }
        
        if((first_body.categoryBitMask & HERO_CATEGORY) != 0 &&
            (second_body.categoryBitMask & BASELINE_CATEGORY) != 0){
            // NSLog("BASELINE\n")
            // nothing happend, just that he didn't fall to nirvana
        }
        
        // check for new Highscore, if then save
        if(point_counter > highscore){
            highscore = point_counter
            HighscoreSave.saveHighscore(highscore)
        }*/
    }
    
    func startGame(){
        
        // clear and set labels
        point_counter = 0
        SQUARE_SPEED = 200.0
        menu_manager.gameStart()
        
        // show hero
        hero.addToScene()
        hero.startRun()
        
        // start wall generation
        obstacle_handler.continueSquareGeneration()
        
        gsc.game_state = GAME_STATE.GAME_PLAY
    
        // debug prints
        // debug_window.printGameState(game_state.value());
    }
    
    func backToMenu(touches: Set<UITouch>){
        if let touch = touches.first {
            let touch_pos_back :CGPoint = touch.locationInNode(menu_manager.lb_back)
            if(touch_pos_back.x < 50 &&
               touch_pos_back.x > -150 &&
               touch_pos_back.y > -4)
            {
                menu_manager.gameBackToMenu()
                menu_manager.setHighscoreLabel(highscore)
                hero.removeFromScene()
                obstacle_handler.deleteAllSquares()
                gsc.game_state = GAME_STATE.START_SCREEN
            }
        }
    }
}
