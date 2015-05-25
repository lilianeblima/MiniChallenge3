//
//  Introduction.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/20/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import SpriteKit


class Introduction: SKScene {

    // MARK: Scene Elements

    // Background
    private let backgroundImageName = "background"
    private let backgroundXCoordinate: CGFloat = 512.0
    private let backgroundYCoordinate: CGFloat = 384.0

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

        // Add buttons to the scene.
        addChild(playButton)
        addChild(loadButton)
        addChild(settButton)
    }

    override func didMoveToView(view: SKView) {
        addBackground()
        addButtons()
    }


}
