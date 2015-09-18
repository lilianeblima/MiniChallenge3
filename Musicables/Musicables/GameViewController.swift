//
//  GameViewController.swift
//  Musicables
//
//  Created by Eduardo Quadros on 5/15/15.
//  Copyright (c) 2015 Fantastic 4. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let introScene = IntroductionScene(size: view.bounds.size)
        introScene.scaleMode = .AspectFill

        let spriteView = self.view as! SKView
        spriteView.ignoresSiblingOrder = true
        spriteView.presentScene(introScene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    
    override  func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}
