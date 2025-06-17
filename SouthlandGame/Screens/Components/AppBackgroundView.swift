import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        Image(GameConfiguration.Images.appBackground)
            .resizable()
            .ignoresSafeArea()
    }
}

#Preview {
    AppBackgroundView()
}
