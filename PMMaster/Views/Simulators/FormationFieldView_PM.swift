import SwiftUI

struct FormationFieldView_PM: View {
    @Binding var positions: [CGPoint]
    
    private static let fieldWidth: CGFloat = 320
    private static let fieldHeight: CGFloat = 450
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 0.1, green: 0.4, blue: 0.2))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.5), lineWidth: 2))
                
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: (80 / Self.fieldWidth) * size.width, 
                           height: (80 / Self.fieldHeight) * size.height)
                
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: (2 / Self.fieldHeight) * size.height)
                
                VStack {
                    Rectangle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: (150 / Self.fieldWidth) * size.width, 
                               height: (80 / Self.fieldHeight) * size.height)
                    Spacer()
                    Rectangle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: (150 / Self.fieldWidth) * size.width, 
                               height: (80 / Self.fieldHeight) * size.height)
                }
                
                ForEach(0..<11, id: \.self) { idx in
                    playerCircle(index: idx, in: size)
                }
            }
        }
        .frame(width: adaptyW(Self.fieldWidth), height: adaptyH(Self.fieldHeight))
        .padding()
    }
    
    private func playerCircle(index: Int, in size: CGSize) -> some View {
        let x = (positions[index].x / Self.fieldWidth) * size.width
        let y = (positions[index].y / Self.fieldHeight) * size.height
        
        return ZStack {
            Circle()
                .fill(Colors_PM.gold)
                .frame(width: adaptyW(30), height: adaptyH(30))
                .shadow(radius: 5)
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
            
            Text("\(index + 1)")
                .font(.caption2)
                .bold()
                .foregroundColor(.black)
        }
        .position(x: x, y: y)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let newX = max(0, min(Self.fieldWidth, (value.location.x / size.width) * Self.fieldWidth))
                    let newY = max(0, min(Self.fieldHeight, (value.location.y / size.height) * Self.fieldHeight))
                    positions[index] = CGPoint(x: newX, y: newY)
                }
        )
    }
}

extension FormationFieldView_PM {
    static var defaultPositions: [CGPoint] {
        [
            CGPoint(x: 160, y: 400),
            CGPoint(x: 50, y: 330),
            CGPoint(x: 110, y: 330),
            CGPoint(x: 210, y: 330),
            CGPoint(x: 270, y: 330),
            CGPoint(x: 100, y: 250),
            CGPoint(x: 220, y: 250),
            CGPoint(x: 160, y: 190),
            CGPoint(x: 70, y: 110),
            CGPoint(x: 250, y: 110),
            CGPoint(x: 160, y: 70)
        ]
    }
}
