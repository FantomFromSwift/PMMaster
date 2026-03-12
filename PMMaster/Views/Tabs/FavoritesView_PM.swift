import SwiftUI
import SwiftData
import Charts

struct FavoritesView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \FavoriteItem.dateAdded, order: .reverse) private var favorites: [FavoriteItem]
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "FAVORITES", showBackButton: false)
                
                ScrollView {
                    VStack(spacing: adaptyH(24)) {
                        VStack(alignment: .leading, spacing: adaptyH(16)) {
                            Text("SAVED ITEMS")
                                .font(.caption)
                                .bold()
                                .tracking(2)
                                .foregroundColor(Colors_PM.gold)
                            
                            if !favorites.isEmpty {
                                ForEach(favorites) { item in
                                    Group {
                                        if let article = viewModel.content.articles.first(where: { $0.id == item.id }) {
                                            NavigationLink(destination: ArticleDetailView_PM(article: article)) {
                                                FavoriteRow_PM(item: item, onRemove: { removeFromFavorites(item) })
                                            }
                                        } else if let task = viewModel.content.tasks.first(where: { $0.id == item.id }) {
                                            NavigationLink(destination: TaskDetailsView_PM(task: task)) {
                                                FavoriteRow_PM(item: item, onRemove: { removeFromFavorites(item) })
                                            }
                                        } else if let tip = viewModel.content.tips.first(where: { $0.id == item.id }) {
                                            NavigationLink(destination: StrategyTipDetailView_PM(tip: tip)) {
                                                FavoriteRow_PM(item: item, onRemove: { removeFromFavorites(item) })
                                            }
                                        } else if let match = viewModel.content.historyMatches.first(where: { $0.id == item.id }) {
                                            NavigationLink(destination: HistoryMatchDetailView_PM(match: match)) {
                                                FavoriteRow_PM(item: item, onRemove: { removeFromFavorites(item) })
                                            }
                                        } else {
                                            FavoriteRow_PM(item: item, onRemove: { removeFromFavorites(item) })
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        Spacer().frame(height: adaptyH(100))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                }
                .overlay {
                    if favorites.isEmpty {
                        ContentUnavailableView {
                            Label("No Favorites", systemImage: "star.slash")
                                .foregroundStyle(Colors_PM.gold)
                        } description: {
                            Text("Add items to see them here.")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func removeFromFavorites(_ item: FavoriteItem) {
        modelContext.delete(item)
        try? modelContext.save()
    }
}

struct FavoriteRow_PM: View {
    let item: FavoriteItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: adaptyH(6)) {
                Text(item.category.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Colors_PM.neonGreen)
                
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text(item.dateAdded, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "star.fill")
                    .foregroundColor(Colors_PM.gold)
                    .padding()
            }
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
