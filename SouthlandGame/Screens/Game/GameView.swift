import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var gameVM = GameViewModel()
    @State private var scene = GameScene(
        size: CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
    )
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    scene.viewModel = gameVM
                    scene.appViewModel = appViewModel
                }
            
            VStack {
                HStack(alignment: .bottom) {
                    Button {
                        dismiss()
                    } label: {
                        Image(GameConfiguration.Images.homeIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GameConfiguration.UI.smallIconHeight)
                    }
                    
                    HStack {
                        HealthBarView(
                            current: gameVM.heroHealth,
                            max: gameVM.heroMaxHealth
                        )
                        
                        Spacer()
                        
                        HealthBarView(
                            current: gameVM.enemyHealth,
                            max: gameVM.enemyMaxHealth
                        )
                    }
                }
            
                Spacer()
                
                Button {
                    scene.applyExtraDamage()
                } label: {
                    Image(.bolt)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GameConfiguration.UI.buttonHeight)
                }
            }
            .padding()
            
            if gameVM.gameEnded {
                GameResultView(gameVM: gameVM, isVictory: gameVM.gameWin) {
                    scene.restartGame()
                } menuAction: {
                    dismiss()
                }
                .environmentObject(appViewModel)
            }
        }
    }
}

#Preview {
    GameView()
        .environmentObject(AppViewModel())
}
