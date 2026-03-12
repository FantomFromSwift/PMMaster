import SwiftUI
import SwiftData
import Observation

enum AppScreen {
    case splash
    case onboarding
    case mainFlow
}

@Observable
final class MainViewModel {
    static let shared = MainViewModel()
    
    var currentScreen: AppScreen = .splash
    var content: AppContent = AppContent()
    
    var selectedTab: Int = 0
    
    var shouldPopTaskFlowToRoot: Bool = false
    
    @ObservationIgnored @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @ObservationIgnored private static let selectedThemeKey = "selectedTheme"
    private var _selectedTheme: String = "Neon Stadium"
    var selectedTheme: String {
        get { _selectedTheme }
        set {
            _selectedTheme = newValue
            UserDefaults.standard.set(newValue, forKey: Self.selectedThemeKey)
        }
    }
    @ObservationIgnored @AppStorage("appUsername") var appUsername: String = "Coach"

     init() {
        _selectedTheme = UserDefaults.standard.string(forKey: Self.selectedThemeKey) ?? "Neon Stadium"
    }
    
    func loadApp() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            DispatchQueue.main.async {
                self.content = ContentLoader.shared.loadContent()
                if self.hasSeenOnboarding {
                    self.currentScreen = .mainFlow
                } else {
                    self.currentScreen = .onboarding
                }
            }
        }
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        currentScreen = .mainFlow
    }
}
