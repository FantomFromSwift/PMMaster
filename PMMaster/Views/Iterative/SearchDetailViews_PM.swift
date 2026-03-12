import SwiftData
import SwiftUI

struct StrategyTipDetailView_PM: View {
    let tip: StrategyTip
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var viewModel
    
    @Query private var favorites: [FavoriteItem]
    
    private var isSaved: Bool {
        favorites.contains(where: { $0.id == tip.id })
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "STRATEGY TIP", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: adaptyH(24)) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Colors_PM.gold)
                            .frame(maxWidth: .infinity)
                            .padding(.top, adaptyH(40))
                            
                        Text(tip.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: adaptyH(12)) {
                            Text("SUMMARY")
                                .font(.caption).bold().foregroundColor(Colors_PM.neonGreen)
                            
                            Text(tip.summary)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Colors_PM.cardBackground)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        Text(tip.fullText)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineSpacing(8)
                            .padding(.horizontal)
                        
                        Button(action: toggleFavorite) {
                            HStack {
                                Image(systemName: isSaved ? "star.fill" : "star")
                                Text(isSaved ? "Saved to Favorites" : "Save Tip")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSaved ? Colors_PM.gold : Colors_PM.neonGreen)
                            .clipShape(Capsule())
                        }
                        .padding()
                    }
                }
                .contentMargins(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private func toggleFavorite() {
        if isSaved {
            if let item = favorites.first(where: { $0.id == tip.id }) {
                modelContext.delete(item)
            }
        } else {
            let favItem = FavoriteItem(id: tip.id, title: tip.title, category: "Tip")
            modelContext.insert(favItem)
        }
        try? modelContext.save()
    }
}

private let historyMatchAssetNames: [String: String] = [
    "hist_1": "ManchesterCityvBarcelona",
    "hist_2": "mancityfcbayern.jpg",
    "hist_3": "livarpoolvsarsenal",
    "hist_4": "bayernmunichvsarsenal.jpg",
    "hist_5": "barselonavslivarpool"
]

struct HistoryMatchDetailView_PM: View {
    let match: HistoryMatch
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var viewModel
    
    @Query private var favorites: [FavoriteItem]
    
    private var isSaved: Bool {
        favorites.contains(where: { $0.id == match.id })
    }
    
    private var matchImageName: String? {
        historyMatchAssetNames[match.id]
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "MATCH HISTORY", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ZStack {
                            Rectangle()
                                .fill(Colors_PM.darkBackground)
                                .frame(height: adaptyH(200))
                                .clipped()
                            
                            if let name = matchImageName {
                                Image(name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: adaptyH(200))
                            } else {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                        }
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top, adaptyH(20))
                        
                        VStack(alignment: .center, spacing: adaptyH(8)) {
                            Text(match.teams)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                
                            Text(match.score)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Colors_PM.neonGreen)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Text("ANALYSIS")
                            .font(.caption).bold().foregroundColor(Colors_PM.gold)
                            .padding(.horizontal)
                            
                        Text(match.analysisText)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineSpacing(8)
                            .padding(.horizontal)
                        
                        Button(action: toggleFavorite) {
                            HStack {
                                Image(systemName: isSaved ? "star.fill" : "star")
                                Text(isSaved ? "Saved to Favorites" : "Save Match")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSaved ? Colors_PM.gold : Colors_PM.accentBlue)
                            .clipShape(Capsule())
                        }
                        .padding()
                    }
                }
                .contentMargins(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private func toggleFavorite() {
        if isSaved {
            if let item = favorites.first(where: { $0.id == match.id }) {
                modelContext.delete(item)
            }
        } else {
            let favItem = FavoriteItem(id: match.id, title: match.teams, category: "History")
            modelContext.insert(favItem)
        }
        try? modelContext.save()
    }
}
