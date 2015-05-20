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

enum Duration {
    case Semibreve
    case Minima
    case Seminima
    case Colcheia
}

class Note: SKSpriteNode {
    
    var tone: String!
    
    convenience init(duration: Duration) {
        
        self.init(duration: duration)
        self.tone = String()
        
    }


   
}
