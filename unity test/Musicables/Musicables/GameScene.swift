//
//  GameScene.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/15/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var counter = 0
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = SKColor.whiteColor()
            
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let point = touch.locationInNode(self)
        
        let node = self.nodeAtPoint(point)
        
        if node.name == nil {
            var note = Note(duracao: "semibreve")
            note.name = "semibreve"
            note.position = touch.locationInNode(self)
            self.addChild(note)
        }
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        var point = touch.locationInNode(self)
        
        var note = self.nodeAtPoint(point) as! Note
        
        if note.containsPoint(point) {
            point = touch.locationInNode(self)
            note.position = point
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        var point = touch.locationInNode(self)
        
        var note = self.nodeAtPoint(point) as! Note
        
        let act1 = SKAction.scaleTo(1.0, duration: 0.1)
        let act2 = SKAction.scaleTo(0.75, duration: 0.1)
        
        if note.position.y < self.frame.size.height/2 {
            note.setNote("do1")
            note.runAction(act1, completion: {
                note.runAction(act2)
            })
        }
        if note.position.y > self.frame.size.height/2 {
            note.setNote("do2")
            note.runAction(act1, completion: {
                note.runAction(act2)
            })
        }
        
    }

     override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

}
