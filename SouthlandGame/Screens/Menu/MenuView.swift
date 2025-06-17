import SwiftUI

struct MenuView: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showStatistics = false
    @State private var showSettings = false
    
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(GameConfiguration.Images.settingsIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GameConfiguration.UI.mediumIconHeight)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            VStack {
                Button {
                    showGame = true
                } label: {
                    Image(GameConfiguration.Images.playIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GameConfiguration.UI.mediumIconHeight)
                }
                
                Button {
                    showStatistics = true
                } label: {
                    Image(GameConfiguration.Images.statisticsIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GameConfiguration.UI.mediumIconHeight)
                }
                
                Button {
                    showShop = true
                } label: {
                    Image(GameConfiguration.Images.shopIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GameConfiguration.UI.mediumIconHeight)
                }
            }
            .padding()
            
            if appViewModel.showOnboarding {
                OnboardingView()
                    .environmentObject(appViewModel)
            }
        }
        .onAppear {
            if appViewModel.musicEnabled {
                SoundManager.shared.playBackgroundMusic()
            }
        }
        .onChange(of: appViewModel.musicEnabled) { enabled in
            if enabled {
                SoundManager.shared.playBackgroundMusic()
            } else {
                SoundManager.shared.stopBackgroundMusic()
            }
        }
        .fullScreenCover(isPresented: $showGame) {
            SelectionView()
                .environmentObject(appViewModel)
        }
        .fullScreenCover(isPresented: $showShop) {
            ShopView()
                .environmentObject(appViewModel)
        }
        .fullScreenCover(isPresented: $showStatistics) {
            StatisticsView()
                .environmentObject(appViewModel)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appViewModel)
        }
    }
}

#Preview {
    MenuView()
}
