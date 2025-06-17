import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var currentDialogIndex: Int = 0
    
    private var dialogTexts: [String] {
        GameConfiguration.Onboarding.dialogTexts
    }
    
    private var isLastDialog: Bool {
        currentDialogIndex >= dialogTexts.count - 1
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    Image(GameConfiguration.Images.oldBen)
                        .resizable()
                        .scaledToFit()
                        .frame(height: GameConfiguration.UI.onboardingHeroHeight)
                    
                    Spacer()
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Text(dialogTexts[currentDialogIndex])
                    .font(.system(size: GameConfiguration.UI.mediumFontSize, weight: .bold))
                    .foregroundStyle(.sand)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: GameConfiguration.UI.onboardingDialogWidth)
                
                Spacer()
                
                Button {
                    if isLastDialog {
                        appViewModel.completeOnboarding()
                    } else {
                        nextDialog()
                    }
                } label: {
                    ZStack {
                        Image(isLastDialog ? GameConfiguration.Images.finishButton : GameConfiguration.Images.nextButton)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GameConfiguration.UI.smallIconHeight)
                        
                        Text(isLastDialog ? "" : "Next")
                            .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                            .foregroundStyle(.sand)
                    }
                }
            }
            .padding()
        }
        .animation(.easeInOut(duration: 0.3), value: currentDialogIndex)
    }
    
    private func nextDialog() {
        if currentDialogIndex < dialogTexts.count - 1 {
            currentDialogIndex += 1
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppViewModel())
}
