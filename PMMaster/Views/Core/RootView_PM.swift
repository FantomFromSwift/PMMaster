import SwiftUI
import SwiftData
import StoreKit

struct RootView_PM: View {
    @State private var viewModel = MainViewModel.shared
    @State private var iapManager = IAPManagerVE.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            FavoriteItem.self,
            CompletedTask.self,
            TrainingSession.self,
            StrategyBoard.self,
            MatchScenarioResult.self,
            JournalNote.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some View {
        Group {
            switch viewModel.currentScreen {
            case .splash:
                SplashView_PM()
            case .onboarding:
                OnboardingView_PM()
            case .mainFlow:
                MainTabView_PM()
            }
        }
        .environment(viewModel)
        .environment(iapManager)
        .modelContainer(sharedModelContainer)
    }
}

@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        SKPaymentQueue.default().add(IAPManagerVE.shared)
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(IAPManagerVE.shared)
    }
}
