import SwiftUI

struct LoadingView: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            VStack(spacing: 0) {
                Spacer()
                
                Image(.logoIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: GameConfiguration.UI.logoHeight)
                
                Image(.logoIcon2)
                    .resizable()
                    .scaledToFit()
                    .frame(height: GameConfiguration.UI.loadingTextHeight)
                
                Spacer()
                
                ProgressView()
                    .scaleEffect(2.0)
                    .tint(.white)
            }
            .padding()
        }
    }
}

#Preview {
    LoadingView()
}
