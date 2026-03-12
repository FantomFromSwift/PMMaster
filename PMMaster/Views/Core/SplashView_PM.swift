import SwiftUI

struct SplashView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @State private var circleScale: CGFloat = 0.5
    @State private var circleOpacity: Double = 0.0
    @State private var ballOffset: CGFloat = -100
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: adaptyH(40)) {
                ZStack {
                    Circle()
                        .stroke(Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.3), lineWidth: 2)
                        .frame(width: adaptyW(150), height: adaptyH(150))
                        .scaleEffect(circleScale)
                        .opacity(circleOpacity)
                    
                    Circle()
                        .stroke(Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.5), lineWidth: 4)
                        .frame(width: adaptyW(100), height: adaptyH(100))
                        .scaleEffect(circleScale * 1.2)
                        .opacity(circleOpacity)
                    
                    Image(systemName: "soccerball.inverse")
                        .resizable()
                        .scaledToFit()
                        .frame(width: adaptyW(60), height: adaptyH(60))
                        .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                        .shadow(color: Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.8), radius: 10, x: 0, y: 0)
                        .offset(y: ballOffset)
                }
                
                Text("PM MASTER")
                    .font(.system(size: 32, weight: .black, design: .default))
                    .foregroundColor(.white)
                    .tracking(4)
                    .opacity(circleOpacity)
                    .shadow(color: Colors_PM.accent(for: viewModel.selectedTheme), radius: 5, x: 0, y: 2)
                
                Text("TACTICAL LABORATORY")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .tracking(2)
                    .opacity(circleOpacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                circleScale = 1.0
                circleOpacity = 1.0
                ballOffset = 0
            }
            
            viewModel.loadApp()
        }
    }
}
