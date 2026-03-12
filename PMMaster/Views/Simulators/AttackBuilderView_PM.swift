import SwiftUI

struct AttackBuilderView_PM: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    @State private var showingRating = false
    @State private var arrowsDrawn = 0
    @State private var rating = 0
    
    @State private var positions: [CGPoint] = [
        CGPoint(x: 150, y: 550),
        CGPoint(x: 50, y: 350),
        CGPoint(x: 250, y: 350),
        CGPoint(x: 150, y: 250)
    ]
    
    @State private var lines: [LineParams] = []
    
    struct LineParams: Identifiable {
        let id = UUID()
        let start: CGPoint
        let end: CGPoint
    }
    
    @State private var currentStartPoint: CGPoint?
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "ATTACK BUILDER", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Text(showingRating ? "OUTCOME PREDICTED" : "DRAW PASSING SEQUENCE")
                    .font(.caption).bold().tracking(2)
                    .foregroundColor(showingRating ? Colors_PM.gold : Colors_PM.neonGreen)
                    .padding(.top, adaptyH(20))
                
                GeometryReader { geo in
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(red: 0.1, green: 0.4, blue: 0.2)) // Grass green
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.5), lineWidth: 2))
                        
                        
                        ForEach(lines) { line in
                            ArrowLine(start: line.start, end: line.end)
                                .stroke(Colors_PM.neonGreen, lineWidth: 3)
                        }
                        
                        
                        ForEach(0..<4) { idx in
                            Circle()
                                .fill(Colors_PM.accentBlue)
                                .frame(width: adaptyW(40), height: adaptyH(40))
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                                .position(positions[idx])
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            
                                            if currentStartPoint == nil {
                                                currentStartPoint = positions[idx]
                                            }
                                        }
                                        .onEnded { value in
                                            if let start = currentStartPoint {
                                                let end = value.location
                                                lines.append(LineParams(start: start, end: end))
                                                currentStartPoint = nil
                                                arrowsDrawn += 1
                                            }
                                        }
                                )
                        }
                    }
                    .padding()
                }
                
                if showingRating {
                    VStack {
                        Text("TACTICAL RATING: \(rating) / 100")
                            .font(.title2).bold().foregroundColor(Colors_PM.gold)
                        
                        Button(action: {
                            lines.removeAll()
                            arrowsDrawn = 0
                            showingRating = false
                        }) {
                            Text("RESET")
                                .font(.headline).foregroundColor(.black)
                                .frame(maxWidth: .infinity).padding()
                                .background(Colors_PM.accentBlue).clipShape(Capsule())
                        }
                        .padding(.top, adaptyH(10))
                    }
                    .padding()
                } else {
                    Button(action: { finishSimulation() }) {
                        Text("RUN SIMULATION")
                            .font(.headline).foregroundColor(.black)
                            .frame(maxWidth: .infinity).padding()
                            .background(lines.isEmpty ? Color.gray : Colors_PM.neonGreen).clipShape(Capsule())
                    }
                    .padding()
                    .disabled(lines.isEmpty)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private func finishSimulation() {
        showingRating = true
        if arrowsDrawn >= 3 {
            rating = Int.random(in: 80...98)
        } else {
            rating = Int.random(in: 40...70)
        }
    }
}

struct ArrowLine: Shape {
    var start: CGPoint
    var end: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}
