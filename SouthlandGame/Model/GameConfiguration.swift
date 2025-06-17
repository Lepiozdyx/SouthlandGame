import Foundation
import UIKit

enum ItemType: String, CaseIterable, Codable {
    case autoDamage = "Auto Damage"
    case clickDamage = "Click Damage"
    case heroHealth = "Hero Health"
}

struct GameConfiguration {
    
    // MARK: - Image Assets
    struct Images {
        static let appBackground = "menuBg"
        static let gameField = "gameField"
        
        static let playIcon = "playIcon"
        static let shopIcon = "shopIcon"
        static let settingsIcon = "settingsIcon"
        static let statisticsIcon = "statisticsIcon"
        static let homeIcon = "homeIcon"
        static let coinIcon = "coinIcon"
        static let heartIcon = "heartIcon"
        static let startButton = "start"
        
        static let settingsText = "music"
        
        static let bigFrame = "bigFrame"
        static let levelFrame = "levelbar"
        static let settingsFrame = "settingsFrame"
        static let statisticsFrame = "statisticsFrame"
        static let gameoverFrame = "gameoverFrame"
        static let buttonFrame = "buttonFrame"
        
        static let hero = "cowboy"
        static let oldBen = "cowboyDialog"
        
        static let nextButton = "buttonFrame"
        static let finishButton = "start"
    }
    
    // MARK: - Audio Assets
    struct Audio {
        static let backgroundMusic = "western1"
        static let backgroundMusicExtension = "wav"
    }
    
    // MARK: - Item Descriptions
    struct ItemDescriptions {
        static let autoDamage = "Increases automatic damage dealt to enemies"
        static let clickDamage = "Increases damage dealt when tapping the screen"
        static let heroHealth = "Increases maximum health of your hero"
    }
    
    // MARK: - Onboarding Content
    struct Onboarding {
        static let dialogTexts = [
            "Old Ben is a smiling and wise former sheriff of a small town in the Wild West. He always wears a worn hat and a waistcoat with a shiny star.",
            "Hey, cowboy! First time in these parts? \nDon't worry! It's simple: shoot faster, live longer and don't forget to collect gold. Good luck!",
            "Remember, mate: it's not about winning, it's about not running out of bullets before your opponents do! Ha-ha!",
            "*The game uses rogue-like mechanics: when you die, you become better. \nUse coins to upgrade your abilities in the Shop. Good luck!"
        ]
    }
    
    // MARK: - UI Dimensions
    struct UI {
        private static var isIPad: Bool {
            return DeviceManager.shared.deviceType == .pad
        }
        
        // Icon sizes
        static var smallIconHeight: CGFloat { isIPad ? 90 : 55 }
        static var mediumIconHeight: CGFloat { isIPad ? 120 : 80 }
        
        // Characters
        static var heroHeight: CGFloat { isIPad ? 350 : 180 }
        static var enemyHeight: CGFloat { isIPad ? 370 : 200 }
        
        // Coin counter
        static var coinCounterFrameHeight: CGFloat { isIPad ? 100 : 50 }
        
        // Loading
        static var logoHeight: CGFloat { isIPad ? 400 : 200 }
        static var loadingTextHeight: CGFloat { isIPad ? 60 : 40 }
        
        // Health bars
        static var heartIconSize: CGFloat { isIPad ? 70 : 40 }
        static var healthBarProgressWidth: CGFloat { isIPad ? 230 : 150 }
        static var healthBarScaleY: CGFloat { isIPad ? 4 : 2 }
        static var healthBarPadding: CGFloat { isIPad ? 12 : 6 }
        
        // Settings
        static var settingsButtonHeight: CGFloat { isIPad ? 100 : 50 }
        static var settingsText: CGFloat { isIPad ? 55 : 25 }
        
        // Buttons
        static var buttonHeight: CGFloat { isIPad ? 120 : 60 }
        
        // Font sizes
        static var extraSmallFontSize: CGFloat { isIPad ? 22 : 10 }
        static var smallFontSize: CGFloat { isIPad ? 28 : 16 }
        static var mediumFontSize: CGFloat { isIPad ? 44 : 22 }
        
        // Frame
        static var frameWidth: CGFloat { isIPad ? 900 : 450 }
        static var frameHeight: CGFloat { isIPad ? 750 : 375 }
        static var miniIconHeight: CGFloat { isIPad ? 60 : 30 }
        
        //
        static var onboardingHeroHeight: CGFloat { isIPad ? 600 : 350 }
        static var onboardingDialogWidth: CGFloat { isIPad ? 650 : 450 }
    }
    
    // MARK: - Game Settings
    struct Game {
        // Hero settings
        static let defaultHeroHealth = 100
        static let defaultHeroMaxHealth = 100
        
        // Enemy settings
        static let baseEnemyHealth = 100
        static let baseEnemyMaxHealth = 100
        static let enemyHealthMultiplier: Double = 1.25
        static let enemyDamageMultiplier: Double = 1.25
        static var baseDamage: Int {
            Int.random(in: 8...10)
        }
        
        // Combat settings
        static let battleCycleDuration: TimeInterval = 2.0
        static let attackAnimationDuration: TimeInterval = 0.2
        static let damageDisplayDuration: TimeInterval = 0.5
        static let enemyFadeOutDuration: TimeInterval = 0.5
        
