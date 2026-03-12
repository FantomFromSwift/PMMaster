import SwiftUI

struct DefenseReactionTrainerView_PM: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    @State private var timeRemaining = 5
    @State private var timer: Timer?
    @State private var score = 0
    @State private var round = 1
    @State private var isGameOver = false
    
    @State private var currentScenario = ""
    @State private var showFeedback = false
    @State private var isSuccess = false
    
    let scenarios = [
        "Opponent striker receives ball in box with back to goal.",
        "Winger sprinting down the line, preparing to cross.",
        "Midfielder winding up for a long shot.",
        "Counter attack: 2 attackers vs 1 defender (you)."
    ]
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "DEFENSE REFLEXES", showBackButton: true) {
                    endGame()
                    presentationMode.wrappedValue.dismiss()
                }
                ScrollView {
                    if isGameOver {
                        gameOverView
                    } else {
                        gamePlayView
                    }
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
                
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
        .onAppear {
            startGame()
        }
        .onDisappear {
            endGame()
        }
    }
    
    private var gamePlayView: some View {
        VStack(spacing: adaptyH(30)) {
            HStack {
                VStack(alignment: .leading) {
                    Text("SCORE").font(.caption).foregroundColor(.gray)
                    Text("\(score)").font(.title).bold().foregroundColor(Colors_PM.gold)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("TIME").font(.caption).foregroundColor(.gray)
                    Text("\(timeRemaining)s")
                        .font(.title).bold()
                        .foregroundColor(timeRemaining <= 2 ? .red : Colors_PM.accentBlue)
                }
            }
            .padding(.horizontal, adaptyW(30))
            .padding(.top, adaptyH(20))
            
            ZStack {
                Circle()
                    .stroke(Colors_PM.accentBlue.opacity(0.3), lineWidth: 10)
                    .frame(width: adaptyW(200), height: adaptyH(200))
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / 5.0)
                    .stroke(timeRemaining <= 2 ? Color.red : Colors_PM.neonGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: adaptyW(200), height: adaptyH(200))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1.0), value: timeRemaining)
                
                Image(systemName: "shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Colors_PM.accentBlue)
            }
            .padding(.vertical, adaptyH(20))
            
            VStack(spacing: adaptyH(16)) {
                Text("SCENARIO \(round)")
                    .font(.caption).bold().tracking(2).foregroundColor(Colors_PM.gold)
                
                Text(currentScenario)
                    .font(.title3).bold().foregroundColor(.white).multilineTextAlignment(.center)
            }
            .padding(.horizontal, adaptyW(40))
            
            Spacer()
            
            VStack(spacing: adaptyH(16)) {
                ReactionButton(title: "Slide Tackle", color: .red) { makeChoice(isCorrect: Int.random(in: 0...2) == 0) }
                ReactionButton(title: "Jockey / Contain", color: Colors_PM.neonGreen) { makeChoice(isCorrect: Int.random(in: 0...1) == 0) }
                ReactionButton(title: "Offside Trap", color: Colors_PM.accentBlue) { makeChoice(isCorrect: Int.random(in: 0...2) == 1) }
            }
            .padding(.horizontal, adaptyW(30))
            .padding(.bottom, adaptyH(40))
            .disabled(showFeedback)
        }
    }
    
    private var gameOverView: some View {
        VStack(spacing: adaptyH(30)) {
            Spacer()
            
            Image(systemName: "flag.checkered")
                .font(.system(size: 100))
                .foregroundColor(Colors_PM.gold)
            
            Text("TRAINING COMPLETE")
                .font(.title).bold().tracking(2).foregroundColor(.white)
            
            Text("Final Score: \(score)")
                .font(.largeTitle).bold().foregroundColor(Colors_PM.neonGreen)
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("RETURN TO LAB")
                    .font(.headline).foregroundColor(.black)
                    .frame(maxWidth: .infinity).padding().background(Colors_PM.gold).clipShape(Capsule())
            }
            .padding(.horizontal, adaptyW(40))
            .padding(.bottom, adaptyH(60))
        }
    }
    
    private func startGame() {
        score = 0
        round = 1
        isGameOver = false
        loadScenario()
    }
    
    private func loadScenario() {
        currentScenario = scenarios.randomElement()!
        timeRemaining = 5
        showFeedback = false
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                
                timer?.invalidate()
                makeChoice(isCorrect: false)
            }
        }
    }
    
    private func makeChoice(isCorrect: Bool) {
        timer?.invalidate()
        showFeedback = true
        self.isSuccess = isCorrect
        if isCorrect {
            score += 100 + (timeRemaining * 20)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if round < 5 {
                round += 1
                loadScenario()
            } else {
                withAnimation {
                    isGameOver = true
                }
            }
        }
    }
    
    private func endGame() {
        timer?.invalidate()
    }
}

struct ReactionButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(color == Colors_PM.neonGreen ? .black : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, adaptyH(16))
                .background(color == Colors_PM.neonGreen ? color : Colors_PM.cardBackground)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(color == Colors_PM.neonGreen ? .clear : color, lineWidth: 2))
        }
    }
}
