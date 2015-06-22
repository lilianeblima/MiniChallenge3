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
var playArray = Array<AVAudioPlayer>()
var audioPlayerSequence = AVAudioPlayer()

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
    
    player.numberOfLoops = 0
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
        
        self.init(imageNamed: duracao)
        self.setScale(0.4)
        self.tone = String()
        self.duration = duracao
        
    }
    
    func setNote(tone: String) {
        
        let notes = noteDictionary.valueForKey(duration) as! NSDictionary
        nota = notes.valueForKey(tone) as! String
        println(nota)
        
        if (tone == "do1" || tone == "la2") && note.duration == "semibreve" {
            note.texture = SKTexture(imageNamed: "semibreve_riscado")
        }
        
        else if (tone == "si1" || tone == "do2" || tone == "re2" || tone == "mi2" || tone == "fa2" || tone == "sol2" || tone == "la2") && note.duration == "minima" {
            if tone == "la2" {
                note.texture = SKTexture(imageNamed: "minima_invertida_riscado")
            }
            else {
                note.texture = SKTexture(imageNamed: "minima_invertida")
            }
        }
        
        else if (tone == "si1" || tone == "do2" || tone == "re2" || tone == "mi2" || tone == "fa2" || tone == "sol2" || tone == "la2") && note.duration == "seminima" {
            if tone == "la2" {
                note.texture = SKTexture(imageNamed: "seminima_invertida_riscado")
            }
            else {
                note.texture = SKTexture(imageNamed: "seminima_invertida")
            }
        }
        
        else if (tone == "si1" || tone == "do2" || tone == "re2" || tone == "mi2" || tone == "fa2" || tone == "sol2" || tone == "la2") && note.duration == "colcheia" {
            if tone == "la2" {
                note.texture = SKTexture(imageNamed: "colcheia_invertida_riscado")
            }
            else {
                note.texture = SKTexture(imageNamed: "colcheia_invertida")
            }
        }
        
        else if (tone == "do1") && note.duration == "minima" {
            note.texture = SKTexture(imageNamed: "minima_riscado")
        }
        
        else if (tone == "do1") && note.duration == "seminima" {
            note.texture = SKTexture(imageNamed: "seminima_riscado")
        }
            
        else if (tone == "do1") && note.duration == "colcheia" {
            note.texture = SKTexture(imageNamed: "colcheia_riscado")
        }
        
        
        
        play()
        
    }
    
    func getSound()->String {
        return nota
    }
    
    func play() {
        playNote(nota)
    }
    
}