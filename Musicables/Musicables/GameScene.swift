//
//  GameScene.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/15/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit

//var refer: SKSpriteNode!
//var refer2: SKSpriteNode!
var note: SKSpriteNode!
var cleanButton: SKSpriteNode!
var line: SKSpriteNode!
var arrayLines = Array<SKSpriteNode>()
var arrayPositionX = Array<CGFloat>()
var arrayPositionY = Array<CGFloat>()
var arrayNotes = Array<SKSpriteNode>()
var positionY = CGFloat()

//var midLineY:CGFloat?



class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        

        /* Setup your scene here */
        //midLineY = self.view!.bounds.height/3
        
        for var i = 0;i < 13; i++ {
            
            line = SKSpriteNode()
            
            if(i%2==0){
                //Inserindo linhas
                line.position = CGPointMake(200, CGFloat(250+25*i))
                line.size.height = 13
                line.size.width = 1600
                line.color = UIColor.blackColor()
                line.name = "line" + String(i)
                if(i==0 || i==12){
                    //Inserindo as linhas do1 e la2
                    line.color = UIColor.redColor()
                }
            }
            else{
                //Inserindo espacos
                line.position = CGPointMake(200, CGFloat(250+25*i))
                line.size.height = 35
                line.size.width = 1600
                line.color = UIColor.lightGrayColor()
                line.name = "line" + String(i)
            }
            
            arrayLines.append(line)
            arrayPositionY.append(line.position.y)
            addChild(line)
            
        }

//        arrayPositionX = [100,200,300,400]
//        
//        var i: CGFloat = 250
//        var j = 0
//        
//        while (i <= 590 && j < 5) {
//            let one = SKSpriteNode()
//            one.size.width = 3000
//            one.size.height = 5
//            //one.color = colors[j]
//            one.position = CGPointMake(0, i)
//            self.addChild(one)
//            i = i + 85
//            ++j
//        }
        /* Setup your scene here */

        self.backgroundColor = SKColor.whiteColor()
        
        note = SKSpriteNode(imageNamed: "point.png")
        note.position = CGPointMake(200, 100)
        note.color = UIColor.redColor()
        arrayNotes.append(note)
        addChild(note)
//        
//       
//        refer = SKSpriteNode(imageNamed: "point.png")
//        refer.position = CGPointMake(100, 100)
//        refer.zPosition = 0
//        refer.size.height = 50
//        refer.size.width = 50
//        addChild(refer)
//        
//        refer2 = SKSpriteNode(imageNamed: "point2.png")
//        refer2.position = CGPointMake(200, 100)
//        refer2.zPosition = 0
//        refer2.size.height = 50
//        refer2.size.width = 50
//        addChild(refer2)
        
        addCleanButton()
            
            
            
    }
    
    func addCleanButton() {
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
            
            for var i = 0; i < arrayLines.count; i++ {
                if note.position.y == arrayLines[i].position.y || abs(note.position.y - arrayLines[i].position.y) < 15 {
                    
                    if (abs(note.position.x - arrayLines[i].position.y) < abs(note.position.x - arrayLines[i-1].position.y)){
                
                        if(abs(note.position.x - arrayLines[i].position.y) <= abs(note.position.x - arrayLines[i+1].position.y)) {
                            touchedNode.position.y = arrayLines[i].position.y
                            touchedNode.position.x = 300
                            break
                        }
                        else{
                            touchedNode.position.y = arrayLines[i].position.y
                            touchedNode.position.x = 300
                            break
                        }
                    }
            
                    else if(abs(note.position.x - arrayLines[i].position.y) > abs(note.position.x - arrayLines[i-1].position.y)){
                        touchedNode.position.y = arrayLines[i].position.y
                        touchedNode.position.x = 300
                        break
                    }
                
                }
                
            }
        }
    }

   
     override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
