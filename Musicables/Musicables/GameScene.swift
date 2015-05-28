//
//  GameScene.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/15/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit

var note: Note!
var cleanButton: SKSpriteNode!
var playButton: SKSpriteNode!

enum StaveElements {
    case Line
    case Space
}


class GameScene: SKScene {

    // MARK: - Constants
    // Not all lines and spaces are visible, only those
    // counted as partial.
    private let partialnumberOfLines = 5
    private let totalNumberOfLines = 7
    private let partialNumberOfSpaces = 4
    private let totalNumberOfSpaces = 6

    // The stave takes about a third of the screen's height,
    // so both top and bottom margins measures 256 points.
    private let bottomMargin: CGFloat = 256.0
    private let topMargin: CGFloat = 256.0

    // Arbitrary X-axis offset distance and elements length.
    private let leftMargin: CGFloat = 0.0
    private let lineLength: CGFloat = 1024.0

    // Declare stave dimension.
    private let lineWidth: CGFloat = 16.0
    private let spaceWidth: CGFloat = 48.0

    // Distance between notes.
    private let spaceFromStart: CGFloat = 256.0
    private let spaceBetweenNotes: CGFloat = 82.7

    // Y-Axis note point coordinates are evenly distributed.
    private let YCoordinates: [CGFloat] = [
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
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), // line
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), // space
        UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0), // line
        UIColor(red: 1.0, green: 0.376, blue: 0.0, alpha: 1.0), // space
        UIColor(red: 1.0, green: 0.604, blue: 0.0, alpha: 1.0), // line
        UIColor(red: 1.0, green: 0.804, blue: 0.0, alpha: 1.0), // space
        UIColor(red: 0.996, green: 1.0, blue: 0.0, alpha: 1.0), // line
        UIColor(red: 0.729, green: 0.91, blue: 0.024, alpha: 1.0), // space
        UIColor(red: 0.18, green: 0.808, blue: 0.047, alpha: 1.0), // line
        UIColor(red: 0.047, green: 0.6, blue: 0.808, alpha: 1.0), // space
        UIColor(red: 0.047, green: 0.357, blue: 0.808, alpha: 1.0), // line
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), // space
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), // line
    ]


    // MARK: - Global Variables
    // Added Notes
    private var notes = [Note]()
    //Cont Name Note
    var cont = 0
    //Disable double touch
    var touchNote = false


    // Action Buttons
    private let actionButtonsXCoordinate = 96.0

    private let actionButtonsYCoordinates = [
        00.0,
        30.0,
        60.0,
        90.0,
    ]

    private let actionButtonsNames = [
        "backButton",
        "playButton",
        "saveButton",
        "clearButton"
    ]


    // MARK: - View Creation

    private func addButtons() {
        var button: SKSpriteNode

        for buttonName in actionButtonsNames {
            button = SKSpriteNode(imageNamed: buttonName)
//            button.position = CGPointMake(actionButtonsXCoordinate, actionButtonsYCoordinates[])
        }
    }

    private func drawShape(#YCoordinate: CGFloat, shape: StaveElements, color: UIColor) -> SKShapeNode {
        var startPoint = CGPointMake(leftMargin, YCoordinate)
        var endPoint = CGPointMake(lineLength, YCoordinate)
        var points = [startPoint, endPoint]
        var shapeNode = SKShapeNode(points: &points, count: points.count)

        if shape == StaveElements.Line {
            shapeNode.lineWidth = lineWidth
            shapeNode.strokeColor = color
        } else {
            shapeNode.lineWidth = spaceWidth
            shapeNode.strokeColor = color
        }

        return shapeNode
    }

    private func drawStave() {
        let staveSize = totalNumberOfLines + totalNumberOfSpaces
        var shape: SKShapeNode
        var YCoordinate: CGFloat
        var color: UIColor

        for var index = 0; index < staveSize; index++ {
            YCoordinate = YCoordinates[index]
            color = staveColors[index]

            if (index % 2) == 0 {
                shape = drawShape(YCoordinate: YCoordinate, shape: StaveElements.Line, color: color)
            } else {
                shape = drawShape(YCoordinate: YCoordinate, shape: StaveElements.Space, color: color)
            }

            addChild(shape)
        }
    }

    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.clearColor()
        addCleanButton()
        addPlayButton()
        drawStave()
        addButtons()
        addFirstNotes()
    }

    
    private func addNotes(noteDurations: SKNode){
        note = Note(duracao: noteDurations.name!)
        note.position = CGPointMake(noteDurations.position.x, 100)
        note.name = "Note" + String(cont)
        note.zPosition = 15
        addChild(note)
    }
    
    private func addFirstNotes() {
        
       
        
        firstSemibreve = SKSpriteNode(color: UIColor.purpleColor(), size: CGSize(width: 50, height: 50))
        firstSemibreve.position = CGPointMake(100, 100)
        firstSemibreve.name = "semibreve"
        firstSemibreve.zPosition = 0
        
        firstMinima = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 50, height: 50))
        firstMinima.position = CGPointMake(200, 100)
        firstMinima.name = "minima"
        
        firstSeminima = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 50, height: 50))
        firstSeminima.position = CGPointMake(300, 100)
        firstSeminima.name = "seminima"
        
        firstColcheia = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 50, height: 50))
        firstColcheia.position = CGPointMake(400, 100)
        firstColcheia.name = "colcheia"
        
        addChild(firstSemibreve)
        addChild(firstMinima)
        addChild(firstSeminima)
        addChild(firstColcheia)
    }

    private func addCleanButton() {
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
    
    func addPlayButton(){
        playButton = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 150, height: 100))
        playButton.name = "playButton"
        playButton.position = CGPointMake(600, 150)
        playButton.zPosition = 1
        
        addChild(playButton)
        
        let labelPlayButton = SKLabelNode(fontNamed: "Helvetica")
        labelPlayButton.fontSize = CGFloat(22.0)
        labelPlayButton.fontColor = SKColor.whiteColor()
        labelPlayButton.text = "Play"
        playButton.addChild(labelPlayButton)
        
    }
    

    func cleanButtonAction() {
        for(var i = 0; i < notes.count; i++) {
            notes[i].removeFromParent()
        }
    }
    
    func playButtonAction() {
        if(notes.isEmpty) {
            println("Sem notas ainda")
        }
        else{
    
        }
        
    }

    // MARK: - Touch Events

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        firstSemibreve.userInteractionEnabled = false
        
        if playButton.containsPoint(location){
            playButtonAction()
        }
        
        if cleanButton.containsPoint(location){
            cleanButtonAction()
        }
        }
    }

    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        touchNote = true
        
        if touchedNode.name == "Note" + String(cont) {
            touchedNode.position = location
            touchedNode.zPosition = 15
        }
    }
    
    // MARK: Pinning Notes

    private func pinNoteToElementPosition(touchedNode: Note, YCoordinate: CGFloat) {
        touchedNode.zPosition = 1.0
        touchedNode.position.y = YCoordinate

        if let lastNode = notes.last {
            // Add a space from the last added note's X coordinate.
            touchedNode.position.x = (lastNode.position.x + spaceBetweenNotes)
        } else {
            touchedNode.position.x = spaceFromStart
        }
    }

    private func isNodeAboveElement(touchedNode: Note) -> Bool {
        let noteYCoordinate: CGFloat = note.position.y // Note Position
        var elemYCoordinate: CGFloat // Line or Space Position
        var distanceToThisElement: CGFloat // Distance to this line or space.
        var isNoteAboveElement = false

        // For each line and space:
        // Check if the touched node is above it.
        for var index = 0; index < YCoordinates.count; index++ {
            elemYCoordinate = YCoordinates[index]
            distanceToThisElement = abs(noteYCoordinate - elemYCoordinate)

            if distanceToThisElement <= lineWidth {
                // TODO: Animate element when node is above it.

                pinNoteToElementPosition(touchedNode, YCoordinate: elemYCoordinate)
                notes.append(touchedNode)
                happiness(touchedNode.position)
                callSetNote(index, note: touchedNode)
                return true
            }
        }

        return false
    }

    private func returnToOriginPosition(node: Note) {
        node.removeFromParent()
    }
 
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchItem = touches.first as! UITouch
        let touchLocation = touchItem.locationInNode(self)

        if note.containsPoint(touchLocation) {
            let touchedNode = nodeAtPoint(touchLocation) as! Note

            
            if !isNodeAboveElement(touchedNode) {
                returnToOriginPosition(touchedNode)
                
            }
            
            
            
        }
    }
    
    private func callSetNote(tone: Int, note: Note) {
        switch(tone) {
            case 0:
                note.setNote("do1")
            case 1:
                note.setNote("re1")
            case 2:
                note.setNote("mi1")
            case 3:
                note.setNote("fa1")
            case 4:
                note.setNote("sol1")
            case 5:
                note.setNote("la1")
            case 6:
                note.setNote("si1")
            case 7:
                note.setNote("do2")
            case 8:
                note.setNote("re2")
            case 9:
                note.setNote("mi2")
            case 10:
                note.setNote("fa2")
            case 11:
                note.setNote("sol2")
            case 12:
                note.setNote("la2")
            default:
                note.setNote("do1")
        }
    }
    
    private func happiness(pos: CGPoint){
        var emitterNode = SKEmitterNode(fileNamed: "Particle.sks")
        emitterNode.particlePosition = pos
        self.addChild(emitterNode)

        
        // remove particles after 0.6 seconds
        self.runAction(SKAction.waitForDuration(1), completion: {
            emitterNode.particleAlpha = 1
            self.runAction(SKAction.waitForDuration(1), completion: {
                emitterNode.particleAlpha = 0
                emitterNode.removeFromParent()
            })

        })
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }

    // MARK: - Animations

    private func animateElement() {

    }


}
