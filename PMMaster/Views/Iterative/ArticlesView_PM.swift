import SwiftUI
import SwiftData

struct ArticlesView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "TACTICAL LIBRARY", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    LazyVStack(spacing: adaptyH(16)) {
                        ForEach(viewModel.content.articles) { article in
                            NavigationLink(destination: ArticleDetailView_PM(article: article)) {
                                ArticleCard(article: article)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
}

struct ArticleCard: View {
    let article: Article
    
    var body: some View {
        HStack(spacing: adaptyW(16)) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Colors_PM.darkBackground)
                    .frame(width: adaptyW(80), height: adaptyH(80))
                
                Image(article.coverImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: adaptyW(80), height: adaptyH(80))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            
            VStack(alignment: .leading, spacing: adaptyH(6)) {
                Text(article.category.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Colors_PM.neonGreen)
                
                Text(article.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Image(systemName: "clock")
                    Text(article.readTime)
                }
                .font(.caption2)
                .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct ArticleDetailView_PM: View {
    let article: Article
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var viewModel
    
    @Query private var favorites: [FavoriteItem]
    
    private var isSaved: Bool {
        favorites.contains(where: { $0.id == article.id })
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: article.category.uppercased(), showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: adaptyH(24)) {
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .fill(LinearGradient(colors: [Colors_PM.accentBlue.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom))
                                .frame(height: adaptyH(250))
                            
                            VStack(alignment: .leading, spacing: adaptyH(12)) {
                                HStack(alignment: .center, spacing: adaptyW(16)) {
                                    Text(article.title)
                                        .font(.system(size: 28, weight: .black, design: .default))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .minimumScaleFactor(0.5)
                                    
                                    Spacer()
                                    
                                    Image(article.coverImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: adaptyW(180), height: adaptyH(180))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                                }
                                
                                HStack {
                                    Text("By \(article.author)")
                                        .font(.subheadline)
                                        .foregroundColor(Colors_PM.gold)
                                    Spacer()
                                    Text(article.readTime)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        }
                        
                        Text(article.content)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineSpacing(8)
                            .padding(.horizontal)
                        
                        Button(action: toggleFavorite) {
                            HStack {
                                Image(systemName: isSaved ? "star.fill" : "star")
                                Text(isSaved ? "Saved to Favorites" : "Save Article")
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
            .navigationBarHidden(true)
            .navigationBackWithSwipe()
        }
    }
    
    private func toggleFavorite() {
        if isSaved {
            if let item = favorites.first(where: { $0.id == article.id }) {
                modelContext.delete(item)
            }
        } else {
            let favItem = FavoriteItem(id: article.id, title: article.title, category: article.category)
            modelContext.insert(favItem)
        }
        try? modelContext.save()
    }
}
