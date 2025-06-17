import SwiftUI

struct CoinCounterView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        HStack(spacing: -15) {
            Image(GameConfiguration.Images.coinIcon)
                .resizable()
                .scaledToFit()
                .zIndex(1)
            
            Image(GameConfiguration.Images.buttonFrame)
                .resizable()
                .scaledToFit()
                .overlay {
                    Text("\(appViewModel.money)")
                        .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                        .foregroundStyle(.yellow)
                }
        }
        .frame(height: GameConfiguration.UI.coinCounterFrameHeight)
    }
}

#Preview {
    CoinCounterView()
        .environmentObject(AppViewModel())
}
