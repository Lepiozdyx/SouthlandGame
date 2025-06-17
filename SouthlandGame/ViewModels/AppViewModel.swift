import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    // MARK: - Coins Management
    @AppStorage(GameConfiguration.UserDefaultsKeys.money) var storedMoney: Int = GameConfiguration.Game.startingMoney
    @Published var money: Int = GameConfiguration.Game.startingMoney
    @Published var oldMoney = 0
    
    // MARK: - Settings
    @AppStorage(GameConfiguration.UserDefaultsKeys.soundEnabled) var soundEnabled: Bool = true
    @AppStorage(GameConfiguration.UserDefaultsKeys.musicEnabled) var musicEnabled: Bool = true
    
    // MARK: - Onboarding
    @AppStorage(GameConfiguration.UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false
    @Published var showOnboarding: Bool = false
    
    // MARK: - Statistics
    @AppStorage(GameConfiguration.UserDefaultsKeys.totalEnemiesKilled) var monstersKilled: Int = 0
    @AppStorage(GameConfiguration.UserDefaultsKeys.defeatedBosses) var defeatedBosses: Int = 0
    @AppStorage(GameConfiguration.UserDefaultsKeys.maxHeroLevel) var maxHeroLevel: Int = 0
    @AppStorage(GameConfiguration.UserDefaultsKeys.goldAccumulated) var goldAccumulated: Int = 0
    @AppStorage(GameConfiguration.UserDefaultsKeys.goldSpent) var goldSpent: Int = 0
    @AppStorage(GameConfiguration.UserDefaultsKeys.matchesPlayed) var matchesPlayed: Int = 0
    @AppStorage(GameConfiguration.UserDefaultsKeys.totalTime) var totalTime: TimeInterval = 0
    @AppStorage(GameConfiguration.UserDefaultsKeys.maxEnemyReached) var maxEnemyReached: Int = -1
    
    // MARK: - Shop Items
    @Published var shopTeamItems: [Item] = GameConfiguration.Shop.getDefaultShopItems()
    @Published var boughtItems: [String] = [GameConfiguration.Game.hero]
    @AppStorage(GameConfiguration.UserDefaultsKeys.currentTeamItem) var currentTeamItem: String = GameConfiguration.Game.defaultHero
    
    // MARK: - UserDefaults Keys
    private let userDefaultsTeamKey = GameConfiguration.UserDefaultsKeys.saveCurrentItemImage
    private let userDefaultsBoughtKey = GameConfiguration.UserDefaultsKeys.boughtItem
    
    // MARK: - Initialization
    init() {
        money = storedMoney
        loadShopData()
        
        if !hasSeenOnboarding {
            showOnboarding = true
        }
    }
    
    // MARK: - Onboarding Management
    func completeOnboarding() {
        hasSeenOnboarding = true
        showOnboarding = false
    }
    
    // MARK: - Coins Management Methods
    func updateCoins(for amount: Int) {
        oldMoney = self.money
        self.money += amount
        storedMoney = self.money
        
        if amount > 0 {
            goldAccumulated += amount
        }
    }
    
    func decreaseCoins(for amount: Int) {
        oldMoney = self.money
        self.money -= amount
        if self.money < 0 {
            self.money = 0
        }
        storedMoney = self.money
        
        if amount > 0 {
            goldSpent += amount
        }
    }
    
    // MARK: - Shop Management Methods
    func buyItem(for item: Item) {
        guard let index = shopTeamItems.firstIndex(where: { $0.itemType == item.itemType }),
              money >= item.cost,
              shopTeamItems[index].level < shopTeamItems[index].maxLevel else {
            return
        }
        
        decreaseCoins(for: item.cost)
        
        shopTeamItems[index].level += 1
        updateItemEffectsAndCosts(at: index)
        saveShopData()
    }
    
    func buyHero(_ heroName: String, cost: Int) -> Bool {
        guard money >= cost else { return false }
        
        decreaseCoins(for: cost)
        if !boughtItems.contains(heroName) {
            boughtItems.append(heroName)
            saveShopData()
        }
        return true
    }
    
    // MARK: - Shop Item Upgrades
    private func updateItemEffectsAndCosts(at index: Int) {
        let item = shopTeamItems[index]
        let newLevel = item.level
        
        if newLevel < item.maxLevel {
            shopTeamItems[index].cost = GameConfiguration.Shop.ItemUpgrades.getUpgradeCost(
                itemType: item.itemType,
                currentLevel: newLevel
            )
        } else {
            shopTeamItems[index].cost = 0
        }
        
        var totalEffect = 0
        for level in 1...newLevel {
            totalEffect += GameConfiguration.Shop.ItemUpgrades.getUpgradeEffect(
                itemType: item.itemType,
                currentLevel: level
            )
        }
        shopTeamItems[index].effect = totalEffect
    }
    
    // MARK: - Statistics Management
    func resetStatistics() {
        monstersKilled = 0
        defeatedBosses = 0
        maxHeroLevel = 0
        goldAccumulated = 0
        goldSpent = 0
        matchesPlayed = 0
        totalTime = 0
        maxEnemyReached = -1
        
        print("Statistics reset")
    }
    
    func updateGameStatistics(enemiesKilled: Int, maxEnemyIndex: Int, timePlayed: TimeInterval, didWin: Bool) {
        print("Updating game statistics:")
        print("- Enemies killed this game: \(enemiesKilled)")
        print("- Max enemy index reached: \(maxEnemyIndex)")
        print("- Time played: \(timePlayed)")
        print("- Did win: \(didWin)")
        print("- Previous total monsters killed: \(monstersKilled)")
        print("- Previous max enemy reached: \(maxEnemyReached)")
        
        monstersKilled += enemiesKilled
        matchesPlayed += 1
        totalTime += timePlayed
        maxHeroLevel = max(maxHeroLevel, maxEnemyIndex + 1)
        maxEnemyReached = max(maxEnemyReached, maxEnemyIndex)
        
        if didWin {
            defeatedBosses += 1
        }
        
        print("- New total monsters killed: \(monstersKilled)")
        print("- New max enemy reached: \(maxEnemyReached)")
        print("- New max hero level: \(maxHeroLevel)")
        print("- Total matches played: \(matchesPlayed)")
        print("- Defeated bosses: \(defeatedBosses)")
    }
    
    // MARK: - Settings Management
    func toggleMusic() {
        musicEnabled.toggle()
        if musicEnabled {
            SoundManager.shared.playBackgroundMusic()
        } else {
            SoundManager.shared.stopBackgroundMusic()
        }
    }
    
    func setMusicEnabled(_ enabled: Bool) {
        musicEnabled = enabled
        if enabled {
            SoundManager.shared.playBackgroundMusic()
        } else {
            SoundManager.shared.stopBackgroundMusic()
        }
    }
    
    // MARK: - Data Persistence
    private func saveShopData() {
        if let encodedTeamData = try? JSONEncoder().encode(shopTeamItems) {
            UserDefaults.standard.set(encodedTeamData, forKey: userDefaultsTeamKey)
        }
        
        if let encodedBoughtData = try? JSONEncoder().encode(boughtItems) {
            UserDefaults.standard.set(encodedBoughtData, forKey: userDefaultsBoughtKey)
        }
    }
    
    private func loadShopData() {
        if let savedTeamData = UserDefaults.standard.data(forKey: userDefaultsTeamKey),
           let loadedItems = try? JSONDecoder().decode([Item].self, from: savedTeamData) {
            shopTeamItems = loadedItems
            
            for index in shopTeamItems.indices {
                updateItemEffectsAndCosts(at: index)
            }
        }
        
        if let savedBoughtData = UserDefaults.standard.data(forKey: userDefaultsBoughtKey),
           let loadedBoughtItems = try? JSONDecoder().decode([String].self, from: savedBoughtData) {
            boughtItems = loadedBoughtItems
        }
    }
    
    // MARK: - Computed Properties
    var upgradedAutoDamage: Int {
        return shopTeamItems.first(where: { $0.itemType == .autoDamage })?.effect ?? 5
    }
    
    var upgradedClickDamage: Int {
        return shopTeamItems.first(where: { $0.itemType == .clickDamage })?.effect ?? 2
    }
    
    var upgradedHeroMaxHealth: Int {
        return shopTeamItems.first(where: { $0.itemType == .heroHealth })?.effect ?? GameConfiguration.Game.defaultHeroMaxHealth
    }
    
    var heroAutoDamageDisplay: String {
        return "\(upgradedAutoDamage)"
    }
    
    var heroClickDamageDisplay: String {
        return "\(upgradedClickDamage)"
    }
    
    var heroMaxHealthDisplay: String {
        return "\(upgradedHeroMaxHealth)"
    }
    
    var bestResultDisplay: String {
        if maxEnemyReached < 0 {
            return "None"
        } else {
            return "\(maxEnemyReached + 1)"
        }
    }
}

// MARK: - Item Model
struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var itemType: ItemType
    var level: Int
    var maxLevel: Int
    var effect: Int
    var cost: Int
    var bought: Bool
    
    var description: String {
        switch itemType {
        case .autoDamage:
            return GameConfiguration.ItemDescriptions.autoDamage
        case .clickDamage:
            return GameConfiguration.ItemDescriptions.clickDamage
        case .heroHealth:
            return GameConfiguration.ItemDescriptions.heroHealth
        }
    }
}
