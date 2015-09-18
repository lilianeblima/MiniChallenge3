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
    
    private func drawShape(YCoordinate YCoordinate: CGFloat, shape: StaveElements, color: UIColor) -> SKShapeNode {
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
        print("didMoveToView")
    }
    
    private func addNotes(noteDurations: SKNode){
        note = Note(duracao: noteDurations.name!)
        note.position = CGPointMake(noteDurations.position.x, 100)
        note.name = "Note" + String(cont)
        note.zPosition = 15
        touchNote = true
        touchScroll = 0
        if noteDurations.name! == "minima" {
            note.anchorPoint.y = 0.36
        }
        
        if noteDurations.name! == "seminima" || noteDurations.name! == "colcheia"{
            note.anchorPoint.y = 0.32
        }
        if notes.count < 100 && touchNote == true
        {
            addChild(note)
            scaleUp(note)
        }
        
        print("addNotes")
        
    }
    let clave = SKSpriteNode(imageNamed: "clave")
    
    private func addClave() {
        clave.size = CGSize(width: 250, height: 500)
        clave.position = CGPointMake(100, 380)
        clave.name = "clave"
        
        addChild(clave)
        print("addClave")
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
        print("addFirstNotes")
        
    }
    
    private func addMusicButton() {
        musicButton = SKSpriteNode(texture: SKTexture(imageNamed: "play"), size: CGSize(width: 100, height: 100))
        musicButton.name = "playButton"
        musicButton.position = CGPointMake(700, 100)
        musicButton.zPosition = 1
        
        addChild(musicButton)
        print("addMusicButton")
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
        let cloud1 = SKSpriteNode(imageNamed: "nuvemVoltar")
        cloud1.name = "cloudVoltar"
        cloud1.position = CGPointMake(150, 675)
        cloud1.zPosition = 1
        cloud1.setScale(0.4)
        
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
        clave.removeFromParent()
        if notes.count > 0 {
            for var index = 0; index < notes.count; index++ {
                notes[index].removeFromParent()
            }
            notes.removeAll(keepCapacity: false)
            lastNotePositionOutScreen = false
            scrollHasBeenActivaed = false
        }
        
        addClave()
        print("cleanButtonAction")
    }
    
    private func undoButtonAction() {
        if notes.count > 0 && musicPlay == false{
            removeNoteAction(notes.last!)
            notes.removeLast()
            lastNotePositionOutScreen = false
            MoveUndo()
        }
        print("undoButtonAction")
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
                self.musicPlay = false
            }
        })
        
        print("playMusic")
    }
    
    func playSound(s:SKAction){
        runAction(s)
        print("palySound")
    }
    
    var contaa = 0
    
    
    // MARK: - Touch Events
    var y = 0
    
    private func loadIntroduction() {
        // let scene = IntroductionScene.unarchiveFromFile("IntroductionScene") as? GameScene
            let introScene = IntroductionScene(size: view!.bounds.size)
            introScene.scaleMode = .AspectFill
            
            let spriteView = self.view
            spriteView!.ignoresSiblingOrder = true
            spriteView!.presentScene(introScene)
            
            player.stop()
            //GameScene.unarchiveFromFile("GameScene") as? GameScene {
        
            

            //view!.presentScene(scene)
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let t = touches.first
//        let touchItem = t as? UITouch
        let location = t!.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        touchInitScroll = location
        contaa++
        // firstSemibreve.userInteractionEnabled = false
        scrollIndicator.position = CGPointMake(1024/2-20, 100)
        
        if touchedNode.name == "cloudVoltar" {
           // self.view?.presentScene(<#T##scene: SKScene##SKScene#>, transition: <#T##SKTransition#>)
            self.loadIntroduction()
        }
            
        
        
        if touchNote == false && contaa == 1{
            if musicPlay == false {
                touchScroll = 1
            }
            
            disableScrollRight = false
            disableScrollLeft = false
            
            if touchedNode.name == "semibreve" || touchedNode.name == "minima" || touchedNode.name == "seminima" || touchedNode.name == "colcheia"  {
                touchedNode.zPosition = 0
                
                if scrollHasBeenActivaed == true {
                    scrollHasBeenActivaed = false
                    MoveScreen()
                }
                
                if lastPositionNote < 900 {
                    lastNotePositionOutScreen = false
                }
                if lastPositionNote >= 900 || lastNotePositionOutScreen == true{
                    lastNotePositionOutScreen = true
                    //Se houver mais notas do que mostrar na tela
                    lastPositionNote = notes.last!.position.x + 170
                    y = 1
                    Move()
                }
                
                let seconds = 0.1
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

                if musicPlay == false{
                    addNotes(touchedNode)
                }
                
                
                
                
                
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
        
        print("touchesBegan")
    }
    
    private func scroll() {
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
        
        print("scroll")
    }
    
    private func Left(){
        if disableScrollLeft == false {
            scrollHasBeenActivaed = true
            if notes.count != 0 {
                clave.position.x = CGFloat(Int(clave.position.x) - abs(scrollX)/30)
                for var v = 0; v < notes.count; v++ {
                    notes[v].position.x = CGFloat((Int(notes[v].position.x) - abs(scrollX)/30))
                }
            }
        }
        
        print("Left")
    }
    
    private func Right(){
        if disableScrollRight == false {
            scrollHasBeenActivaed = true
            if notes.count != 0 {
                clave.position.x = CGFloat(Int(clave.position.x) + abs(scrollX)/30)
                for var v = 0; v < notes.count; v++ {
                    notes[v].position.x = CGFloat((Int(notes[v].position.x) + abs(scrollX)/30))
                }
            }
        }
        
        print("Right")
    }
    
    
    
    private func Move(){
        if notes.count != 0 {
            q = 1
            clave.position.x = CGFloat(Int(clave.position.x) - 170)
            for var v = 0; v < notes.count; v++ {
                notes[v].position.x = CGFloat((Int(notes[v].position.x) - 170))
                q = 2
                //println("notes.count= \(notes.count)")
                lastPositionNote = notes.last!.position.x - CGFloat(170)
                
            }
            lastPositionNote = notes.last?.position.x
            
        }
        
        print("Move")
    }
    
    var n0: CGFloat!
    var q = 2
    var teste = 0
    
    private func MoveScreen(){
        if notes.count >= 5 {
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
                teste = 2
            }
            scrollHasBeenActivaed = false
            teste = 0
            
        }
        print("MoveScreen")
    }
    
    var ns0:CGFloat!
    var nsf:CGFloat!
    
    private func MoveStart(){
        if notes.count >= 2 {
            for var p = 0; p < notes.count; p++ {
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
        
        print("MoveStart")
    }
    
    private func MoveMusic(){
        clave.position.x = CGFloat(Int(clave.position.x) - 6 * 15)
        for var v = 0; v < notes.count; v++ {
            notes[v].position.x = CGFloat(Int(notes[v].position.x) - 6 * 15)
        }
        print("MoveMusic")
    }
    
    var nt:CGFloat!
    var espacoInicialClave:CFloat!
    
    private func MoveUndo(){
        print("Notes = \(notes.count)")
        print("spaceFromStart = \(spaceFromStart)")
        print("notes.last?.position.x = \(notes.last?.position.x)")
        if notes.count != 0  && notes.last?.position.x <= spaceFromStart{
            print("Entrei")
            for var p = 0; p < notes.count; p++ {
                if notes[p].position.x >= (spaceFromStart - 10) && notes[p].position.x <= (spaceFromStart+10){
                    nt = notes[p].position.x
                    break
                }
                    
                else if notes[p].position.x >= (spaceFromStart - 83) && notes[p].position.x <= (spaceFromStart+83){
                    nt = notes[p].position.x
                }
            }
            ns0 = 900
            
            if notes.count > 2 {
                clave.position.x = CGFloat(Int(clave.position.x) + abs(Int(ns0 - nt)/4))
                
                for var v = 0; v < notes.count; v++ {
                    
                    if v == 0 {
                        notes[v].position.x = CGFloat(Int(notes[v+1].position.x) - 83)
                    }
                    notes[v].position.x = CGFloat(Int(notes[v].position.x) + abs(Int(ns0 - nt)/4))
                }
            }
                
            else {
                clave.position = CGPointMake(100, 380)
                for var v = 0; v < notes.count; v++ {
                    if v == 0 {
                        notes[v].position.x = spaceFromStart
                    }
                    else {
                        notes[v].position.x = spaceFromStart + 83
                    }
                    
                }
            }
            
        }
        
        print("MoveUndo")
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let t = touches.first
        let touchItem = t! as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        touchEndScroll = location
        
        scroll()
        
        if touchedNode.name == "Note" + String(cont) {
            touchNote = true
            touchedNode.position = location
            dropNote = true
            touchedNode.zPosition = 15
        }
        
        print("touchesMoved")
    }
    
    // MARK: Pinning Notes
    var b = 0
    private func pinNoteToElementPosition(touchedNode: Note, y: CGFloat) {
        touchedNode.zPosition = 1.0
        var YCoordinate = y
        //touchedNode.position.y = YCoordinate
        var XCoordinate: CGFloat!
        print("a0")
        if let lastNode = notes.last {
            print("a1")
            // Add a space from the last added note's X coordinate.
            //touchedNode.position.x = (lastNode.position.x + spaceBetweenNotes)
            XCoordinate = (lastNode.position.x + spaceBetweenNotes)
            //println("XCoordinate= \(XCoordinate)")
        } else {
            print("a2")
            //touchedNode.position.x = spaceFromStart
            XCoordinate = spaceFromStart
            //  println("XCoordinate= \(XCoordinate)")
        }
        lastPositionNote = XCoordinate
        // println("lastPosition = \(last)")
        
        if lastPositionNote > 850 {
            b = 1
            self.y = 1
        }
        
//        if teste != 2 {
//            moveToAnimation(touchedNode, position: CGPoint(x: XCoordinate, y: YCoordinate))
//        }
        
        
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        if teste == 2 {
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                
                self.moveToAnimation(touchedNode, position: CGPoint(x: XCoordinate, y: YCoordinate))
                //y = 0
            })
        }
            
        else {
            moveToAnimation(touchedNode, position: CGPoint(x: XCoordinate, y: YCoordinate))
        }
        
        print("pinNoteToElementPosition")
    }
    
    private func isNodeAboveElement(touchedNode: Note) -> Bool {
        touchNote = false
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
         print("isNodeAboveElement")
        return false
       
    }
    
    private func returnToOriginPosition(node: SKNode) {
        node.removeFromParent()
        print("returnToOriginPosition")
    }
    
    
    var automaticScroll = false
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let t = touches.first
        let location = t!.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        contaa = 0
        touchScroll = 0
        
        
        if (touchedNode.name == nil || touchedNode.name == "semibreve" || touchedNode.name == "minima" || touchedNode.name == "seminima" || touchedNode.name == "colcheia") && (dropNote == true) {
            touchNote = false
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
                touchNote = false
                returnToOriginPosition(touchedNote)
            }
        }
        
        print("touchesEnded")
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
        
        print("callSetNote")
    }
    
    // MARK: - Animations
    private func happiness(pos: CGPoint) {
        var emitterNode = SKEmitterNode(fileNamed: "Particle.sks")
        emitterNode!.particlePosition = pos
        self.addChild(emitterNode!)
        emitterNode!.zPosition = 0
         print("happiness")
        return self.runAction(SKAction.waitForDuration(1),completion: {
            self.runAction(SKAction.waitForDuration(1), completion: {
                emitterNode!.particleAlpha = 0
                emitterNode!.removeFromParent()
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
       print("scaleUp")
        
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
        print("playNoteAnimation")
        
    }
    
    private func scaleDown(node: SKNode){
        let originalScale = SKAction.scaleTo(1, duration: 0.2)
        let dropDown = SKAction.scaleTo(0.4, duration: 0.2)
        node.runAction(dropDown, withKey: "drop")
        let arrayAnimation: [SKAction] = [
            originalScale,
            dropDown
        ]
        
        node.runAction(SKAction.sequence(arrayAnimation))
        print("scaleDown")
    }
    
    var terminouAnimacao = false
    private func moveToAnimation(node: SKNode, position: CGPoint){
        
        let animation = SKAction.moveTo(position, duration: 0.1)
        node.runAction(animation, withKey: "move")
        SKAction.runAction(animation, onChildWithName: "Move")
        
        node.runAction(SKAction.waitForDuration(0.3), completion: {
            
            self.happiness(node.position)
        })
        print("moveToAnimation")
    }
    
    private func removeNoteAction(note: Note) {
        note.zPosition = 200
        let animation = SKAction.moveToY(-100, duration: 0.3)
        playNote(removeSound)
        note.runAction(animation, withKey: "remove")
        
        note.runAction(SKAction.waitForDuration(2), completion: {
            note.removeFromParent()
        })
        print("removeNoteAction")
    }
    
    
}
