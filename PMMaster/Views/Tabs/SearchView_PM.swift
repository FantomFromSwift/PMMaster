import SwiftUI

struct SearchView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    
    let filters = ["All", "Articles", "Tasks", "Tips", "History"]
    
    var filteredArticles: [Article] {
        guard selectedFilter == "All" || selectedFilter == "Articles" else { return [] }
        if searchText.isEmpty { return viewModel.content.articles }
        return viewModel.content.articles.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.category.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredTasks: [TrainingTask] {
        guard selectedFilter == "All" || selectedFilter == "Tasks" else { return [] }
        if searchText.isEmpty { return viewModel.content.tasks }
        return viewModel.content.tasks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredTips: [StrategyTip] {
        guard selectedFilter == "All" || selectedFilter == "Tips" else { return [] }
        if searchText.isEmpty { return viewModel.content.tips }
        return viewModel.content.tips.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredHistory: [HistoryMatch] {
        guard selectedFilter == "All" || selectedFilter == "History" else { return [] }
        if searchText.isEmpty { return viewModel.content.historyMatches }
        return viewModel.content.historyMatches.filter { $0.teams.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "DATA CENTER", showBackButton: false)
                
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Search database...", text: $searchText)
                        .foregroundColor(.white)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Colors_PM.cardBackground)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, adaptyH(10))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: { selectedFilter = filter }) {
                                Text(filter)
                                    .font(.caption)
                                    .bold()
                                    .padding(.horizontal, adaptyW(16))
                                    .padding(.vertical, adaptyH(8))
                                    .background(selectedFilter == filter ? Colors_PM.accent(for: viewModel.selectedTheme) : Colors_PM.cardBackground)
                                    .foregroundColor(selectedFilter == filter ? .black : .white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding()
                }
                
                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        if !filteredArticles.isEmpty {
                            SectionHeader(title: "ARTICLES")
                            ForEach(filteredArticles) { article in
                                NavigationLink(destination: ArticleDetailView_PM(article: article)) {
                                    SearchResultCard(title: article.title, subtitle: article.category, imageName: "art1")
                                }
                            }
                        }
                        
                        if !filteredTasks.isEmpty {
                            SectionHeader(title: "TRAINING TASKS")
                            ForEach(filteredTasks) { task in
                                NavigationLink(destination: TaskDetailsView_PM(task: task)) {
                                    SearchResultCard(title: task.title, subtitle: task.difficulty, imageName: "art2")
                                }
                            }
                        }
                        
                        if !filteredTips.isEmpty {
                            SectionHeader(title: "STRATEGY TIPS")
                            ForEach(filteredTips) { tip in
                                NavigationLink(destination: StrategyTipDetailView_PM(tip: tip)) {
                                    SearchResultCard(title: tip.title, subtitle: tip.summary, imageName: "art3")
                                }
                            }
                        }
                        
                        if !filteredHistory.isEmpty {
                            SectionHeader(title: "HISTORY MATCHES")
                            ForEach(filteredHistory) { match in
                                NavigationLink(destination: HistoryMatchDetailView_PM(match: match)) {
                                    SearchResultCard(title: match.teams, subtitle: match.score, imageName: "art4")
                                }
                            }
                        }
                        
                        Spacer().frame(height: adaptyH(100))
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SectionHeader: View {
    @Environment(MainViewModel.self) private var viewModel
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .bold()
                .tracking(2)
                .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
            Spacer()
        }
    }
}

struct SearchResultCard: View {
    @Environment(MainViewModel.self) private var viewModel
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: adaptyW(50), height: adaptyH(50))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: adaptyH(4)) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Colors_PM.surfaceColor)
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Colors_PM.surfaceColor, lineWidth: 1))
    }
}
