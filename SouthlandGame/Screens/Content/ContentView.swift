import SwiftUI

struct ContentView: View {
    @StateObject private var state = AppStateViewModel()
        
    var body: some View {
        Group {
            switch state.appState {
            case .fetch:
                LoadingView()
                
            case .supp:
                if let url = state.webManager.targetURL {
                    WebViewManager(url: url, webManager: state.webManager)
                        .onAppear {
                            ScreenManager.shared.unlockOrientation()
                        }
                    
                } else {
                    WebViewManager(url: NetworkManager.initialURL, webManager: state.webManager)
                        .onAppear {
                            ScreenManager.shared.unlockOrientation()
                        }
                }
                
            case .final:
                MenuView()
                    .preferredColorScheme(.light)
                    .onAppear {
                        ScreenManager.shared.lockLandscape()
                    }
            }
        }
        .onAppear {
            state.stateCheck()
        }
    }
}

#Preview {
    ContentView()
}
