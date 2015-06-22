//
//  IntroductionScene.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/20/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit
import UIKit


extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}


class IntroductionScene: SKScene {
    
    // MARK: Scene Elements
    
    // Background
    private let backgroundImageName = "background"
    private let backgroundXCoordinate: CGFloat = 512.0
    private let backgroundYCoordinate: CGFloat = 384.0
    let bgColorScene = UIColor(red: 111/255, green: 215/255, blue: 215/255, alpha: 1)
    
    // Background Sound
    private let backgroundSound = "initial_background.mp3"
    
    // Play Button
    private let playImageName = "playButton"
    
    // Saved Songs Button
    private let loadXCoordinate: CGFloat = 0.0
    private let loadYCoordinate: CGFloat = 0.0
    private let loadImageName = "loadSavedButton"
    
    // Settings Button
    private let settXCoordinate: CGFloat = 0.0
    private let settYCoordinate: CGFloat = 0.0
    private let settImageName = "settingsButton"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: backgroundImageName)
        background.position = CGPointMake(backgroundXCoordinate, backgroundYCoordinate)
        addChild(background)
    }
    
    private func addButtons() {
        let playButton = SKSpriteNode(imageNamed: playImageName)
        let loadButton = SKSpriteNode(imageNamed: loadImageName)
        let settButton = SKSpriteNode(imageNamed: settImageName)
        // Play button reuses the background position.
        playButton.position = CGPointMake(backgroundXCoordinate, backgroundYCoordinate)
        loadButton.position = CGPointMake(loadXCoordinate, loadYCoordinate)
        settButton.position = CGPointMake(settXCoordinate, settYCoordinate)
        
        // Set the name reusing the image name.
        playButton.name = playImageName
        loadButton.name = loadImageName
        settButton.name = settImageName
        
        // Add buttons to the scene.
        addChild(playButton)
        addChild(loadButton)
        addChild(settButton)
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = bgColorScene
        let notes = SKSpriteNode(imageNamed: "notes")
        notes.position = CGPointMake(500, 450)
        notes.zPosition = 1
        notes.setScale(0.55)
        addChild(notes)
        
        let play = SKSpriteNode(imageNamed: "jogar")
        play.position = CGPointMake(370, 450)
        play.name = "play"
        play.zPosition = 1
        play.setScale(0.8)
        addChild(play)
        
        let title = SKSpriteNode(imageNamed: "title")
        title.position = CGPointMake(800, 600)
        title.zPosition = 1
        title.setScale(0.7)
        addChild(title)
        
//        let group = SKSpriteNode(imageNamed: "group")
//        group.position = CGPointMake(800, 150)
//        group.zPosition = 1
//        group.setScale(0.3)
//        addChild(group)
        
        
        
        
        //addBackground()
        //addButtons()
        playNote(backgroundSound)
    }
    
    private func loadGameScene() {
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            player.stop()
            view!.presentScene(scene)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let t = touches.first
        let touchItem = t as! UITouch
        let location = touchItem.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        if touchedNode.name != nil{
            if touchedNode.name == "play"{
                loadGameScene()
            }
            //            switch touchedNode.name! {
            //            case playImageName:
            //                loadGameScene()
            //                break
            //            case loadImageName:
            //                // TODO: Present LoadScene
            //                break
            //            case settImageName:
            //                break
            //            default:
            //                println("No node has been touched.")
            //            }
        }
    }
    
    
}
