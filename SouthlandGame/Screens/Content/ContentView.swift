import SwiftUI

struct ContentView: View {
    @StateObject private var state = AppStateViewModel()
        
    var body: some View {
        Group {
            switch state.appState {
            case .request:
                LoadingView()
                
            case .terms:
                if let url = state.webManager.southlandURL {
                    WebViewManager(url: url, webManager: state.webManager)
                        .onAppear {
                            ScreenManager.shared.unlock()
                        }
                    
                } else {
                    WebViewManager(url: NetworkManager.initialURL, webManager: state.webManager)
                        .onAppear {
                            ScreenManager.shared.unlock()
                        }
                }
                
            case .menu:
                MenuView()
                    .preferredColorScheme(.light)
//                    .onAppear {
//                        ScreenManager.shared.lock()
//                    }
            }
        }
        .onAppear {
            state.fetchState()
        }
    }
}

#Preview {
    ContentView()
}
