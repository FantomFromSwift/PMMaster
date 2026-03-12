import Foundation
import SwiftData

@Model
final class UserProfile {
    var username: String
    var favoriteTeam: String
    var theme: String
    var createdAt: Date

    init(username: String = "Coach", favoriteTeam: String = "Select Team", theme: String = "Neon Stadium", createdAt: Date = Date()) {
        self.username = username
        self.favoriteTeam = favoriteTeam
        self.theme = theme
        self.createdAt = createdAt
    }
}

@Model
final class FavoriteItem {
    @Attribute(.unique) var id: String
    var title: String
    var category: String
    var dateAdded: Date

    init(id: String, title: String, category: String, dateAdded: Date = Date()) {
        self.id = id
        self.title = title
        self.category = category
        self.dateAdded = dateAdded
    }
}

@Model
final class CompletedTask {
    @Attribute(.unique) var taskId: String
    var dateCompleted: Date
    var score: Int

    init(taskId: String, dateCompleted: Date = Date(), score: Int) {
        self.taskId = taskId
        self.dateCompleted = dateCompleted
        self.score = score
    }
}

@Model
final class TrainingSession {
    var date: Date
    var mode: String
    var resultScore: Int
    var duration: Int

    init(date: Date = Date(), mode: String, resultScore: Int, duration: Int) {
        self.date = date
        self.mode = mode
        self.resultScore = resultScore
        self.duration = duration
    }
}

@Model
final class StrategyBoard {
    @Attribute(.unique) var id: String
    var formationName: String
    var savedPositions: Data
    var dateCreated: Date

    init(id: String = UUID().uuidString, formationName: String, savedPositions: Data, dateCreated: Date = Date()) {
        self.id = id
        self.formationName = formationName
        self.savedPositions = savedPositions
        self.dateCreated = dateCreated
    }
}

@Model
final class MatchScenarioResult {
    var scenarioId: String
    var decisionPath: String
    var resultRating: Int

    init(scenarioId: String, decisionPath: String, resultRating: Int) {
        self.scenarioId = scenarioId
        self.decisionPath = decisionPath
        self.resultRating = resultRating
    }
}

@Model
final class JournalNote {
    @Attribute(.unique) var id: String
    var title: String
    var text: String
    var category: String
    var date: Date
    var isFavorite: Bool

    init(id: String = UUID().uuidString, title: String, text: String, category: String = "My Tactical Notes", date: Date = Date(), isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.text = text
        self.category = category
        self.date = date
        self.isFavorite = isFavorite
    }
}
