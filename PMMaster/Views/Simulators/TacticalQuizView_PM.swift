import SwiftUI

struct TacticalQuizView_PM: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showingResult = false
    
    let questions = [
        (q: "Which formation counters a standard 4-3-3 effectively?", ans: ["3-5-2", "4-4-2", "4-2-3-1"], correctIndex: 0),
        (q: "What is the primary role of a 'False 9'?", ans: ["Hold up play", "Drop deep to link midfield and attack", "Stay on the shoulder of the last defender"], correctIndex: 1),
        (q: "Which pressing trigger is most common?", ans: ["Ball passed backwards", "Goalkeeper has the ball", "Striker receives ball"], correctIndex: 0),
        (q: "In a low block, the defensive line is positioned:", ans: ["At midfield", "Near the edge of their own penalty box", "At the opponent's third"], correctIndex: 1)
    ]
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "TACTICAL EXAM", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                if showingResult {
                    quizResultView
                } else {
                    quizPlayView
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private var quizPlayView: some View {
        VStack(spacing: adaptyH(40)) {
            
            HStack {
                Text("QUESTION \(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.caption).bold().foregroundColor(Colors_PM.accentBlue)
                Spacer()
                Text("SCORE: \(score)")
                    .font(.caption).bold().foregroundColor(Colors_PM.gold)
            }
            .padding(.horizontal, adaptyW(40))
            .padding(.top, adaptyH(20))
            
            Text(questions[currentQuestionIndex].q)
                .font(.title2).bold().foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, adaptyW(30))
                .padding(.vertical, adaptyH(40))
            
            VStack(spacing: adaptyH(16)) {
                ForEach(0..<questions[currentQuestionIndex].ans.count, id: \.self) { idx in
                    Button(action: { submitAnswer(idx) }) {
                        Text(questions[currentQuestionIndex].ans[idx])
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Colors_PM.cardBackground)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, adaptyW(30))
            
            Spacer()
        }
    }
    
    private var quizResultView: some View {
        VStack(spacing: adaptyH(30)) {
            Spacer()
            
            Image(systemName: score == questions.count ? "star.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(Colors_PM.gold)
            
            Text("EXAM COMPLETED")
                .font(.title).bold().tracking(2).foregroundColor(.white)
            
            Text("Final Score: \(score) / \(questions.count)")
                .font(.largeTitle).bold().foregroundColor(Colors_PM.neonGreen)
            
            Spacer()
            
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("FINISH")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Colors_PM.gold)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, adaptyW(40))
            .padding(.bottom, adaptyH(60))
        }
    }
    
    private func submitAnswer(_ selectedIndex: Int) {
        if selectedIndex == questions[currentQuestionIndex].correctIndex {
            score += 1
        }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showingResult = true
        }
    }
}
