import Combine
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var heroHealth: Int = 100
    @Published var heroMaxHealth: Int = 100
    @Published var enemyHealth: Int = 100
    @Published var enemyMaxHealth: Int = 100
    
    @Published var distanceTraveled: CGFloat = 0
    @Published var totalEnemiesKilled: Int = 0
    @Published var currentEnemyIndex: Int = 0
    @Published var coinsEarnedThisRun: Int = 0
    @Published var totalTime: TimeInterval = 0
    @Published var healthLost: Int = 0
    @Published var totalDamageDealt: Int = 0
    @Published var accumulatedDamageTaken: Int = 0
    @Published var pepperUsage: Int = 0
    
    @Published var gameEnded: Bool = false
    @Published var gameWin: Bool = false
    @Published var statisticsUpdated: Bool = false
    
    func resetStatisticsFlag() {
        statisticsUpdated = false
    }
    
    var currentEnemyDisplay: Int {
        return currentEnemyIndex + 1
    }
    
    var maxEnemyReachedDisplay: Int {
        return max(0, currentEnemyIndex)
    }
}
