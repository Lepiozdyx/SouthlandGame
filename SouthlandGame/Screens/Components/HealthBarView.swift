import SwiftUI

struct HealthBarView: View {
    var current: Int
    var max: Int
    
    var clampedCurrent: Int {
        guard max > 0 else { return 0 }
        return Swift.max(0, min(current, max))
    }
    
    var body: some View {
        HStack(spacing: -10) {
            Image(GameConfiguration.Images.heartIcon)
                .resizable()
                .scaledToFit()
                .frame(height: GameConfiguration.UI.heartIconSize)
                .zIndex(1)
            
            HStack {
                ProgressView(
                    value: Float(clampedCurrent),
                    total: Float(max > 0 ? max : 1)
                )
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                .frame(width: GameConfiguration.UI.healthBarProgressWidth)
                .scaleEffect(
                    x: 1,
                    y: GameConfiguration.UI.healthBarScaleY,
                    anchor: .center
                )
            }
            .padding(GameConfiguration.UI.healthBarPadding)
            .background(Color.brown)
            .clipShape(.capsule)
        }
    }
}

#Preview {
    HealthBarView(current: 80, max: 100)
}
