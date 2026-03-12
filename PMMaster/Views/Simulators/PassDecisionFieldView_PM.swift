import SwiftUI

struct PassDecisionFieldView_PM: View {
    let playerOffsets: [CGSize]
    private let nodeRadius: CGFloat = 18
    
    @State private var animatedOffsets: [CGSize] = []
    
    var body: some View {
        GeometryReader { geo in
            let maxW = geo.size.width / 2 - nodeRadius
            let maxH = geo.size.height / 2 - nodeRadius
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.2), lineWidth: 2)
                    )
                
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 2)
                    .frame(width: adaptyW(80), height: adaptyH(80))
                
                ForEach(0..<playerOffsets.count, id: \.self) { i in
                    PlayerNodeView(number: i + 1, isTarget: true)
                        .offset(clampedOffset(animatedOffsets.indices.contains(i) ? animatedOffsets[i] : (playerOffsets.indices.contains(i) ? playerOffsets[i] : .zero), maxW: maxW, maxH: maxH))
                }
                
                PlayerNodeView(number: 10, isTarget: false)
                    .scaleEffect(1.2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: adaptyH(300))
        .padding()
        .onAppear { 
            animatedOffsets = playerOffsets
            animatePlayers() 
        }
        .onChange(of: playerOffsets) { _, newValue in
            animatedOffsets = newValue
            animatePlayers()
        }
    }
    
    private func clampedOffset(_ size: CGSize, maxW: CGFloat, maxH: CGFloat) -> CGSize {
        CGSize(
            width: min(max(size.width, -maxW), maxW),
            height: min(max(size.height, -maxH), maxH)
        )
    }
    
    private func animatePlayers() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            if animatedOffsets.count > 0 {
                animatedOffsets[0].width += 20
                animatedOffsets[0].height -= 30
            }
            if animatedOffsets.count > 1 {
                animatedOffsets[1].width -= 15
            }
            if animatedOffsets.count > 2 {
                animatedOffsets[2].height += 20
            }
        }
    }
}
