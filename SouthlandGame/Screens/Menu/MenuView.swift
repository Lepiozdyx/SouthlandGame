import SwiftUI

struct MenuView: View {
    @Environment(\.scenePhase) private var phase
    @StateObject private var appViewModel = AppViewModel()
    
    @State private var showGame = false
    @State private var showShop = false
    @State private var showStatistics = false
    @State private var showSettings = false
    
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
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                if appViewModel.musicEnabled {
                    SoundManager.shared.playBackgroundMusic()
                } else {
                    SoundManager.shared.stopBackgroundMusic()
                }
            case .background:
                SoundManager.shared.stopBackgroundMusic()
            case .inactive:
                SoundManager.shared.stopBackgroundMusic()
            @unknown default:
                break
            }
        }
        .fullScreenCover(isPresented: $showGame) {
            SelectionView()
                .environmentObject(appViewModel)
                .onAppear {
                    ScreenManager.shared.lockLandscape()
                }
        }
        .fullScreenCover(isPresented: $showShop) {
            ShopView()
                .environmentObject(appViewModel)
                .onAppear {
                    ScreenManager.shared.lockLandscape()
                }
        }
        .fullScreenCover(isPresented: $showStatistics) {
            StatisticsView()
                .environmentObject(appViewModel)
                .onAppear {
                    ScreenManager.shared.lockLandscape()
                }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appViewModel)
                .onAppear {
                    ScreenManager.shared.lockLandscape()
                }
        }
    }
}

#Preview {
    MenuView()
}
