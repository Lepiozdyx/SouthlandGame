import SwiftUI

struct GameResultView: View {
    @ObservedObject var gameVM: GameViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var isVictory: Bool
    var restartAction: () -> ()
    var menuAction: () -> ()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            ZStack {
                Image(GameConfiguration.Images.gameoverFrame)
                    .resizable()
                    .scaledToFit()
                
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        if gameVM.currentEnemyIndex >= 0 {
                            Text("Reached: Enemy \(gameVM.currentEnemyDisplay)")
                                .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .bold))
                                .foregroundStyle(.sand)
                        }
                        
                        Text("Total Damage: \(gameVM.totalDamageDealt)")
                            .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .bold))
                            .foregroundStyle(.sand)
                        
                        HStack(spacing: 4) {
                            Text("Coins Earned: \(gameVM.coinsEarnedThisRun)")
                                .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .bold))
                                .foregroundStyle(.sand)
                            
                            Image(GameConfiguration.Images.coinIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: GameConfiguration.UI.extraSmallFontSize + 4)
                        }
                        
                        Text("*Purchase upgrades for your hero in the Shop to advance further.")
                            .font(.system(size: GameConfiguration.UI.extraSmallFontSize, weight: .bold))
                            .foregroundStyle(.sand)
                            .multilineTextAlignment(.center)
                    }
                    
                    HStack(spacing: 30) {
                        if isVictory {
                            VStack(spacing: 10) {
                                Text("All enemies defeated!")
                                    .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .bold))
                                    .foregroundStyle(.sand)
                                    .multilineTextAlignment(.center)
                                
                                Button {
                                    restartAction()
                                } label: {
                                    ZStack {
                                        Image(GameConfiguration.Images.buttonFrame)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: GameConfiguration.UI.smallIconHeight)
                                        
                                        Text("Play")
                                            .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                                            .foregroundStyle(.sand)
                                    }
                                }
                            }
                        } else {
                            Button {
                                restartAction()
                            } label: {
                                ZStack {
                                    Image(GameConfiguration.Images.buttonFrame)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: GameConfiguration.UI.smallIconHeight)
                                    
                                    Text("Restart")
                                        .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                                        .foregroundStyle(.sand)
                                }
                            }
                        }
                        
                        Button {
                            menuAction()
                        } label: {
                            ZStack {
                                Image(GameConfiguration.Images.buttonFrame)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: GameConfiguration.UI.smallIconHeight)
                                
                                Text("Menu")
                                    .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                                    .foregroundStyle(.sand)
                            }
                        }
                    }
                }
                .padding(.top, 40)
            }
            .frame(
                width: GameConfiguration.UI.frameWidth,
                height: GameConfiguration.UI.frameHeight
            )
        }
    }
}

#Preview {
    GameResultView(gameVM: GameViewModel(), isVictory: false, restartAction: {}, menuAction: {})
        .environmentObject(AppViewModel())
}