        // Transition settings
        static let transitionDuration: TimeInterval = 3.0
        static let transitionDistanceMultiplier: CGFloat = 0.3
        
        static let damageAnimationHeight: CGFloat = 30
        
        static let totalEnemies = 17
        
        // Hero positions
        static let heroPositionX: CGFloat = 0.25
        static let heroPositionY: CGFloat = 3
        static let enemyPositionX: CGFloat = 0.75
        static let enemyPositionY: CGFloat = 3
        
        // Movement animations
        static let attackMoveDistance: CGFloat = 10
        
        static let baseCoinsPerEnemy = 5
        static let coinMultiplierPerEnemy: Double = 1.1
        
        // Default currency
        static let startingMoney = 100
        
        static let defaultHero = "cowboy"
        static let hero = "cowboy"
        
        static let enemyTypes = [
            "enemy1", "enemy2", "enemy3", "enemy4", "enemy5", "enemy6", "enemy7", "enemy8", "enemy9",
            "enemy10", "enemy11", "enemy12", "enemy13", "enemy14", "enemy15", "enemy16", "enemy17"
        ]
        
        static func getEnemyHealth(for enemyIndex: Int) -> Int {
            return Int(Double(baseEnemyHealth) * pow(enemyHealthMultiplier, Double(enemyIndex)))
        }
        
        static func getEnemyDamage(for enemyIndex: Int) -> Int {
            return Int(Double(baseDamage) * pow(enemyDamageMultiplier, Double(enemyIndex)))
        }
        
        static func getCoinsReward(for enemyIndex: Int) -> Int {
            return Int(Double(baseCoinsPerEnemy) * pow(coinMultiplierPerEnemy, Double(enemyIndex)))
        }
    }
    
    // MARK: - Shop Configuration
    struct Shop {
        static func getDefaultShopItems() -> [Item] {
            return [
                Item(name: ItemType.autoDamage.rawValue, itemType: .autoDamage, level: 1, maxLevel: 10, effect: 5, cost: 0, bought: true),
                Item(name: ItemType.clickDamage.rawValue, itemType: .clickDamage, level: 1, maxLevel: 10, effect: 2, cost: 0, bought: true),
                Item(name: ItemType.heroHealth.rawValue, itemType: .heroHealth, level: 1, maxLevel: 10, effect: 100, cost: 0, bought: true)
            ]
        }
        
        struct ItemUpgrades {
            // Auto Damage
            static let autoDamageBaseCost = 50
            static let autoDamageBaseEffect = 5
            static let autoDamageCostMultiplier: Double = 1.5
            static let autoDamageEffectMultiplier: Double = 1.2
            
            // Click Damage
            static let clickDamageBaseCost = 100
            static let clickDamageBaseEffect = 3
            static let clickDamageCostMultiplier: Double = 1.6
            static let clickDamageEffectMultiplier: Double = 1.3
            
            // Hero Health
            static let heroHealthBaseCost = 75
            static let heroHealthBaseEffect = 50
            static let heroHealthCostMultiplier: Double = 1.4
            static let heroHealthEffectMultiplier: Double = 1.25
            
            static func getUpgradeCost(itemType: ItemType, currentLevel: Int) -> Int {
                switch itemType {
                case .autoDamage:
                    return Int(Double(autoDamageBaseCost) * pow(autoDamageCostMultiplier, Double(currentLevel - 1)))
                case .clickDamage:
                    return Int(Double(clickDamageBaseCost) * pow(clickDamageCostMultiplier, Double(currentLevel - 1)))
                case .heroHealth:
                    return Int(Double(heroHealthBaseCost) * pow(heroHealthCostMultiplier, Double(currentLevel - 1)))
                }
            }
            
            static func getUpgradeEffect(itemType: ItemType, currentLevel: Int) -> Int {
                switch itemType {
                case .autoDamage:
                    return Int(Double(autoDamageBaseEffect) * pow(autoDamageEffectMultiplier, Double(currentLevel - 1)))
                case .clickDamage:
                    return Int(Double(clickDamageBaseEffect) * pow(clickDamageEffectMultiplier, Double(currentLevel - 1)))
                case .heroHealth:
                    return Int(Double(heroHealthBaseEffect) * pow(heroHealthEffectMultiplier, Double(currentLevel - 1)))
                }
            }
        }
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let money = "money"
        static let soundEnabled = "soundEnabled"
        static let musicEnabled = "musicEnabled"
        static let totalEnemiesKilled = "totalEnemiesKilled"
        static let defeatedBosses = "defeatedBosses"
        static let maxHeroLevel = "maxHeroLevel"
        static let goldAccumulated = "goldAccumulated"
        static let goldSpent = "goldSpent"
        static let matchesPlayed = "matchesPlayed"
        static let totalTime = "totalTime"
        static let currentTeamItem = "currentTeamItem"
        static let saveCurrentItemImage = "saveCurrentItemImage"
        static let boughtItem = "boughtItem"
        static let maxEnemyReached = "maxEnemyReached"
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    // MARK: - Animation Keys
    struct AnimationKeys {
        static let battleCycle = "battleCycle"
    }
}
