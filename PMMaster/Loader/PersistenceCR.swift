import Foundation

class PersistenceCR {
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let onboarding = "hasCompletedOnboarding"
        static let theme = "currentTheme"
        static let studyFocusKnowledgeLayers = "favoriteArticles"
        static let studyFocusRituals = "favoriteTasks"
        static let masteredRituals = "completedTasks"
        static let ritualProgress = "taskProgress"
        static let totalPhases = "totalStepsCompleted"
        static let domainsExplored = "roastTypesCompleted"
        static let purchasedThemes = "purchasedThemes"
    }
    
    func loadOnboardingStatus() -> Bool {
        defaults.bool(forKey: Keys.onboarding)
    }
    
    func saveOnboardingStatus(_ status: Bool) {
        defaults.set(status, forKey: Keys.onboarding)
    }
    
    func loadTheme() -> String {
        defaults.string(forKey: Keys.theme) ?? "warm_glow"
    }
    
    func saveTheme(_ theme: String) {
        defaults.set(theme, forKey: Keys.theme)
    }
    
    func loadStudyFocusKnowledgeLayers() -> Set<String> {
        if let data = defaults.data(forKey: Keys.studyFocusKnowledgeLayers),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            return decoded
        }
        return []
    }
    
    func saveStudyFocusKnowledgeLayers(_ ids: Set<String>) {
        if let encoded = try? JSONEncoder().encode(ids) {
            defaults.set(encoded, forKey: Keys.studyFocusKnowledgeLayers)
        }
    }
    
    func loadStudyFocusRituals() -> Set<String> {
        if let data = defaults.data(forKey: Keys.studyFocusRituals),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            return decoded
        }
        return []
    }
    
    func saveStudyFocusRituals(_ ids: Set<String>) {
        if let encoded = try? JSONEncoder().encode(ids) {
            defaults.set(encoded, forKey: Keys.studyFocusRituals)
        }
    }
    
    func loadMasteredRituals() -> Set<String> {
        if let data = defaults.data(forKey: Keys.masteredRituals),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            return decoded
        }
        return []
    }
    
    func saveMasteredRituals(_ ids: Set<String>) {
        if let encoded = try? JSONEncoder().encode(ids) {
            defaults.set(encoded, forKey: Keys.masteredRituals)
        }
    }
    
    func loadRitualProgress() -> [String: Int] {
        if let data = defaults.data(forKey: Keys.ritualProgress),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            return decoded
        }
        return [:]
    }
    
    func saveRitualProgress(_ progress: [String: Int]) {
        if let encoded = try? JSONEncoder().encode(progress) {
            defaults.set(encoded, forKey: Keys.ritualProgress)
        }
    }
    
    func loadTotalPhases() -> Int {
        defaults.integer(forKey: Keys.totalPhases)
    }
    
    func saveTotalPhases(_ count: Int) {
        defaults.set(count, forKey: Keys.totalPhases)
    }
    
    func loadDomainsExplored() -> Set<String> {
        if let data = defaults.data(forKey: Keys.domainsExplored),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            return decoded
        }
        return []
    }
    
    func saveDomainsExplored(_ domains: Set<String>) {
        if let encoded = try? JSONEncoder().encode(domains) {
            defaults.set(encoded, forKey: Keys.domainsExplored)
        }
    }
    
    func loadPurchasedThemes() -> Set<String> {
        if let data = defaults.data(forKey: Keys.purchasedThemes),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            return decoded
        }
        return []
    }
    
    func savePurchasedThemes(_ themeIds: Set<String>) {
        if let encoded = try? JSONEncoder().encode(themeIds) {
            defaults.set(encoded, forKey: Keys.purchasedThemes)
        }
    }
}
