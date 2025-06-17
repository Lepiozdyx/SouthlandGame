import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: -90) {
                    ForEach(appViewModel.shopTeamItems, id: \.self) { item in
                        shopItem(item: item)
                    }
                }
            }
            
            VStack {
                HStack(alignment: .top) {
                    Button {
                        dismiss()
                    } label: {
                        Image(GameConfiguration.Images.homeIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: GameConfiguration.UI.smallIconHeight)
                    }
                    
                    Spacer()
                    
                    CoinCounterView()
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func shopItem(item: Item) -> some View {
        ZStack {
            Image(GameConfiguration.Images.bigFrame)
                .resizable()
                .scaledToFit()
                .frame(
                    width: GameConfiguration.UI.frameWidth,
                    height: GameConfiguration.UI.frameHeight
                )
            
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text(item.name)
                        .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .bold))
                        .foregroundStyle(.sand)
                        .multilineTextAlignment(.center)
                    
                    Text("Level \(item.level)/\(item.maxLevel)")
                        .font(.system(size: GameConfiguration.UI.mediumFontSize, weight: .medium))
                        .foregroundStyle(.sand)
                    
                    Text(item.description)
                        .font(.system(size: GameConfiguration.UI.extraSmallFontSize, weight: .regular))
                        .foregroundStyle(.sand)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    if item.level < item.maxLevel {
                        let nextEffect = GameConfiguration.Shop.ItemUpgrades.getUpgradeEffect(
                            itemType: item.itemType,
                            currentLevel: item.level + 1
                        )
                        
                        Text("Next upgrade: +\(nextEffect)")
                            .font(.system(size: GameConfiguration.UI.extraSmallFontSize, weight: .medium))
                            .foregroundStyle(.sand)
                    } else {
                        Text("MAX LEVEL")
                            .font(.system(size: GameConfiguration.UI.extraSmallFontSize, weight: .bold))
                            .foregroundStyle(.sand)
                    }
                }
                
                Button {
                    appViewModel.buyItem(for: item)
                } label: {
                    ZStack {
                        Image(GameConfiguration.Images.buttonFrame)
                            .resizable()
                            .scaledToFit()
                        
                        HStack {
                            if item.level >= item.maxLevel {
                                Text("MAX")
                                    .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                                    .foregroundStyle(.yellow)
                            } else if appViewModel.money < item.cost {
                                HStack {
                                    Text("\(item.cost)")
                                        .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                                        .foregroundStyle(.red)
                                }
                            } else {
                                Text("\(item.cost)")
                                    .font(.system(size: GameConfiguration.UI.smallFontSize, weight: .black))
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .frame(height: GameConfiguration.UI.smallIconHeight)
                }
                .disabled(item.level >= item.maxLevel || appViewModel.money < item.cost)
            }
        }
    }
}

#Preview {
    ShopView()
        .environmentObject(AppViewModel())
}
