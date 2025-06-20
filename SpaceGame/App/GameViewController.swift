//
//  GameViewController.swift
//  SpaceGame
//
//  Created by Noah Ra on 12.10.24.
//


import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene1 = MainMenueScene(size: self.view.bounds.size)
        let skview = self.view as! SKView

        skview.showsFPS = true
        skview.showsNodeCount = true
        
        skview.showsPhysics = false 
        
        skview.presentScene(scene1)
    }
}

