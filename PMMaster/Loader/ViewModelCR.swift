import SwiftUI
import Combine

class ViewModelCR: ObservableObject {
    @Published var hasCompletedOnboarding: Bool
    @Published var currentTheme: String
    @Published var studyFocusKnowledgeLayers: Set<String>
    @Published var studyFocusRituals: Set<String>
    @Published var masteredRituals: Set<String>
    @Published var ritualProgress: [String: Int]
    @Published var totalPhasesCompleted: Int
    @Published var domainsExplored: Set<String>
    @Published var purchasedThemes: Set<String>
    
    private let persistence = PersistenceCR()
    
    init() {
        self.hasCompletedOnboarding = persistence.loadOnboardingStatus()
        self.currentTheme = persistence.loadTheme()
        self.studyFocusKnowledgeLayers = persistence.loadStudyFocusKnowledgeLayers()
        self.studyFocusRituals = persistence.loadStudyFocusRituals()
        self.masteredRituals = persistence.loadMasteredRituals()
        self.ritualProgress = persistence.loadRitualProgress()
        self.totalPhasesCompleted = persistence.loadTotalPhases()
        self.domainsExplored = persistence.loadDomainsExplored()
        self.purchasedThemes = persistence.loadPurchasedThemes()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        persistence.saveOnboardingStatus(true)
    }
    
    func setTheme(_ theme: String) {
        currentTheme = theme
        persistence.saveTheme(theme)
    }
    
    func toggleStudyFocusKnowledgeLayer(_ id: String) {
        if studyFocusKnowledgeLayers.contains(id) {
            studyFocusKnowledgeLayers.remove(id)
        } else {
            studyFocusKnowledgeLayers.insert(id)
        }
        persistence.saveStudyFocusKnowledgeLayers(studyFocusKnowledgeLayers)
    }
    
    func toggleStudyFocusRitual(_ id: String) {
        if studyFocusRituals.contains(id) {
            studyFocusRituals.remove(id)
        } else {
            studyFocusRituals.insert(id)
        }
        persistence.saveStudyFocusRituals(studyFocusRituals)
    }
    
    func updateRitualProgress(_ ritualId: String, phase: Int) {
        ritualProgress[ritualId] = phase
        persistence.saveRitualProgress(ritualProgress)
    }
    
    func completeRitualAndLogCapability(_ ritualId: String, domain: String) {
        masteredRituals.insert(ritualId)
        domainsExplored.insert(domain)
        totalPhasesCompleted += (ritualProgress[ritualId] ?? 0)
        ritualProgress.removeValue(forKey: ritualId)
        
        persistence.saveMasteredRituals(masteredRituals)
        persistence.saveDomainsExplored(domainsExplored)
        persistence.saveTotalPhases(totalPhasesCompleted)
        persistence.saveRitualProgress(ritualProgress)
    }
    
    func purchaseTheme(_ themeId: String) {
        purchasedThemes.insert(themeId)
        persistence.savePurchasedThemes(purchasedThemes)
    }
    
    func restorePurchases(_ themeIds: Set<String>) {
        purchasedThemes = themeIds
        persistence.savePurchasedThemes(purchasedThemes)
    }
    
    func isThemePurchased(_ themeId: String) -> Bool {
        purchasedThemes.contains(themeId)
    }
    
    func getCapabilityState(for domain: String) -> String {
        let ritualsInDomain = PracticeRitualModelCR.allPracticeRituals.filter { $0.trainingDomain == domain }
        let masteredCount = ritualsInDomain.filter { masteredRituals.contains($0.id) }.count
        
        switch masteredCount {
        case 0:
            return "Initial Phase"
        case 1...3:
            return "Baseline Capability"
        case 4...7:
            return "Intermediate Control"
        case 8...12:
            return "Advanced Regulation"
        default:
            return "Expert Stability"
        }
    }
    
    func getTotalRitualsMastered() -> Int {
        masteredRituals.count
    }
    
    func getRecommendedNextRitual() -> PracticeRitualModelCR? {
        let availableRituals = PracticeRitualModelCR.allPracticeRituals.filter { !masteredRituals.contains($0.id) }
        return availableRituals.first { $0.precisionLevel == "Foundation" } ?? availableRituals.first
    }
}
