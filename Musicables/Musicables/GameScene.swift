//
//  GameScene.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/15/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
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
        }
        
        let node = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(100, 100))
        node.position = CGPointMake(50, 50)
        self.addChild(node)
        
        
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
