//
//  MainMenue.swift
//  SpaceGame
//
//  Created by Noah Ra on 12.10.24.
//

import SpriteKit

class MainMenueScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "play_button")
    
    override func didMove(to view: SKView) {
        playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        playButton.setScale(0.5)
        self.addChild(playButton)
        
        self.backgroundColor = SKColor.black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch in touches {
            
            let locationUser = touch.location(in: self)
            if atPoint(locationUser) == playButton {
                
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 2)
                
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
                
            }
        }
    }
}
