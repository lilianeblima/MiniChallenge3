//
//  Note.swift
//  Musicables
//
//  Created by Isaías Lima on 20/05/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit
import AVFoundation

var player: AVAudioPlayer!

func playNote(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if url == nil {
        println("Could not find file: \(filename)")
        return
    }
    
    var error: NSError? = nil
    player = AVAudioPlayer(contentsOfURL: url, error: &error)
    if player == nil {
        println("Could not create audio player: \(error)")
        return
    }
    
    player.numberOfLoops = 1
    player.prepareToPlay()
    player.play()
}

let path = NSBundle.mainBundle().pathForResource("notes", ofType: "json")
let json = NSData(contentsOfFile: path!)
let noteDictionary = NSJSONSerialization.JSONObjectWithData(json!, options: .MutableContainers, error: nil) as! NSDictionary

class Note: SKSpriteNode {
    
    var tone: String!
    var duration: String!
    var nota: String!
    
    convenience init(duracao: String) {
        
        self.init(texture: SKTexture(imageNamed: "semibreve"), color: nil, size: CGSizeMake(490, 174))
        self.tone = String()
        self.duration = duracao
        
    }
    
    func setNote(tone: String) {
        
        let notes = noteDictionary.valueForKey(duration) as! NSDictionary
        nota = notes.valueForKey(tone) as! String
        play()
        
    }
    
    func play() {
        playNote(nota)
    }
    
    


   
}
