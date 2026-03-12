import SwiftUI

struct PassScenario_PM {
    let id: Int
    let title: String
    let offsets: [CGSize]
    let options: [PassOption_PM]
}

struct PassOption_PM {
    let id: Int
    let desc: String
    let correct: Bool
    let feedback: String
}

struct PassDecisionSimulatorView_PM: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    @State private var currentScenarioIndex = 0
    @State private var selectedPass: Int? = nil
    @State private var showingResult = false
    
    private let scenarios = [
        PassScenario_PM(
            id: 1,
            title: "COUNTER ATTACK",
            offsets: [CGSize(width: -80, height: -100), CGSize(width: 50, height: -120), CGSize(width: -10, height: 100)],
            options: [
                PassOption_PM(id: 0, desc: "Through ball to striker", correct: true, feedback: "Excellent vision! The defensive line was high and vulnerable to a through ball."),
                PassOption_PM(id: 1, desc: "Back pass to center back", correct: false, feedback: "Too conservative. You lost the attacking momentum."),
                PassOption_PM(id: 2, desc: "Cross to right winger", correct: false, feedback: "The winger is marked by two defenders. High risk of interception.")
            ]
        ),
        PassScenario_PM(
            id: 2,
            title: "WING ATTACK",
            offsets: [CGSize(width: -140, height: -60), CGSize(width: 140, height: -60), CGSize(width: 0, height: -140)],
            options: [
                PassOption_PM(id: 0, desc: "Short pass to left winger", correct: false, feedback: "The defender is closing in fast. Interception risk."),
                PassOption_PM(id: 1, desc: "Switch play to right winger", correct: true, feedback: "Great switch! The right side is completely open."),
                PassOption_PM(id: 2, desc: "Long ball to target man", correct: false, feedback: "The striker is isolated between three defenders.")
            ]
        ),
        PassScenario_PM(
            id: 3,
            title: "MIDFIELD BUILDUP",
            offsets: [CGSize(width: -40, height: -40), CGSize(width: 50, height: 40), CGSize(width: -20, height: 120)],
            options: [
                PassOption_PM(id: 0, desc: "Quick 1-2 with playmaker", correct: true, feedback: "Perfect triangle! You've bypassed the midfield press."),
                PassOption_PM(id: 1, desc: "Long ball forward", correct: false, feedback: "Low percentage pass. Possession lost easily."),
                PassOption_PM(id: 2, desc: "Dribble into the crowd", correct: false, feedback: "You got tackled. Always look for the open man.")
            ]
        ),
        PassScenario_PM(
            id: 4,
            title: "FINAL THIRD",
            offsets: [CGSize(width: 80, height: -130), CGSize(width: 10, height: -150), CGSize(width: -70, height: -110)],
            options: [
                PassOption_PM(id: 0, desc: "Cross to far post", correct: false, feedback: "The keeper intercepted the high ball."),
                PassOption_PM(id: 1, desc: "Low cutback to edge of box", correct: true, feedback: "Brilliant! The late runner has a clear shot at goal."),
                PassOption_PM(id: 2, desc: "Direct shot at goal", correct: false, feedback: "Blocked by the sliding defender.")
            ]
        ),
        PassScenario_PM(
            id: 5,
            title: "DEEP BREAKOUT",
            offsets: [CGSize(width: -100, height: -50), CGSize(width: 100, height: -50), CGSize(width: 0, height: -180)],
            options: [
                PassOption_PM(id: 0, desc: "Diagonal ball to winger", correct: false, feedback: "The ball stayed in the air too long, defender recovered."),
                PassOption_PM(id: 1, desc: "Safety pass to fullback", correct: false, feedback: "Missed the chance to catch them on the break."),
                PassOption_PM(id: 2, desc: "Direct vertical pass", correct: true, feedback: "Elite transition! You've split their defense in two.")
            ]
        )
    ]
    
    var currentScenario: PassScenario_PM {
        scenarios[currentScenarioIndex]
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "PASS SIMULATOR", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Text(currentScenario.title)
                    .font(.caption).bold().tracking(3)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, adaptyH(10))
                
                PassDecisionFieldView_PM(playerOffsets: currentScenario.offsets)
                
                ScrollView{
                    if showingResult {
                        ResultView(
                            isSuccess: currentScenario.options[selectedPass ?? 0].correct,
                            feedback: currentScenario.options[selectedPass ?? 0].feedback,
                            onNext: nextScenario
                        )
                    } else {
                        VStack(spacing: adaptyH(12)) {
                            Text("SELECT PASS OPTION")
                                .font(.caption).bold().tracking(2).foregroundColor(Colors_PM.accentBlue)
                            
                            ForEach(currentScenario.options, id: \.id) { opt in
                                Button(action: {
                                    selectedPass = opt.id
                                    checkResult()
                                }) {
                                    HStack(spacing: adaptyW(15)) {
                                        ZStack {
                                            Circle()
                                                .fill(Colors_PM.accentBlue)
                                                .frame(width: adaptyW(32), height: adaptyH(32))
                                            Text("\(opt.id + 1)")
                                                .font(.headline).bold()
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text(opt.desc)
                                            .font(.subheadline).bold()
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    .padding()
                                    .background(Colors_PM.cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Colors_PM.accentBlue.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, 50)
                
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private func checkResult() {
        withAnimation {
            showingResult = true
        }
    }
    
    private func nextScenario() {
        withAnimation {
            if currentScenarioIndex < scenarios.count - 1 {
                currentScenarioIndex += 1
                selectedPass = nil
                showingResult = false
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct PlayerNodeView: View {
    let number: Int
    let isTarget: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isTarget ? Colors_PM.accentBlue : Colors_PM.gold)
                .frame(width: adaptyW(30), height: adaptyH(30))
                .shadow(color: isTarget ? Colors_PM.accentBlue : Colors_PM.gold, radius: 5)
            
            Text("\(number)")
                .font(.caption).bold().foregroundColor(.black)
        }
    }
}

struct ResultView: View {
    let isSuccess: Bool
    let feedback: String
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: adaptyH(20)) {
            Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(isSuccess ? Colors_PM.neonGreen : .red)
            
            Text(isSuccess ? "BRILLIANT DECISION!" : "POOR CHOICE")
                .font(.title2).bold().tracking(2).foregroundColor(.white)
            
            Text(feedback)
                .font(.body).foregroundColor(.gray).multilineTextAlignment(.center)
            
            Button(action: onNext) {
                Text("NEXT SCENARIO")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Colors_PM.accentBlue)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(20)
        .padding()
    }
}
