import Foundation

@MainActor
final class AppStateViewModel: ObservableObject {
    
    enum AppState {
        case request
        case terms
        case menu
    }
    
    @Published private(set) var appState: AppState = .request
    let webManager: NetworkManager
    private var timeoutTask: Task<Void, Never>?
    private let maxLoadingTime: TimeInterval = 10.0
    
    init(webManager: NetworkManager = NetworkManager()) {
        self.webManager = webManager
    }
    
    func fetchState() {
        timeoutTask?.cancel()
        
        Task { @MainActor in
            do {
                if webManager.southlandURL != nil {
                    updateState(.terms)
                    return
                }
                
                let shouldShowWebView = try await webManager.checkInitialURL()
                
                if shouldShowWebView {
                    updateState(.terms)
                } else {
                    updateState(.menu)
                }
                
            } catch {
                updateState(.menu)
            }
        }
        
        startTimeoutTask()
    }
    
    private func updateState(_ newState: AppState) {
        timeoutTask?.cancel()
        timeoutTask = nil
        
        appState = newState
    }
    
    private func startTimeoutTask() {
        timeoutTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: UInt64(maxLoadingTime * 1_000_000_000))
                
                if self.appState == .request {
                    self.appState = .menu
                }
            } catch {}
        }
    }
    
    deinit {
        timeoutTask?.cancel()
    }
}
