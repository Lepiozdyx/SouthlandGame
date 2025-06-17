import SwiftUI

struct StatisticItem {
    let title: String
    let value: String
    let textColor: Color
    
    init(title: String, value: String, textColor: Color = .sand) {
        self.title = title
        self.value = value
        self.textColor = textColor
    }
}

struct StatisticRowView: View {
    let item: StatisticItem
    
    var body: some View {
        HStack(spacing: 8) {
            Text(item.title)
                .font(.system(size: GameConfiguration.UI.extraSmallFontSize, weight: .semibold))
                .foregroundStyle(item.textColor)
                .lineLimit(2)
            
            Spacer()
            
            Image(.buttonFrame)
                .resizable()
                .scaledToFit()
                .frame(height: GameConfiguration.UI.miniIconHeight)
                .overlay {
                    Text(item.value)
                        .font(.system(size: GameConfiguration.UI.extraSmallFontSize, weight: .black))
                        .foregroundStyle(item.textColor)
                }
        }
    }
}

struct StatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    
    var statisticsItems: [StatisticItem] {
        [
            StatisticItem(
                title: "Furthest Enemy Reached:",
                value: appViewModel.bestResultDisplay
            ),
            StatisticItem(
                title: "Total Enemies Defeated:",
                value: "\(appViewModel.monstersKilled)"
            ),
            StatisticItem(
                title: "Adventures Completed:",
                value: "\(appViewModel.defeatedBosses)"
            ),
            StatisticItem(
                title: "Current Hero Power:",
                value: "\(appViewModel.maxHeroLevel)"
            ),
            StatisticItem(
                title: "Total Gold Earned:",
                value: "\(appViewModel.goldAccumulated)"
            ),
            StatisticItem(
                title: "Gold Spent on Upgrades:",
                value: "\(appViewModel.goldSpent)"
            ),
            StatisticItem(
                title: "Adventures Attempted:",
                value: "\(appViewModel.matchesPlayed)"
            ),
            StatisticItem(
                title: "Total Playtime:",
                value: formatTime(appViewModel.totalTime)
            )
        ]
    }
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(GameConfiguration.Images.homeIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GameConfiguration.UI.smallIconHeight)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
            
            Image(GameConfiguration.Images.statisticsFrame)
                .resizable()
                .scaledToFit()
                .frame(
                    width: GameConfiguration.UI.frameWidth,
                    height: GameConfiguration.UI.frameHeight
                )
                .overlay {
                    VStack(spacing: 8) {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2),
                                 alignment: .leading, spacing: 6) {
                            ForEach(statisticsItems.indices, id: \.self) { index in
                                StatisticRowView(item: statisticsItems[index])
                            }
                        }
                    }
                    .padding(.top)
                    .padding(35)
                }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return "\(hours):\(minutes)h"
        } else if minutes > 0 {
            return "\(minutes):\(seconds)"
        } else {
            return "\(seconds)s"
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(AppViewModel())
}
