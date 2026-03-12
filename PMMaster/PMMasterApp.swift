import SwiftUI
import SwiftData

@main
struct PMMasterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            RootViewMC()
                .environmentObject(ViewModelCR())
                .environmentObject(LoaderViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
