import SwiftUI
import SwiftData

struct MatchScenario_PM {
    let id: String
    let time: String
    let score: String
    let description: String
    let options: [MatchOption_PM]
}

struct MatchOption_PM {
    let code: String
    let text: String
    let rating: Int
    let outcome: String
}

struct MatchScenarioSimulatorView_PM: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    @State private var currentScenarioIndex = 0
    @State private var showingOutcome = false
    @State private var selectedOptionCode: String = ""
    @State private var rating: Int = 0
    
    private let scenarios = [
        MatchScenario_PM(
            id: "CounterAttack-89m",
            time: "89'",
            score: "1 - 1",
            description: "Your team just recovered the ball at the edge of your penalty area. The opponent pushed many players up for a corner kick. You have an opening for a counter-attack.",
            options: [
                MatchOption_PM(code: "A", text: "Long ball to the rapid winger making a run into space.", rating: 9, outcome: "The long ball bypassed the midfield trap perfectly, leading to a 1v1 situation. You scored the winning goal!"),
                MatchOption_PM(code: "B", text: "Build up slowly through the center to control possession.", rating: 5, outcome: "Building up slowly gave the opponent time to track back. The attack fizzled out, but you kept possession."),
                MatchOption_PM(code: "C", text: "Hold the ball near the corner flag to secure the draw.", rating: 2, outcome: "Playing it safe at 1-1 secured the draw, but you missed a golden opportunity to take all 3 points.")
            ]
        ),
        MatchScenario_PM(
            id: "DefendLead-93m",
            time: "93'",
            score: "2 - 1",
            description: "Final seconds. The opponent has a corner kick. Their goalkeeper is in your box. You need to defend this to win the trophy.",
            options: [
                MatchOption_PM(code: "A", text: "Zonal marking with all players in the six-yard box.", rating: 8, outcome: "Solid defensive shape! You cleared the ball and the referee blew the final whistle."),
                MatchOption_PM(code: "B", text: "Man-to-man marking on every opponent player.", rating: 6, outcome: "Risky. A scramble ensued, but your keeper luckily gathered the ball."),
                MatchOption_PM(code: "C", text: "Leave two players at the halfway line for a counter.", rating: 4, outcome: "Too many gaps in the box! They almost scored from a free header.")
            ]
        ),
        MatchScenario_PM(
            id: "MidfieldStruggle-55m",
            time: "55'",
            score: "0 - 1",
            description: "You're losing the midfield battle. Your players look exhausted and are losing 50/50 challenges.",
            options: [
                MatchOption_PM(code: "A", text: "Make two tactical substitutions to bring fresh energy.", rating: 10, outcome: "Perfect timing! The subs changed the tempo and you equalized within 10 minutes."),
                MatchOption_PM(code: "B", text: "Shout instructions to 'demand more' from the touchline.", rating: 4, outcome: "Motivation helped slightly, but physical fatigue is still the main issue."),
                MatchOption_PM(code: "C", text: "Switch to a more defensive formation to avoid conceding more.", rating: 3, outcome: "You invited even more pressure. The opponent dominated the rest of the game.")
            ]
        ),
        MatchScenario_PM(
            id: "PenaltyDrama-45m",
            time: "45+2'",
            score: "0 - 0",
            description: "You've been awarded a penalty just before halftime. Your regular taker is on a yellow card and looks nervous.",
            options: [
                MatchOption_PM(code: "A", text: "Trust your regular taker to step up and score.", rating: 7, outcome: "He scored, but it was a shaky penalty that nearly got saved."),
                MatchOption_PM(code: "B", text: "Let the experienced captain take the responsibility.", rating: 9, outcome: "Cool as ice. The captain buried it in the top corner. Great leadership."),
                MatchOption_PM(code: "C", text: "Let the young debutant take it to boost his confidence.", rating: 3, outcome: "The pressure was too much. He hit the post. Halftime mood is ruined.")
            ]
        ),
        MatchScenario_PM(
            id: "HighPress-75m",
            time: "75'",
            score: "1 - 1",
            description: "The opponent's defenders are struggling with the ball at their feet. They seem to be slowing down the game.",
            options: [
                MatchOption_PM(code: "A", text: "Initiate a high team press to force an error.", rating: 9, outcome: "The pressure worked! They gave the ball away in their own box and you scored!"),
                MatchOption_PM(code: "B", text: "Sit back and wait for them to make a mistake.", rating: 5, outcome: "They were happy to keep the ball. The game ended in a boring draw."),
                MatchOption_PM(code: "C", text: "Commit tactical fouls to disrupt their rhythm.", rating: 2, outcome: "You picked up three yellow cards and lost your defensive discipline.")
            ]
        )
    ]
    
    var currentScenario: MatchScenario_PM {
        scenarios[currentScenarioIndex]
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "MATCH SCENARIO", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(spacing: adaptyH(30)) {
                        
                        
                        VStack(spacing: adaptyH(12)) {
                            HStack {
                                Text(currentScenario.time)
                                    .font(.title).bold().foregroundColor(Colors_PM.gold)
                                Spacer()
                                Text("SCORE \(currentScenario.score)")
                                    .font(.title3).bold().foregroundColor(.white)
                            }
                            
                            Rectangle()
                                .fill(Colors_PM.accentBlue)
                                .frame(height: adaptyH(2))
                            
                            Text(currentScenario.description)
                                .font(.body)
                                .foregroundColor(.white)
                                .lineSpacing(6)
                                .padding(.top, adaptyH(10))
                        }
                        .padding()
                        .background(Colors_PM.cardBackground)
                        .cornerRadius(15)
                        
                        if showingOutcome {
                            outcomeView
                        } else {
                            optionsView
                        }
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private var optionsView: some View {
        VStack(alignment: .leading, spacing: adaptyH(16)) {
            Text("WHAT IS YOUR DECISION?")
                .font(.caption).bold().tracking(2).foregroundColor(Colors_PM.neonGreen)
            
            ForEach(currentScenario.options, id: \.code) { opt in
                Button(action: { selectOption(opt.code, rating: opt.rating) }) {
                    ScenarioOptionCard(letter: opt.code, text: opt.text)
                }
            }
        }
    }
    
    private var outcomeView: some View {
        VStack(spacing: adaptyH(20)) {
            Image(systemName: rating > 6 ? "star.circle.fill" : (rating > 3 ? "exclamationmark.circle.fill" : "xmark.octagon.fill"))
                .font(.system(size: 80))
                .foregroundColor(rating > 6 ? Colors_PM.neonGreen : (rating > 3 ? Colors_PM.gold : .red))
            
            Text(rating > 6 ? "EXCELLENT DECISION" : (rating > 3 ? "SAFE BUT SUBOPTIMAL" : "POOR EXECUTION"))
                .font(.title2).bold().foregroundColor(.white)
            
            Text("Decision Rating: \(rating) / 10")
                .font(.headline).foregroundColor(Colors_PM.accentBlue)
            
            Text(outcomeText)
                .font(.body).foregroundColor(.gray).multilineTextAlignment(.center)
            
            Button(action: nextScenario) {
                Text(currentScenarioIndex < scenarios.count - 1 ? "NEXT SCENARIO" : "FINISH SIMULATION")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Colors_PM.neonGreen)
                    .clipShape(Capsule())
            }
            .padding(.top, adaptyH(20))
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(20)
    }
    
    private func selectOption(_ code: String, rating: Int) {
        selectedOptionCode = code
        self.rating = rating
        showingOutcome = true
        
        let result = MatchScenarioResult(scenarioId: currentScenario.id, decisionPath: code, resultRating: rating)
        modelContext.insert(result)
        
        let session = TrainingSession(mode: "Match Scenario", resultScore: rating * 10, duration: 2)
        modelContext.insert(session)
        
        try? modelContext.save()
    }
    
    private func nextScenario() {
        withAnimation {
            if currentScenarioIndex < scenarios.count - 1 {
                currentScenarioIndex += 1
                showingOutcome = false
                selectedOptionCode = ""
                rating = 0
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var outcomeText: String {
        currentScenario.options.first(where: { $0.code == selectedOptionCode })?.outcome ?? ""
    }
}

struct ScenarioOptionCard: View {
    let letter: String
    let text: String
    
    var body: some View {
        HStack {
            Text(letter)
                .font(.title2).bold().foregroundColor(Colors_PM.accentBlue)
                .frame(width: adaptyW(40), height: adaptyH(40))
                .background(Colors_PM.darkBackground)
                .clipShape(Circle())
            
            Text(text)
                .font(.body).foregroundColor(.white)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Colors_PM.accentBlue.opacity(0.3), lineWidth: 1))
    }
}
