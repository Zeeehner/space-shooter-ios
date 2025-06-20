//
//  GameScene.swift
//  SpaceGame
//
//  Created by Noah Ra on 12.10.24.
//
import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let spaceshipTexture = SKTexture(imageNamed: "spaceshooter")
    var spaceship = SKSpriteNode()
    let backgroundScene1 = SKSpriteNode(imageNamed: "background")
    let backgroundScene2 = SKSpriteNode(imageNamed: "background")
    let enemyShip = SKSpriteNode(imageNamed: "")
    
    
    //    var audioPlayer = AVAudioPlayer()
    //    var backgoundAudio: URL?
    
    let soundON = SKShapeNode(circleOfRadius: 20)
    let soundOFF = SKShapeNode(circleOfRadius: 20)
    
    
    var timerEnemy = Timer()
    
    struct physicsBodyNumbers {
   //===================================================//
        static let spaceshipNumber: UInt32 = 0b1 // 1   //
        static let bulletNumber: UInt32 = 0b10 // 2     //
        static let enemyNumber: UInt32 = 0b100 // 4     //
        static let emptyNumber: UInt32 = 0b1000 // 8    //
  //====================================================//
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate =  self
        
        spaceship = SKSpriteNode(texture: spaceshipTexture)
        spaceship.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 200)
        spaceship.setScale(0.2)
        spaceship.zPosition = 1
        
        spaceship.physicsBody = SKPhysicsBody(texture: spaceshipTexture, size: spaceship.size)  // body
        spaceship.physicsBody?.affectedByGravity = false
        spaceship.physicsBody?.categoryBitMask = physicsBodyNumbers.spaceshipNumber
        spaceship.physicsBody?.collisionBitMask = physicsBodyNumbers.emptyNumber
        spaceship.physicsBody?.contactTestBitMask = physicsBodyNumbers.enemyNumber
        
        self.addChild(spaceship)
        
        self.backgroundColor = SKColor(_colorLiteralRed: 0, green: 104 / 255, blue: 139 / 255, alpha: 1.0)
        
        backgroundScene1.anchorPoint = CGPoint.zero // position x 0 /  y 0
        backgroundScene1.position = CGPoint.zero
        backgroundScene1.size = self.size
        backgroundScene1.zPosition = -1
        self.addChild(backgroundScene1)
        
        backgroundScene2.anchorPoint = CGPoint.zero
        backgroundScene2.position.x = 0
        backgroundScene2.position.y = backgroundScene1.size.height - 5
        backgroundScene2.size = self.size
        backgroundScene2.zPosition = -1
        self.addChild(backgroundScene2)
        timerEnemy = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameScene.addEnemy), userInfo: nil, repeats: true)
    }
    
    func getContactBulletVSEnemy(bullet: SKSpriteNode, enemy: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "enemyFire.sks")
        explosion?.position = enemy.position
        explosion?.zPosition = 2
        self.addChild(explosion!)
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion?.removeFromParent()
        }
        
        bullet.removeFromParent()
        enemy.removeFromParent()
    }
    
    var contactBegin: Bool = true
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case physicsBodyNumbers.bulletNumber | physicsBodyNumbers.enemyNumber:
            
            if contactBegin {
                getContactBulletVSEnemy(bullet: contact.bodyA.node as! SKSpriteNode, enemy: contact.bodyB.node as! SKSpriteNode)
                contactBegin = false
            }
            
        case physicsBodyNumbers.spaceshipNumber | physicsBodyNumbers.enemyNumber:
            print("Kontakt")
            
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "bullet" || contact.bodyB.node?.name == "bullet" {
            contactBegin = true
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let locationUser = touch.location(in: self)
            spaceship.position.x = locationUser.x
            spaceship.position.y = locationUser.y
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locationUser = touch.location(in: self)
            if atPoint(locationUser) == spaceship {
                addBulletToSpaceShip()

                        }
                    }
        }
    
    func addBulletToSpaceShip() {
        let bulletTexture = SKTexture(imageNamed: "bullet")
        let bullet = SKSpriteNode(texture: bulletTexture)
        bullet.position = spaceship.position
        bullet.zPosition = 0
        bullet.setScale(0.2)
        bullet.name = "bullet"
        
        bullet.physicsBody = SKPhysicsBody(texture: bulletTexture, size: bullet.size)
        bullet.physicsBody?.isDynamic = false
        bullet.physicsBody?.categoryBitMask = physicsBodyNumbers.bulletNumber
        bullet.physicsBody?.contactTestBitMask = physicsBodyNumbers.enemyNumber
        
        
        self.addChild(bullet)
        
        let moveTo = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 3)
        let delete = SKAction.removeFromParent()
        
        bullet.run(SKAction.sequence([moveTo, delete]))
    }
    
    @objc func addEnemy() {
        
        var enemyArray = [SKTexture]()
        
        for index in 1...8 {
            enemyArray.append(SKTexture(imageNamed: "\(index)"))
        }
        let enemyTexture = SKTexture(imageNamed: "spaceship_enemy_start")
        let enemy = SKSpriteNode(texture: enemyTexture)
        
        enemy.physicsBody = SKPhysicsBody(texture: enemyTexture, size: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = physicsBodyNumbers.enemyNumber
        enemy.physicsBody?.collisionBitMask = physicsBodyNumbers.emptyNumber
        enemy.physicsBody?.contactTestBitMask = physicsBodyNumbers.spaceshipNumber
        
        enemy.setScale(0.2)
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.size.width))) + 20, y: self.size.height + enemy.size.height)
        enemy.zRotation = CGFloat(((Double.pi / 180) * 180))
        self.addChild(enemy)
        
        enemy.run(SKAction.repeatForever(SKAction.animate(with: enemyArray, timePerFrame: 0.1)))
        
        let moveDown = SKAction.moveTo(y: -enemy.size.height, duration: 3)
        let delete = SKAction.removeFromParent()
        
        enemy.run(SKAction.sequence([moveDown, delete]))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        backgroundScene1.position.y -= 5
        backgroundScene2.position.y -= 5
        
        if backgroundScene1.position.y < -backgroundScene1.size.height {
            backgroundScene1.position.y = backgroundScene2.position.y + backgroundScene2.size.height
        }
        
        if backgroundScene2.position.y < -backgroundScene2.size.height {
            backgroundScene2.position.y = backgroundScene1.position.y + backgroundScene1.size.height
        }
    }
}
