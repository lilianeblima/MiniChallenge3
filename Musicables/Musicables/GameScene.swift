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
var line: SKSpriteNode!
var arrayLines = Array<SKSpriteNode>()
var arrayPositionX = Array<CGFloat>()
var arrayPositionY = Array<CGFloat>()
var arrayNotes = Array<SKSpriteNode>()
var positionY = CGFloat()

var midLineY:CGFloat?



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
        midLineY = self.view!.bounds.height/3
        
        for var i = 0;i < 5; i++ {
            
            line = SKSpriteNode()
            line.position = CGPointMake(0, midLineY! + CGFloat(60*i))
            line.size.height = 13
            line.size.width = 1600
            line.color = UIColor.redColor()
            line.name = "line" + String(i)
            arrayLines.append(line)
            arrayPositionY.append(line.position.y)
            addChild(line)
            
        }

        arrayPositionX = [100,200,300,400]
        

        self.backgroundColor = SKColor.whiteColor()
        
        note = SKSpriteNode(imageNamed: "note.png")
        note.position = CGPointMake(200, 500)
        addChild(note)
        
       
        refer = SKSpriteNode(imageNamed: "point.png")
        refer.position = CGPointMake(100, 100)
        refer.zPosition = 0
        refer.size.height = 50
        refer.size.width = 50
        addChild(refer)
        
        refer2 = SKSpriteNode(imageNamed: "point2.png")
        refer2.position = CGPointMake(200, 100)
        refer2.zPosition = 0
        refer2.size.height = 50
        refer2.size.width = 50
        addChild(refer2)

       // array = [200, 300]
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        arrayLines[3].color = UIColor.greenColor()
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        
        if refer.containsPoint(location){
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
        
        if refer.containsPoint(location){
            let touchedNode = nodeAtPoint(location)
            touchedNode.position = location
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        if refer.containsPoint(location){
            let touchedNode = nodeAtPoint(location)
            touchedNode.zPosition = 1
            
            for var a = 0; a < arrayPositionY.count; a++ {
                if refer.position.y == arrayPositionY[a] || abs(refer.position.y - arrayPositionY[a]) < 15 {
                    refer.position.y = arrayPositionY[a]
                    positionY = arrayPositionY[a]
                    println(positionY)
                    break
                }
                    else{
                        positionY = 0
                        println("nao esta na linha")
                    }
                
                
            }
            
            if positionY != 0{
                refer.position = CGPointMake(200, positionY)
                }
            }
    }

   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
