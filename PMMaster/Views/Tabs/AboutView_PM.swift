import SwiftUI

struct AboutView_PM: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "ABOUT PM MASTER", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(spacing: adaptyH(40)) {
                        Image(systemName: "soccerball.inverse")
                            .font(.system(size: 80))
                            .foregroundColor(Colors_PM.neonGreen)
                            .shadow(color: Colors_PM.neonGreen.opacity(0.8), radius: 20)
                            .padding(.top, adaptyH(40))
                        
                        Text("PM MASTER")
                            .font(.system(size: 28, weight: .black, design: .default))
                            .foregroundColor(.white)
                            .tracking(4)
                        
                        Text("Version 1.0.0")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        Text("The ultimate tactical laboratory for football strategists. Test, build, and adapt your formations in a fully simulated environment.")
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, adaptyW(40))
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
}
