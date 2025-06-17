import SwiftUI

struct SelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var showGame = false
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ZStack {
                Image(GameConfiguration.Images.levelFrame)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: GameConfiguration.UI.frameWidth,
                        height: GameConfiguration.UI.frameHeight
                    )
                
                HStack(spacing: 30) {
                    Image(GameConfiguration.Images.hero)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GameConfiguration.UI.heroHeight)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hero Stats")
                            .font(.system(size: GameConfiguration.UI.mediumFontSize, weight: .black))
                            .foregroundColor(.sand)
                        
                        HeroStatRow(
                            title: "Auto Damage:",
                            value: appViewModel.heroAutoDamageDisplay,
                            description: "Base damage per auto attack"
                        )
                        
                        HeroStatRow(
                            title: "Click Damage:",
                            value: appViewModel.heroClickDamageDisplay,
                            description: "Damage when tapping"
                        )
                        
                        HeroStatRow(
                            title: "Health:",
                            value: appViewModel.heroMaxHealthDisplay,
                            description: "HP"
                        )
                    }
                    .padding()
                }
            }
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(GameConfiguration.Images.homeIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GameConfiguration.UI.smallIconHeight)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                Button {
                    appViewModel.currentTeamItem = GameConfiguration.Game.hero
                    showGame = true
                } label: {
                    Image(GameConfiguration.Images.startButton)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GameConfiguration.UI.buttonHeight)
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showGame) {
            GameView()
                .environmentObject(appViewModel)
        }
    }
}

struct HeroStatRow: View {
    let title: String
    let value: String
    let description: String
    
    var body: some View {
        HStack(spacing: 20) {
            Text(description)
                .font(.system(size: GameConfiguration.UI.extraSmallFontSize, weight: .bold))
                .foregroundStyle(.sand)
                .lineLimit(1)
            
            Text(value)
                .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .bold))
                .foregroundStyle(.sand)
        }
    }
}

#Preview {
    SelectionView()
        .environmentObject(AppViewModel())
}
