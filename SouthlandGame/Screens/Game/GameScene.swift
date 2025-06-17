import SpriteKit

class GameScene: SKScene {
    var viewModel: GameViewModel?
    var appViewModel: AppViewModel?

    var bg1: SKSpriteNode!
    var bg2: SKSpriteNode!
    var hero: SKSpriteNode!
    var enemy: SKSpriteNode!
    
    var heroMaxHealth: Int = GameConfiguration.Game.defaultHeroMaxHealth
    var heroHealth: Int = GameConfiguration.Game.defaultHeroHealth {
        didSet { updateHealthBars() }
    }
    
    var enemyMaxHealth: Int = GameConfiguration.Game.baseEnemyMaxHealth
    var enemyHealth: Int = GameConfiguration.Game.baseEnemyHealth {
        didSet { updateHealthBars() }
    }
    
    var startTime: TimeInterval = 0
    
    var heroHealthBar: SKSpriteNode!
    var enemyHealthBar: SKSpriteNode!
    
    var currentEnemyIndex: Int = 0 {
        didSet {
            viewModel?.currentEnemyIndex = currentEnemyIndex
        }
    }
    let totalEnemies: Int = GameConfiguration.Game.totalEnemies
    
    let battleCycleKey = GameConfiguration.AnimationKeys.battleCycle
    
    var isTransitioning = false
    var transitionDistanceRemaining: CGFloat = 0
    var transitionSpeed: CGFloat = 0
    var lastUpdateTime: TimeInterval = 0
    
    var currentEnemyType: String?
    
    var enemiesKilledThisRun: Int = 0 {
        didSet {
            viewModel?.totalEnemiesKilled = enemiesKilledThisRun
        }
    }
    var totalCoinsEarned: Int = 0
    
    var upgradedAutoDamage: Int {
        guard let appViewModel = appViewModel else { return 5 }
        return appViewModel.upgradedAutoDamage
    }
    
    var upgradedClickDamage: Int {
        guard let appViewModel = appViewModel else { return 2 }
        return appViewModel.upgradedClickDamage
    }
    
    var upgradedHeroMaxHealth: Int {
        guard let appViewModel = appViewModel else { return GameConfiguration.Game.defaultHeroMaxHealth }
        return appViewModel.upgradedHeroMaxHealth
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .systemMint
        
        startTime = CACurrentMediaTime()
        
        let bgTexture = SKTexture(imageNamed: GameConfiguration.Images.gameField)
        bg1 = SKSpriteNode(texture: bgTexture)
        bg1.anchorPoint = .zero
        bg1.position = .zero
        bg1.zPosition = -10
        bg1.size = self.size
        addChild(bg1)
        
        bg2 = SKSpriteNode(texture: bgTexture)
        bg2.anchorPoint = .zero
        bg2.position = CGPoint(x: bg1.size.width - 1, y: 0)
        bg2.zPosition = -10
        bg2.size = self.size
        addChild(bg2)
        
        hero = SKSpriteNode(imageNamed: GameConfiguration.Images.hero)
        hero.position = CGPoint(x: size.width * GameConfiguration.Game.heroPositionX, y: size.height/GameConfiguration.Game.heroPositionY)
        hero.size.height = GameConfiguration.UI.heroHeight
        if let texture = hero.texture {
            let aspectRatio = texture.size().width / texture.size().height
            hero.size.width = GameConfiguration.UI.heroHeight * aspectRatio
        }
        addChild(hero)
        
        heroHealth = upgradedHeroMaxHealth
        heroMaxHealth = upgradedHeroMaxHealth
        
        viewModel?.resetStatisticsFlag()
        viewModel?.coinsEarnedThisRun = 0
        
        spawnEnemy()
        startBattleCycle()
    }
    
    func startBattleIdleAnimation() {
        hero.texture = SKTexture(imageNamed: GameConfiguration.Images.hero)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt: TimeInterval = 0
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        }
        lastUpdateTime = currentTime
        
        if isTransitioning {
            let moveAmount = transitionSpeed * CGFloat(dt)
            transitionDistanceRemaining -= moveAmount
            
            bg1.position.x -= moveAmount
            bg2.position.x -= moveAmount
            
            if bg1.position.x + bg1.size.width < 0 {
                bg1.position.x = bg2.position.x + bg2.size.width - 1
            }
            if bg2.position.x + bg2.size.width < 0 {
                bg2.position.x = bg1.position.x + bg1.size.width - 1
            }
            
            if transitionDistanceRemaining <= 0 {
                isTransitioning = false
                startBattleIdleAnimation()
                currentEnemyIndex += 1
                
                if currentEnemyIndex >= totalEnemies {
                    endGame(victory: true)
                    return
                }
                
                spawnEnemy()
                startBattleCycle()
            }
        }
        
