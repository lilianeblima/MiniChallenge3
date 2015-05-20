//
//  GameScene.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/15/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit

var refer: SKSpriteNode!
var refer2: SKSpriteNode!
var note: SKSpriteNode!
var cleanButton: SKSpriteNode!

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
<<<<<<< HEAD
        
        self.backgroundColor = SKColor.whiteColor()
        
        let colors = [SKColor.redColor(), SKColor.blueColor(), SKColor.greenColor(), SKColor.yellowColor(), SKColor.grayColor()]
        
        var i: CGFloat = 250
        var j = 0
        
        while (i <= 590 && j < 5) {
            let one = SKSpriteNode()
            one.size.width = 3000
            one.size.height = 5
            one.color = colors[j]
            one.position = CGPointMake(0, i)
            self.addChild(one)
            i = i + 85
            ++j
=======
        /* Setup your scene here */

        self.backgroundColor = SKColor.whiteColor()
        
        note = SKSpriteNode(imageNamed: "note.png")
        note.position = CGPointMake(200, 600)
        addChild(note)
        
        refer = SKSpriteNode(imageNamed: "point.png")
        refer.position = CGPointMake(200, 400)
        refer.zPosition = 0
        addChild(refer)
        
        refer2 = SKSpriteNode(imageNamed: "point2.png")
        refer2.position = CGPointMake(300, 400)
        refer.zPosition = 0
        addChild(refer2)
        
        addCleanButton()
    }
    
    func addCleanButton(){
        cleanButton = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 200, height: 100))
        cleanButton.name = "cleanButton"
        cleanButton.position = CGPointMake(800, 150)
        cleanButton.zPosition = 1
        
        let labelCleanButton = SKLabelNode(fontNamed: "Helvetica")
        labelCleanButton.fontSize = CGFloat(22.0)
        labelCleanButton.fontColor = SKColor.whiteColor()
        labelCleanButton.text = "Limpar"
        cleanButton.addChild(labelCleanButton)
        
        addChild(cleanButton)
    
    }
    
    func cleanButtonAction(){
        note.removeFromParent()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        
        if note.containsPoint(location){
            let touchedNode = nodeAtPoint(location)
            touchedNode.zPosition = 15
        }
        
        //Remove note action
        if cleanButton.containsPoint(location){
            cleanButtonAction()
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        
        if note.containsPoint(location){
            let touchedNode = nodeAtPoint(location)
            touchedNode.position = location
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        if note.containsPoint(location){
            let touchedNode = nodeAtPoint(location)
            touchedNode.zPosition = 1
            
            if abs(note.position.x - refer.position.x) < abs(note.position.x - refer2.position.x){
                touchedNode.position = refer.position
                
            }
            else{
                touchedNode.position = refer2.position
            }
            
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        if note.containsPoint(location){
            let touchedNode = nodeAtPoint(location)
            touchedNode.zPosition = 1
            
            if abs(note.position.x - refer.position.x) < abs(note.position.x - refer2.position.x){
                touchedNode.position = refer.position
                
            }
            else{
                touchedNode.position = refer2.position
            }
        }
        
        let node = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(100, 100))
        node.position = CGPointMake(50, 50)
        self.addChild(node)
        
        
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
