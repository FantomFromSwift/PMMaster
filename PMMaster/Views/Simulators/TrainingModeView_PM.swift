import SwiftUI
import SwiftData

struct TrainingModeView_PM: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var viewModel
    
    @State private var streak = 0
    @State private var showingReward = false
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "DAILY CHALLENGE", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                VStack(spacing: adaptyH(40)) {
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 80))
                            .foregroundColor(streak > 0 ? .orange : .gray)
                            .shadow(color: streak > 0 ? Color.orange.opacity(0.8) : .clear, radius: 20)
                        
                        VStack(alignment: .leading) {
                            Text("STREAK")
                                .font(.caption).bold().tracking(2).foregroundColor(.gray)
                            Text("\(streak) DAYS")
                                .font(.largeTitle).bold().foregroundColor(Colors_PM.gold)
                        }
                        .padding(.leading, adaptyW(20))
                    }
                    .padding(.top, adaptyH(40))
                    
                    if showingReward {
                        VStack {
                            Text("CHALLENGE COMPLETED")
                                .font(.title3).bold().foregroundColor(Colors_PM.neonGreen)
                            Text("+50 XP")
                                .font(.headline).foregroundColor(.white)
                        }
                        .padding()
                        .background(Colors_PM.cardBackground)
                        .cornerRadius(15)
                    } else {
                        VStack(spacing: adaptyH(20)) {
                            Text("TODAY's SCENARIO")
                                .font(.caption).bold().tracking(2).foregroundColor(Colors_PM.accentBlue)
                            
                            Text("Beat the High Press: Transition quickly after recovering the ball in your defensive third.")
                                .font(.body).foregroundColor(.white).multilineTextAlignment(.center)
                            
                            Button(action: { playChallenge() }) {
                                Text("START SCENARIO")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Colors_PM.neonGreen)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding()
                        .background(Colors_PM.cardBackground)
                        .cornerRadius(20)
                        .padding(.horizontal, adaptyW(40))
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
        .onAppear { loadStreak() }
    }
    
    private func loadStreak() {
        let lastPlayed = UserDefaults.standard.object(forKey: "lastChallengeDate_PM") as? Date
        if let lastPlayed = lastPlayed {
            let diff = Calendar.current.dateComponents([.day], from: lastPlayed, to: Date()).day ?? 0
            if diff == 1 { streak += 1 } else if diff > 1 { streak = 0 }
        }
    }
    
    private func playChallenge() {
        streak += 1
        UserDefaults.standard.set(Date(), forKey: "lastChallengeDate_PM")
        
        let session = TrainingSession(mode: "Daily Challenge", resultScore: 50, duration: 2)
        modelContext.insert(session)
        try? modelContext.save()
        
        showingReward = true
    }
}
