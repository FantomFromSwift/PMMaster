import SwiftUI

struct SplashViewCR: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var glowIntensity: Double = 0.0
    let theme: ThemeCR
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 100))
                    .foregroundColor(theme.accentColor)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .shadow(color: theme.accentColor.opacity(glowIntensity), radius: 40, x: 0, y: 0)
                
                Text("CR: Care the Roast")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(theme.textPrimary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowIntensity = 0.8
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.3)) {
                    opacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    SplashViewCR(theme: ThemeManagerCR.shared.themes[0], onComplete: {})
}
