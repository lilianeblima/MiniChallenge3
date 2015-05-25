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

enum StaveElements {
    case Line
    case Space
}

class GameScene: SKScene {

    // MARK: - Constants

    // Declare stave constants.
    private let partialnumberOfLines = 5
    private let totalNumberOfLines = 7
    private let partialNumberOfSpaces = 4
    private let totalNumberOfSpaces = 6

    // The stave takes about a third of the screen's height,
    // so both top and bottom margins measures 256 points.
    private let bottomMargin: CGFloat = 256.0
    private let topMargin: CGFloat = 256.0

    // Arbitrary X-axis offset distance and elements length.
    private let leftMargin: CGFloat = 100.0
    private let lineLength: CGFloat = 10000.0

    // Declare stave dimension.
    private let lineWidth: CGFloat = 16.0
    private let spaceWidth: CGFloat = 48.0

    // Y-Axis note point coordinates equally distributed.
    private let YCoordinates = [
        192.0,
        224.0,
        256.0,
        288.0,
        320.0,
        352.0,
        384.0,
        416.0,
        448.0,
        480.0,
        512.0,
        544.0,
        576.0
    ]

    // Color schemes.
    private let staveColors = [
        UIColor(red: 0.694, green: 0.0, blue: 1.0, alpha: 1.0), // line
        UIColor(red: 0.435, green: 1.0, blue: 0.651, alpha: 1.0), // space
        UIColor(red: 0.584, green: 0.0, blue: 1.0, alpha: 1.0), // line
        UIColor(red: 0.033, green: 1.0, blue: 0.671, alpha: 1.0), // space
        UIColor(red: 0.047, green: 0.706, blue: 1.0, alpha: 1.0), // line
        UIColor(red: 1.0, green: 0.988, blue: 0.333, alpha: 1.0), // space
        UIColor(red: 0.027, green: 1.0, blue: 0.0, alpha: 1.0), // line
        UIColor(red: 1.0, green: 0.659, blue: 0.376, alpha: 1.0), // space
        UIColor(red: 1.0, green: 0.808, blue: 0.047, alpha: 1.0), // line
        UIColor(red: 0.333, green: 0.455, blue: 1.0, alpha: 1.0), // space
        UIColor(red: 1.0, green: 0.2, blue: 0.0, alpha: 1.0), // line
        UIColor(red: 1.0, green: 0.475, blue: 0.832, alpha: 1.0), // space
        UIColor(red: 1.0, green: 0.0, blue: 0.424, alpha: 1.0), // line
    ]

    // MARK: - View Creation

    override func didMoveToView(view: SKView) {

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

        drawStave()
    }

    private func drawContinuousLine(#YCoordinate: CGFloat, shape: StaveElements, color: UIColor) -> SKShapeNode {
        var startPoint = CGPointMake(leftMargin, YCoordinate)
        var endPoint = CGPointMake(lineLength, YCoordinate)
        var points = [startPoint, endPoint]
        var line = SKShapeNode(points: &points, count: points.count)

        if shape == StaveElements.Line {
            line.lineWidth = lineWidth
            line.lineCap = kCGLineCapRound
            line.glowWidth = 1.0
            line.strokeColor = color
        } else {
            line.lineWidth = spaceWidth
            line.lineCap = kCGLineCapButt
            line.glowWidth = 0
            line.strokeColor = color
        }

        return line
    }

    private func drawStave() {
        for index in 2...10 {
            var shape: SKShapeNode
            var YCoordinate = CGFloat(YCoordinates[index])
            var color = staveColors[index]

            if (index % 2) == 0 {
                shape = drawContinuousLine(YCoordinate: YCoordinate, shape: StaveElements.Line, color: color)
            } else {
                shape = drawContinuousLine(YCoordinate: YCoordinate, shape: StaveElements.Space, color: color)
            }

            addChild(shape)
        }
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
            touchedNode.zPosition = 0
            
            if abs(note.position.x - refer.position.x) < abs(note.position.x - refer2.position.x){
                touchedNode.position = refer.position
                
            }
            else{
                touchedNode.position = refer2.position
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
