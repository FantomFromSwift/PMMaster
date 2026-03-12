import SwiftUI
import AppsFlyerLib

struct RootViewMC: View {
    @EnvironmentObject private var vm: LoaderViewModel
    @State private var viewModel = MainViewModel.shared
    var body: some View {
        ZStack {
            switch vm.presented {
            case .splash:
                SplashView_PM()

            case .main:
                RootView_PM()
                    .preferredColorScheme(.dark)

            case .changed:
                LoaderPageView(loaderViewModel: vm, url: vm.mailLink ?? vm.link)
                    .onAppear {
                        AppDelegate.orientationLock = [.portrait, .landscapeLeft, .landscapeRight]
                    }
            }
        }
        .environment(viewModel)
    }
}
