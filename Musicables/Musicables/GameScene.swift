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
var musicButton: SKSpriteNode!
var undoButton: SKSpriteNode!
var firstSemibreve: SKSpriteNode!
var firstMinima: SKSpriteNode!
var firstSeminima: SKSpriteNode!
var firstColcheia: SKSpriteNode!

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
   // private let spaceBetweenNotes: CGFloat = 82.7
    private let spaceBetweenNotes: CGFloat = 100

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
    
    // Background Color Scene
    let bgColorScene = UIColor(red: 111/255, green: 215/255, blue: 215/255, alpha: 1)
    
    // MARK: - Global Variables
    // Added Notes
    private var notes = [Note]()
    //Cont Name Note
    var cont = 0
    //Disable double touch
    var touchNote = false
    var dropNote = false
    //Count To Music
    var countMusic = 0
    
    //To Scroll
    
    var touchInitScroll: CGPoint!
    var touchEndScroll: CGPoint!
    var touchScroll = 0
    
    var scrollX = 0
    var scrollY = 0
    let scrollIndicator = SKSpriteNode(imageNamed: "scroll_indicador")
    
    
    var lastPositionNote: CGFloat!
    var disableScrollRight = false
    var disableScrollLeft = false
    var lastNotePositionOutScreen = false
    var scrollHasBeenActivaed = false
    
    // Initial Sound
    private let initialSound = "initial_sound_main_game_scene.mp3"
    
    // Remove Sound
    private let removeSound = "remove_note.mp3"
    
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
        "clearButton",
        "undoButton"
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
        self.backgroundColor = bgColorScene
        addClouds()
        addClave()
        addCleanButton()
        addMusicButton()
        addUndoButton()
        drawStave()
        addButtons()
        addFirstNotes()
        playNote(initialSound)
        lastPositionNote = 0
    }
    
    private func addNotes(noteDurations: SKNode){
        note = Note(duracao: noteDurations.name!)
        note.position = CGPointMake(noteDurations.position.x, 100)
        note.name = "Note" + String(cont)
        note.zPosition = 15
        println("Erro?")
        println("AnchorPoint= \(note.anchorPoint)")
        
        if noteDurations.name! == "minima" {
            note.anchorPoint.y = 0.36
        }
        
        if noteDurations.name! == "seminima" || noteDurations.name! == "colcheia"{
            note.anchorPoint.y = 0.32
        }
        
      

        addChild(note)
        scaleUp(note)
    }
    let clave = SKSpriteNode(imageNamed: "clave")
    private func addClave() {
        clave.size = CGSize(width: 250, height: 500)
        clave.position = CGPointMake(100, 380)
        clave.name = "clave"
        
        addChild(clave)
    }
    
    private func addFirstNotes() {
        
        firstSemibreve = SKSpriteNode(imageNamed: "button_semibreve")
        firstSemibreve.size = CGSize(width: 100, height: 100)
        firstSemibreve.position = CGPointMake(100, 100)
        firstSemibreve.name = "semibreve"
        
        firstMinima = SKSpriteNode(imageNamed: "button_minima")
        firstMinima.size = CGSize(width: 100, height: 100)
        firstMinima.position = CGPointMake(225, 100)
        firstMinima.name = "minima"
        
        firstSeminima = SKSpriteNode(imageNamed: "button_seminima")
        firstSeminima.size = CGSize(width: 100, height: 100)
        firstSeminima.position = CGPointMake(350, 100)
        firstSeminima.name = "seminima"
        
        firstColcheia = SKSpriteNode(imageNamed: "button_colcheia")
        firstColcheia.size = CGSize(width: 100, height: 100)
        firstColcheia.position = CGPointMake(475, 100)
        firstColcheia.name = "colcheia"
        
        addChild(firstSemibreve)
        addChild(firstMinima)
        addChild(firstSeminima)
        addChild(firstColcheia)
        
    }
    
    private func addMusicButton() {
        musicButton = SKSpriteNode(texture: SKTexture(imageNamed: "play"), size: CGSize(width: 100, height: 100))
        musicButton.name = "playButton"
        musicButton.position = CGPointMake(700, 100)
        musicButton.zPosition = 1
        
        addChild(musicButton)
    }
    
    private func addCleanButton() {
        cleanButton = SKSpriteNode(texture: SKTexture(imageNamed: "clean"), size: CGSize(width: 100, height: 100))
        cleanButton.name = "cleanButton"
        cleanButton.position = CGPointMake(825, 100)
        cleanButton.zPosition = 1
        
        addChild(cleanButton)
    }
    
    private func addUndoButton() {
        undoButton = SKSpriteNode(texture: SKTexture(imageNamed: "undo"), size: CGSize(width: 100, height: 100))
        undoButton.name = "undoButton"
        undoButton.position = CGPointMake(950, 100)
        undoButton.zPosition = 1
        
        addChild(undoButton)
    }

    
    private func addClouds() {
        let cloud1 = SKSpriteNode(imageNamed: "nuvem")
        cloud1.name = "cloud1"
        cloud1.position = CGPointMake(150, 675)
        cloud1.zPosition = 1
        cloud1.setScale(0.3)
        
        let cloud2 = SKSpriteNode(imageNamed: "nuvem")
        cloud2.name = "cloud2"
        cloud2.position = CGPointMake(510, 675)
        cloud2.zPosition = 1
        cloud2.setScale(0.3)
        
        let cloud3 = SKSpriteNode(imageNamed: "nuvem")
        cloud3.name = "cloud2"
        cloud3.position = CGPointMake(875, 675)
        cloud3.zPosition = 1
        cloud3.setScale(0.3)
    
        addChild(cloud1)
        addChild(cloud2)
        addChild(cloud3)
    }
    
    func cleanButtonAction() {
        if notes.count > 0 {
            for var index = 0; index < notes.count; index++ {
                notes[index].removeFromParent()
            }
            notes.removeAll(keepCapacity: false)
            lastNotePositionOutScreen = false
        }
    }
    
    private func undoButtonAction() {
        if notes.count > 0 && musicPlay == false{
            removeNoteAction(notes.last!)
            notes.removeLast()
            lastNotePositionOutScreen = false
        }
    }
    var musicPlay = false
    private func playMusic() {
        var sound:String!
        var sound2:String!
        musicPlay = true
        sound = notes[countMusic].getSound()
        runAction(SKAction .playSoundFileNamed(sound, waitForCompletion: true), completion: {
            if self.countMusic < self.notes.count-1 {
                let priorityy = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priorityy, 0)) {
                    
                    self.playNoteAnimation(self.notes[self.countMusic+1])
                    self.countMusic++
                    self.playMusic()
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.MoveMusic()
                    }
                }
            }
            else{
                println("So uma vez")
                self.musicPlay = false
            }
        })
    }
    
    func playSound(s:SKAction){
        runAction(s)
    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        touchInitScroll = location
        firstSemibreve.userInteractionEnabled = false
        println("Began")
        scrollIndicator.position = CGPointMake(1024/2-20, 100)
        
        if touchNote == false {
            println("1")
            if touchedNode.name == nil {
                touchScroll = 1
            }
                disableScrollRight = false
                disableScrollLeft = false
            
            if touchedNode.name == "semibreve" || touchedNode.name == "minima" || touchedNode.name == "seminima" || touchedNode.name == "colcheia"  {
                touchedNode.zPosition = 0
                println("3")
                
                if scrollHasBeenActivaed == true {
                    println("4")
                    MoveScreen()
                }
                
                if lastPositionNote < 900 {
                    lastNotePositionOutScreen = false
                }
                if lastPositionNote >= 900 || lastNotePositionOutScreen == true{
                    println("5")
                    lastNotePositionOutScreen = true
                    //Se houver mais notas do que mostrar na tela
                    Move()
                }
                addNotes(touchedNode)
                
            }
            else if cleanButton.containsPoint(location) {
                cleanButtonAction()
                musicPlay = false
            }
                
            else if musicButton.containsPoint(location) {
                if musicPlay == false {
                    self.countMusic = 0
                    if self.notes.count != 0 {
                        MoveStart()
                        playMusic()
                       
                    }
                    
                }
                
            }
            else if undoButton.containsPoint(location) {
                undoButtonAction()
            }
        }
    }
   
    private func scroll() {
        println("Scroll")
        var t1 = notes.last?.position
        if notes.count != 0 {
            var t2 = notes[0].position.x

            
        
        if touchScroll == 1  {
            
            scrollX = Int(touchInitScroll.x) - Int(touchEndScroll.x)
            scrollY = Int(touchInitScroll.y) - Int(touchEndScroll.y)
            if scrollY <= 100 {
                if scrollX > 0 && disableScrollLeft == false {
                    if scrollX > 5{
                        if notes.last?.position.x <= spaceFromStart{
                            disableScrollLeft = true
                        }
                        Left()
                    }
                }
                if scrollX < 0 && disableScrollRight == false  {
                    if abs(scrollX) > 10 {
                        
                        if notes[0].position.x >= spaceFromStart {
                            //Primeira nota volta para posicao inicial
                            disableScrollRight = true
                        }
                        Right()
                    }
                }
            }
        }
      }
    }
    
    private func Left(){
        println("Left")
        if disableScrollLeft == false {
            scrollHasBeenActivaed = true
            if notes.count != 0 {
                clave.position.x = CGFloat(Int(clave.position.x) - abs(scrollX)/30)
                for var v = 0; v < notes.count; v++ {
                    notes[v].position.x = CGFloat((Int(notes[v].position.x) - abs(scrollX)/30))
                }
            }
        }
    }
    
    private func Right(){
        println("Right")
        if disableScrollRight == false {
            scrollHasBeenActivaed = true
            if notes.count != 0 {
                clave.position.x = CGFloat(Int(clave.position.x) + abs(scrollX)/30)
                for var v = 0; v < notes.count; v++ {
                    notes[v].position.x = CGFloat((Int(notes[v].position.x) + abs(scrollX)/30))
                }
            }
        }
    }
    
    
    
    private func Move(){
        println("Move")
        if notes.count != 0 {
            clave.position.x = CGFloat(Int(clave.position.x) - 170)
            for var v = 0; v < notes.count; v++ {
                notes[v].position.x = CGFloat((Int(notes[v].position.x) - 170))
            }
        }
    }
    
    var n0: CGFloat!
    
    private func MoveScreen(){
        if notes.count >= 5 {
            println("MoveScreen")
            for var p = 0; p < notes.count; p++ {
                if notes[p].position.x >= (spaceFromStart - 10) && notes[p].position.x <= (spaceFromStart+10){
                n0 = notes[p].position.x
                break
                }
                
                else if notes[p].position.x >= (spaceFromStart - 83) && notes[p].position.x <= (spaceFromStart+83){
                    n0 = notes[p].position.x
                }
            }
       
            var nf = notes.last!.position.x
            var resp = Int(notes[0].position.x) - Int(notes.last!.position.x)
            clave.position.x = CGFloat(Int(clave.position.x) + Int(n0 - nf))
            
            for var v = 0; v < notes.count; v++ {
                if v == 0 {
                 notes[v].position.x = CGFloat(Int(notes[v+1].position.x) - 83)
                }
                notes[v].position.x = CGFloat(Int(notes[v].position.x) + Int(n0 - nf))
            }
            scrollHasBeenActivaed = false
        }
    }
    
    var ns0:CGFloat!
    var nsf:CGFloat!
    
    private func MoveStart(){
        println("MoveStart")
        
        if notes.count >= 2 {
            for var p = 0; p < notes.count; p++ {
                println("n[ \(p)]= \(notes[p].position.x)")
                println("SpacoCompara = \(spaceFromStart)")
                if notes[p].position.x >= (spaceFromStart - 10) && notes[p].position.x <= (spaceFromStart+10){
                    nsf = notes[p].position.x
                    break
                }
                
                else if notes[p].position.x >= (spaceFromStart - 83) && notes[p].position.x <= (spaceFromStart+83){
                    nsf = notes[p].position.x
                }
            }
            ns0 = notes[0].position.x
            clave.position.x = CGFloat(Int(clave.position.x) + abs(Int(ns0 - nsf)))
            for var v = 0; v < notes.count; v++ {
                
                if v == 0 {
                    notes[v].position.x = CGFloat(Int(notes[v+1].position.x) - 83)
                }
                notes[v].position.x = CGFloat(Int(notes[v].position.x) + abs(Int(ns0 - nsf)))
            }
            scrollHasBeenActivaed = true
        }
    }
    
    private func MoveMusic(){
        println("MoveMusic")
        clave.position.x = CGFloat(Int(clave.position.x) - 5 * 15)
        for var v = 0; v < notes.count; v++ {
            notes[v].position.x = CGFloat(Int(notes[v].position.x) - 5 * 15)
        }

        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("Moved")
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        touchNote = true
        touchEndScroll = location
        
        scroll()
        
        if touchedNode.name == "Note" + String(cont) {
            touchedNode.position = location
            dropNote = true
            touchedNode.zPosition = 15
        }
    }
    
    // MARK: Pinning Notes
    
    private func pinNoteToElementPosition(touchedNode: Note, y: CGFloat) {
        touchedNode.zPosition = 1.0
        var YCoordinate = y
        //touchedNode.position.y = YCoordinate
        var XCoordinate: CGFloat!
        if let lastNode = notes.last {
            // Add a space from the last added note's X coordinate.
            //touchedNode.position.x = (lastNode.position.x + spaceBetweenNotes)
            XCoordinate = (lastNode.position.x + spaceBetweenNotes)
        } else {
            //touchedNode.position.x = spaceFromStart
            XCoordinate = spaceFromStart
        }
        lastPositionNote = XCoordinate
        moveToAnimation(touchedNode, position: CGPoint(x: XCoordinate, y: YCoordinate))
        
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
                
                pinNoteToElementPosition(touchedNode, y: elemYCoordinate)
                notes.append(touchedNode)
                touchedNode.physicsBody?.dynamic = true
                callSetNote(index, note: touchedNode)
                return true
            }
        }
        
        return false
    }
    
    private func returnToOriginPosition(node: SKNode) {
        node.removeFromParent()
    }
    
    
    var automaticScroll = false
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchItem = touches.first as! UITouch
        let touchLocation = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(touchLocation)
        touchNote = false
        touchScroll = 0
        println("End")

        if (touchedNode.name == nil || touchedNode.name == "semibreve" || touchedNode.name == "minima" || touchedNode.name == "seminima" || touchedNode.name == "colcheia") && (dropNote == true) {
            returnToOriginPosition(note)
        }
        
        if touchedNode.name == "Note" + String(cont) {
            var t = self.view?.bounds.size
            dropNote = false
            cont++
            zPosition = 0
            scaleDown(touchedNode)
            var touchedNote = touchedNode as! Note
            if !isNodeAboveElement(touchedNote) {
                returnToOriginPosition(touchedNote)
            }
        }
        
        
    }
    
    private func callSetNote(tone: Int, note: Note) {
        switch(tone) {
        case 0:
            note.setNote("do1",noteSelect: note)
        case 1:
            note.setNote("re1",noteSelect: note)
        case 2:
            note.setNote("mi1",noteSelect: note)
        case 3:
            note.setNote("fa1",noteSelect: note)
        case 4:
            note.setNote("sol1",noteSelect: note)
        case 5:
            note.setNote("la1",noteSelect: note)
        case 6:
            note.setNote("si1",noteSelect: note)
        case 7:
            note.setNote("do2",noteSelect: note)
        case 8:
            note.setNote("re2",noteSelect: note)
        case 9:
            note.setNote("mi2",noteSelect: note)
        case 10:
            note.setNote("fa2",noteSelect: note)
        case 11:
            note.setNote("sol2",noteSelect: note)
        case 12:
            note.setNote("la2",noteSelect: note)
        default:
            note.setNote("do1",noteSelect: note)
        }
    }
    
    // MARK: - Animations
    private func happiness(pos: CGPoint) {
        var emitterNode = SKEmitterNode(fileNamed: "Particle.sks")
        emitterNode.particlePosition = pos
        self.addChild(emitterNode)
        emitterNode.zPosition = 0
        
        return self.runAction(SKAction.waitForDuration(1),completion: {
            self.runAction(SKAction.waitForDuration(1), completion: {
                emitterNode.particleAlpha = 0
                emitterNode.removeFromParent()
            })
        })
    }
    
    private func scaleUp(node: SKNode){
        let liftUp = SKAction.scaleTo(0.7, duration: 0.2)
        node.runAction(liftUp, withKey: "pickup")
        let liftDown = SKAction.scaleTo(0.5, duration: 0.2)
        node.runAction(liftUp, withKey: "pickdown")
        let arrayAnimation: [SKAction] = [
            liftUp,
            liftDown
        ]
        
        node.runAction(SKAction.sequence(arrayAnimation))
        
    }
    
    private func playNoteAnimation(node: SKNode){
        let liftUp = SKAction.scaleTo(0.7, duration: 0.2)
        node.runAction(liftUp, withKey: "pickup")
        let liftDown = SKAction.scaleTo(0.4, duration: 0.2)
        node.runAction(liftUp, withKey: "pickdown")
        
        let arrayAnimation: [SKAction] = [
            liftUp,
            liftDown
        ]
        
        node.runAction(SKAction.sequence(arrayAnimation))
    }
    
    private func scaleDown(node: SKNode){
        let dropDown = SKAction.scaleTo(0.4, duration: 0.2)
        node.runAction(dropDown, withKey: "drop")
    }
    
    private func moveToAnimation(node: SKNode, position: CGPoint){
        let animation = SKAction.moveTo(position, duration: 0.3)
        node.runAction(animation, withKey: "move")
        
        node.runAction(SKAction.waitForDuration(0.3), completion: {
            self.happiness(node.position)
        })
        
    }
    
    private func removeNoteAction(note: Note) {
        note.zPosition = 200
        let animation = SKAction.moveToY(-70, duration: 0.5)
        playNote(removeSound)
        note.runAction(animation, withKey: "remove")
        
        note.runAction(SKAction.waitForDuration(2), completion: {
            note.removeFromParent()
        })
        
    }
    
    
}