        if bg1.position.x + bg1.size.width < 0 {
            bg1.position.x = bg2.position.x + bg2.size.width - 1
        }
        if bg2.position.x + bg2.size.width < 0 {
            bg2.position.x = bg1.position.x + bg1.size.width - 1
        }
    }
    
    func updateHealthBars() {
        let heroRatio = CGFloat(heroHealth) / CGFloat(heroMaxHealth)
        heroHealthBar?.xScale = max(heroRatio, 0)
        
        let enemyRatio = CGFloat(enemyHealth) / CGFloat(enemyMaxHealth)
        enemyHealthBar?.xScale = max(enemyRatio, 0)
        
        viewModel?.heroHealth = heroHealth
        viewModel?.heroMaxHealth = heroMaxHealth
        viewModel?.enemyHealth = enemyHealth
        viewModel?.enemyMaxHealth = enemyMaxHealth
    }
    
    func spawnEnemy() {
        enemy?.removeFromParent()
        enemyHealthBar?.removeFromParent()
        
        let enemyImageName = GameConfiguration.Game.enemyTypes[currentEnemyIndex]
        currentEnemyType = enemyImageName
        
        enemy = SKSpriteNode(imageNamed: enemyImageName)
        enemy.position = CGPoint(x: size.width * GameConfiguration.Game.enemyPositionX, y: size.height / GameConfiguration.Game.enemyPositionY)
        enemy.size.height = GameConfiguration.UI.enemyHeight
        if let texture = enemy.texture {
            let aspectRatio = texture.size().width / texture.size().height
            enemy.size.width = GameConfiguration.UI.enemyHeight * aspectRatio
        }
        addChild(enemy)
        
        enemyMaxHealth = GameConfiguration.Game.getEnemyHealth(for: currentEnemyIndex)
        enemyHealth = enemyMaxHealth
        
        print("Spawned \(enemyImageName) (Enemy \(currentEnemyIndex + 1)) with \(enemyHealth) health")
    }
    
    func startBattleCycle() {
        removeAction(forKey: battleCycleKey)
        let cycle = SKAction.sequence([
            SKAction.wait(forDuration: GameConfiguration.Game.battleCycleDuration),
            SKAction.run { [weak self] in
                self?.performAttackCycle()
            }
        ])
        run(SKAction.repeatForever(cycle), withKey: battleCycleKey)
    }
    
    func performAttackCycle() {
        let heroOriginalPos = hero.position
        let enemyOriginalPos = enemy.position
        
        let heroStep = SKAction.sequence([
            SKAction.moveBy(x: GameConfiguration.Game.attackMoveDistance, y: 0, duration: GameConfiguration.Game.attackAnimationDuration),
            SKAction.move(to: heroOriginalPos, duration: GameConfiguration.Game.attackAnimationDuration)
        ])
        hero.run(heroStep)
        
        let enemyStep = SKAction.sequence([
            SKAction.moveBy(x: -GameConfiguration.Game.attackMoveDistance, y: 0, duration: GameConfiguration.Game.attackAnimationDuration),
            SKAction.move(to: enemyOriginalPos, duration: GameConfiguration.Game.attackAnimationDuration)
        ])
        enemy.run(enemyStep)
        
        let enemyDamage = GameConfiguration.Game.getEnemyDamage(for: currentEnemyIndex)
        
        enemyHealth -= upgradedAutoDamage
        heroHealth -= enemyDamage
        
        showDamage(on: enemy, damage: upgradedAutoDamage)
        showDamage(on: hero, damage: enemyDamage)
        
        viewModel?.totalDamageDealt += upgradedAutoDamage
        viewModel?.accumulatedDamageTaken += enemyDamage
        
        checkBattleStatus()
    }
    
    func showDamage(on node: SKSpriteNode, damage: Int) {
        let label = SKLabelNode(text: "-\(damage)")
        label.fontName = "Helvetica-Bold"
        label.fontSize = 20
        label.fontColor = .red
        label.position = node.position
        addChild(label)
        
        let moveUp = SKAction.moveBy(x: 0, y: GameConfiguration.Game.damageAnimationHeight, duration: GameConfiguration.Game.damageDisplayDuration)
        let fadeOut = SKAction.fadeOut(withDuration: GameConfiguration.Game.damageDisplayDuration)
        let group = SKAction.group([moveUp, fadeOut])
        let remove = SKAction.removeFromParent()
        label.run(SKAction.sequence([group, remove]))
    }
    
    func checkBattleStatus() {
        if enemyHealth <= 0 {
            enemyDefeated()
        }
        if heroHealth <= 0 {
            heroDefeated()
        }
    }
    
    func enemyDefeated() {
        removeAction(forKey: battleCycleKey)
        
        let coinsReward = GameConfiguration.Game.getCoinsReward(for: currentEnemyIndex)
        totalCoinsEarned += coinsReward
        appViewModel?.updateCoins(for: coinsReward)
        
        viewModel?.coinsEarnedThisRun += coinsReward
        
        showCoinReward(coinsReward)
        
        enemiesKilledThisRun += 1
        
        let fadeOut = SKAction.fadeOut(withDuration: GameConfiguration.Game.enemyFadeOutDuration)
        enemy.run(fadeOut) { [weak self] in
            guard let self = self else { return }
            self.enemy.removeFromParent()
            
            if self.currentEnemyIndex >= GameConfiguration.Game.totalEnemies - 1 {
                self.endGame(victory: true)
                return
            }
            
            let transitionDuration: TimeInterval = GameConfiguration.Game.transitionDuration
            let transitionDistance = self.size.width * GameConfiguration.Game.transitionDistanceMultiplier
            self.isTransitioning = true
            self.transitionDistanceRemaining = transitionDistance
            self.transitionSpeed = transitionDistance / CGFloat(transitionDuration)
            self.spawnEnemyDuringTransition(duration: transitionDuration)
        }
        
        let progress = Double(currentEnemyIndex + 1) / Double(GameConfiguration.Game.totalEnemies) * 100
        viewModel?.distanceTraveled = CGFloat(progress)
    }
    
    func showCoinReward(_ coins: Int) {
        let label = SKLabelNode(text: "+\(coins)")
        label.fontName = "Helvetica-Bold"
        label.fontSize = 24
        label.fontColor = .yellow
        label.position = CGPoint(x: enemy.position.x, y: enemy.position.y + 50)
        addChild(label)
        
        let moveUp = SKAction.moveBy(x: 0, y: 40, duration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let group = SKAction.group([moveUp, fadeOut])
        let remove = SKAction.removeFromParent()
        label.run(SKAction.sequence([group, remove]))
    }
    
    func spawnEnemyDuringTransition(duration: TimeInterval) {
        enemy?.removeFromParent()
        enemyHealthBar?.removeFromParent()
        
        let nextEnemyIndex = currentEnemyIndex + 1
        let enemyImageName = GameConfiguration.Game.enemyTypes[nextEnemyIndex]
        currentEnemyType = enemyImageName
        
        enemy = SKSpriteNode(imageNamed: enemyImageName)
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: size.height / GameConfiguration.Game.enemyPositionY)
        enemy.size.height = GameConfiguration.UI.enemyHeight
        if let texture = enemy.texture {
            let aspectRatio = texture.size().width / texture.size().height
            enemy.size.width = GameConfiguration.UI.enemyHeight * aspectRatio
        }
        addChild(enemy)
        
        enemyMaxHealth = GameConfiguration.Game.getEnemyHealth(for: nextEnemyIndex)
        enemyHealth = enemyMaxHealth
        
        let targetX = size.width * GameConfiguration.Game.enemyPositionX
        let moveAction = SKAction.moveTo(x: targetX, duration: duration)
        
        enemy.run(moveAction)
    }
    
    func heroDefeated() {
        endGame(victory: false)
    }
    
    func victory() {
        removeAllActions()
    }
    
    func endGame(victory: Bool) {
        removeAllActions()
        let endTime = CACurrentMediaTime()
        viewModel?.totalTime = endTime - startTime
        viewModel?.healthLost = viewModel?.accumulatedDamageTaken ?? 0
        
        viewModel?.gameEnded = true
        viewModel?.gameWin = victory
        
        if let viewModel = viewModel, let appViewModel = appViewModel, !viewModel.statisticsUpdated {
            appViewModel.updateGameStatistics(
                enemiesKilled: viewModel.totalEnemiesKilled,
                maxEnemyIndex: currentEnemyIndex,
                timePlayed: viewModel.totalTime,
                didWin: victory
            )
            viewModel.statisticsUpdated = true
            
            print("Statistics updated: enemies killed = \(viewModel.totalEnemiesKilled), max enemy index = \(currentEnemyIndex)")
        }
    }
    
    func restartGame() {
        removeAllActions()
        isTransitioning = false
        transitionDistanceRemaining = 0
        transitionSpeed = 0
        
        currentEnemyIndex = 0
        enemiesKilledThisRun = 0
        totalCoinsEarned = 0
        heroHealth = upgradedHeroMaxHealth
        
        bg1.position = .zero
        bg2.position = CGPoint(x: bg1.size.width - 1, y: 0)
        
        enemy?.removeFromParent()
        enemyHealthBar?.removeFromParent()
        
        hero.removeAllActions()
        startBattleIdleAnimation()
        
        startTime = CACurrentMediaTime()
        
        viewModel?.totalEnemiesKilled = 0
        viewModel?.currentEnemyIndex = 0
        viewModel?.coinsEarnedThisRun = 0
        viewModel?.distanceTraveled = 0
        viewModel?.accumulatedDamageTaken = 0
        viewModel?.totalDamageDealt = 0
        viewModel?.gameEnded = false
        viewModel?.resetStatisticsFlag()
        
        spawnEnemy()
        startBattleCycle()
    }
}

extension GameScene {
    func applyExtraDamage() {
        if !isTransitioning {
            let extraDamage = upgradedClickDamage
            enemyHealth -= extraDamage
            viewModel?.totalDamageDealt += extraDamage
            showDamage(on: enemy, damage: extraDamage)
            checkBattleStatus()
        }
    }
}
