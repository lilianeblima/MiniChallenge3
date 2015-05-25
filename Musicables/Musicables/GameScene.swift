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
var contArrayNotes = 0
var NoteOutLine = false

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
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
        
        self.backgroundColor = SKColor.whiteColor()
        
        addNotes()
        
        addCleanButton()
            
    }
    
    func addNotes(){
        note = SKSpriteNode(color: UIColor.purpleColor(), size: CGSize(width: 50, height: 50))
        note.position = CGPointMake(200, 100)
        note.color = UIColor.redColor()
        arrayNotes.append(note)
        addChild(note)
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
        for(var i = 0; i < arrayNotes.count; i++){
            arrayNotes[i].removeFromParent()
        }
        contArrayNotes=0
        addNotes()
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
                
                if  (note.position.y == arrayLines[i].position.y || abs(note.position.y - arrayLines[i].position.y) < 15) {
                    NoteOutLine = false
                    
                    if i == 0{
                        touchedNode.position.y = arrayLines[i].position.y
                        break
                        
                    }
                    
                    if i != 0 && (abs(note.position.y - arrayLines[i].position.y) < abs(note.position.y - arrayLines[i-1].position.y)){
                
                        if((i==0) && abs(note.position.y - arrayLines[i].position.y) <= abs(note.position.y - arrayLines[i+1].position.y)) {
                            touchedNode.position.y = arrayLines[i].position.y
                            
                            break
                        }
                        else{
                            touchedNode.position.y = arrayLines[i].position.y
                            break
                        }
                    }
            
                    else if (abs(note.position.y - arrayLines[i].position.y) > abs(note.position.y - arrayLines[i-1].position.y)){
                        touchedNode.position.y = arrayLines[i].position.y
                        break
                    }
                }
                
                NoteOutLine = true
                
            }
            
            
            if NoteOutLine == true{
                note.position = CGPointMake(200, 100)
            }
            
           
            
            if NoteOutLine == false{
            
                if(contArrayNotes == 0){
                    touchedNode.position.x = 100
                }
                else{
                    touchedNode.position.x = arrayNotes[contArrayNotes-1].position.x + 150
                }
                contArrayNotes++
                addNotes()
            }
            
        }
    }

   
     override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
