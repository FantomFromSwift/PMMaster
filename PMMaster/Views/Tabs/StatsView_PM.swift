import SwiftUI
import Charts
import SwiftData

struct StatsView_PM: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    @Query private var tasks: [CompletedTask]
    @Query private var sessions: [TrainingSession]
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "STATISTICS", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(spacing: adaptyH(30)) {
                        
                        VStack(alignment: .leading) {
                            Text("TRAINING PROGRESS")
                                .font(.caption).bold().tracking(2).foregroundColor(.gray)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(Colors_PM.cardBackground)
                                
                                Chart {
                                    ForEach(sessions.sorted(by: { $0.date < $1.date }), id: \.date) { session in
                                        LineMark(
                                            x: .value("Date", session.date, unit: .day),
                                            y: .value("Score", session.resultScore)
                                        )
                                        .foregroundStyle(Colors_PM.neonGreen.gradient)
                                        .symbol(Circle())
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(position: .leading)
                                }
                                .padding()
                            }
                            .frame(height: adaptyH(250))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("COMPLETED TASKS")
                                .font(.caption).bold().tracking(2).foregroundColor(.gray)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(Colors_PM.cardBackground)
                                
                                Chart {
                                    let grouped = Dictionary(grouping: tasks, by: { Calendar.current.startOfDay(for: $0.dateCompleted) })
                                    ForEach(grouped.keys.sorted(), id: \.self) { date in
                                        BarMark(
                                            x: .value("Date", date, unit: .day),
                                            y: .value("Count", grouped[date]?.count ?? 0)
                                        )
                                        .foregroundStyle(Colors_PM.accentBlue.gradient)
                                    }
                                }
                                .padding()
                            }
                            .frame(height: adaptyH(200))
                        }
                        
                        HStack(spacing: adaptyW(16)) {
                            StatSummaryCard(title: "AVG SCORE", value: "\(avgScore())%", icon: "percent")
                            StatSummaryCard(title: "SCENARIOS", value: "\(sessions.filter { $0.mode == "Scenario" }.count)", icon: "brain")
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private func avgScore() -> Int {
        guard !sessions.isEmpty else { return 0 }
        let total = sessions.reduce(0) { $0 + $1.resultScore }
        return total / sessions.count
    }
}

struct StatSummaryCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: adaptyH(10)) {
            Image(systemName: icon)
                .foregroundColor(Colors_PM.gold)
                .font(.title2)
            
            Text(value)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .bold()
                .tracking(2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
