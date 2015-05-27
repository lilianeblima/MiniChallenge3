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


    // MARK: - View Creation

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
        //addNotes()
        addCleanButton()
        drawStave()
        addFirstNotes()
    }

    
    private func addNotes(){
        note = Note(duracao: "semibreve")
        note.position = CGPointMake(300, 100)
        note.name = "Note" + String(cont)
        note.zPosition = 15
        addChild(note)
    }
    
    private func addFirstNotes() {
        
        var FirstSemibreve: SKNode!
        var FirstMinima: SKNode!
        
        FirstSemibreve = SKSpriteNode(color: UIColor.purpleColor(), size: CGSize(width: 50, height: 50))
        FirstSemibreve.position = CGPointMake(300, 100)
        FirstSemibreve.name = "Semibreve"
        FirstSemibreve.zPosition = 0
        
        FirstMinima = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 50, height: 50))
        FirstMinima.position = CGPointMake(400, 100)
        FirstMinima.name = "Minima"
        
        addChild(FirstSemibreve)
        addChild(FirstMinima)
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

    func cleanButtonAction() {
        if notes.count > 0 {
        for(var i = 0; i < notes.count; i++) {
            notes[i].removeFromParent()
        }

         notes.removeAll(keepCapacity: false)
        }
    }

    // MARK: - Touch Events
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        if touchedNode.name == "Semibreve" {
            touchedNode.position = location
            touchedNode.zPosition = 0
            addNotes()
            
        }
        else if cleanButton.containsPoint(location) {
            cleanButtonAction()
        }
    }
    

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
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
                pinNoteToElementPosition(touchedNode, YCoordinate: elemYCoordinate)
                notes.append(touchedNode)
                touchedNode.physicsBody?.dynamic = true
                callSetNote(index, note: touchedNode)
                //addNotes()
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
            cont++
            zPosition = 0
            let touchedNode = nodeAtPoint(touchLocation) as! Note

            if !isNodeAboveElement(touchedNode) {
                returnToOriginPosition(touchedNode)
            }
        }

    }
    
    private func callSetNote(tone: Int, note: Note){
        switch(tone){
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


}
