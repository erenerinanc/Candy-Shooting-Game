//
//  GameScene.swift
//  CandyShooting
//
//  Created by Eren Erinanc on 25.02.2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var background: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var candyTimer: Timer!
    var gameTimer: Timer!
    
    var timerLabel: SKLabelNode!
    var counter = 60 {
        didSet {
            timerLabel.text = "Time: \(counter)"
        }
    }
    
    var isGameOver = false
    var gameOverLabel: SKLabelNode!
    
    var truffels = ["truffel", "truffelwhite"]
    var candies = ["candy", "candyred"]
    
    var bulletCountLabel: SKLabelNode!
    var bulletCount = 6 {
        didSet {
            bulletCountLabel.text = "Ammo left: \(bulletCount)"
        }
    }
    var bulletFinished = false
    
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "candyshop")
        background.name = "background"
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        startGame()
        
    }
    
    func startGame() {
        scoreLabel?.removeFromParent()
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 800, y: 700)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        timerLabel?.removeFromParent()
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x: 440,y: 700)
        timerLabel.horizontalAlignmentMode = .left
        addChild(timerLabel)
        counter = 60
        
        bulletCountLabel?.removeFromParent()
        bulletCountLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletCountLabel.position = CGPoint(x: 40,y: 700)
        bulletCountLabel.name = "bulletCount"
        bulletCountLabel.horizontalAlignmentMode = .left
        bulletCountLabel.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2.0, height: 10.0))
        addChild(bulletCountLabel)
        bulletCount = 6
        
        startTimers()
        
    }
    
    func startTimers() {
        candyTimer?.invalidate()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        candyTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(treatCreator), userInfo: nil, repeats: true)
    }
    
    @objc func countDown() {
        guard !isGameOver else { return }
        counter -= 1
        
        if counter == 0 {
            isGameOver = true
            gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.text = "Game Over"
            gameOverLabel.fontSize = 100
            gameOverLabel.position = CGPoint(x: 512, y: 384)
            addChild(gameOverLabel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let ac = UIAlertController(title: "Do you want to start a new game?", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
                    self?.isGameOver = false
                    self?.bulletFinished = false
                    self?.startGame()
                })
                ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
                self.view?.window?.rootViewController?.present(ac, animated: true)
            }
        }
    }
    
    @objc func treatCreator() {
        guard !isGameOver else { return }
        guard let truffel = truffels.randomElement() else { return }
        guard let candy = candies.randomElement() else { return }
        
        let truffelSprite = SKSpriteNode(imageNamed: truffel)
        if truffel == "truffel"{
            truffelSprite.name = "truffel"
        } else if truffel == "truffelwhite" {
            truffelSprite.name = "truffelwhite"
        }
        
        truffelSprite.position = CGPoint(x: 1200, y: 580)
        addChild(truffelSprite)
        
        truffelSprite.physicsBody = SKPhysicsBody(circleOfRadius: truffelSprite.size.width/2)
        truffelSprite.physicsBody?.categoryBitMask = 1
        truffelSprite.physicsBody?.velocity = CGVector(dx: Int.random(in: -800 ... -300), dy: 0)
        truffelSprite.physicsBody?.angularVelocity = 8
        truffelSprite.physicsBody?.angularDamping = 0
        truffelSprite.physicsBody?.linearDamping = 0
        
        let candySprite = SKSpriteNode(imageNamed: candy)
        if candy == "candy" {
            candySprite.setScale(3)
            candySprite.name = "candy"
        } else if candy == "candyred" {
            candySprite.setScale(0.1)
            candySprite.name = "candyred"
        }
        candySprite.position = CGPoint(x: 10, y: 350)
        addChild(candySprite)
        
        candySprite.physicsBody = SKPhysicsBody(circleOfRadius: candySprite.size.width/2)
        candySprite.physicsBody?.categoryBitMask = 1
        candySprite.physicsBody?.velocity = CGVector(dx: 700, dy: 0)
        candySprite.physicsBody?.angularVelocity = 3
        candySprite.physicsBody?.angularDamping = 0
        candySprite.physicsBody?.linearDamping = 0
        
        let cupcakeSprite = SKSpriteNode(imageNamed: "cupcake")
        cupcakeSprite.name = "cupcake"
        cupcakeSprite.setScale(0.2)
        cupcakeSprite.position = CGPoint(x: 1200, y: 120)
        addChild(cupcakeSprite)
        
        cupcakeSprite.physicsBody = SKPhysicsBody(circleOfRadius: cupcakeSprite.size.width/2)
        cupcakeSprite.physicsBody?.categoryBitMask = 1
        cupcakeSprite.physicsBody?.categoryBitMask = 1
        cupcakeSprite.physicsBody?.velocity = CGVector(dx: Int.random(in: -500 ... -200), dy: 0)
        cupcakeSprite.physicsBody?.angularVelocity = 5
        cupcakeSprite.physicsBody?.angularDamping = 0
        cupcakeSprite.physicsBody?.linearDamping = 0
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            gameOverLabel?.removeFromParent()
        }
        
        if bulletCount <= 0 {
            bulletFinished = true
            bulletCountLabel.text = "Tap to reload"
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        guard bulletFinished == false else {
            if bulletCountLabel.contains(location) {
                bulletFinished = false
                bulletCount = 6
                bulletCountLabel.text = "Ammo left: \(bulletCount)"
                }
            return
        }
        
        for node in tappedNodes {
            if node.name == "cupcake" {
                node.removeFromParent()
                score += 5
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                bulletCount -= 1
                return
            } else if node.name == "candy" {
                node.removeFromParent()
                score += 100
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                bulletCount -= 1
                return
            } else if node.name == "candyred" {
                node.removeFromParent()
                score -= 50
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                bulletCount -= 1
                return
            } else if node.name == "truffel" {
                node.removeFromParent()
                score += 10
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                bulletCount -= 1
                return
            } else if node.name == "truffelwhite" {
                node.removeFromParent()
                score += 20
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                bulletCount -= 1
                return
            } else {
                bulletCount -= 1
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                return
                }
            }
    
        }
        
    }


