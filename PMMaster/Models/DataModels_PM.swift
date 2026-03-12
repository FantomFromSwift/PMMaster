import Foundation

struct Article: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let category: String
    let readTime: String
    let author: String
    let coverImage: String
}

struct TrainingTask: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let steps: [TaskStep]
    let difficulty: String
    let xpReward: Int
}

struct TaskStep: Codable, Identifiable {
    let id: String
    let instruction: String
    let image: String?
}

struct StrategyTip: Codable, Identifiable {
    let id: String
    let title: String
    let summary: String
    let fullText: String
}

struct HistoryMatch: Codable, Identifiable {
    let id: String
    let teams: String
    let score: String
    let analysisText: String
    let keyMomentImage: String
}

struct AppContent {
    var articles: [Article] = []
    var tasks: [TrainingTask] = []
    var tips: [StrategyTip] = []
    var historyMatches: [HistoryMatch] = []
}

class ContentLoader {
    static let shared = ContentLoader()
    
    private init() {}
    
    func loadContent() -> AppContent {
        var content = AppContent()
        
        if let articlesData = readJSON(filename: "articles") {
            content.articles = (try? JSONDecoder().decode([Article].self, from: articlesData)) ?? []
        }
        
        if let tasksData = readJSON(filename: "tasks") {
            content.tasks = (try? JSONDecoder().decode([TrainingTask].self, from: tasksData)) ?? []
        }
        
        if let tipsData = readJSON(filename: "tips") {
            content.tips = (try? JSONDecoder().decode([StrategyTip].self, from: tipsData)) ?? []
        }
        
        if let historyData = readJSON(filename: "history_matches") {
            content.historyMatches = (try? JSONDecoder().decode([HistoryMatch].self, from: historyData)) ?? []
        }
        
        return content
    }
    
    private func readJSON(filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
