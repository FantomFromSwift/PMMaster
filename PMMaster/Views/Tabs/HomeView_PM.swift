import SwiftUI
import SwiftData

struct HomeView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Query private var completedTasks: [CompletedTask]
    @State private var radarRotation: Double = 0
    @State private var nodeScale: CGFloat = 1.0
    
    private var completedTasksCount: Int { completedTasks.count }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "CONTROL ROOM", showBackButton: false)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: adaptyH(24)) {
                        radarWidget
                        
                        dailyTrainingCards
                        
                        quickSimLaunch
                        
                        tacticalTips
                        
                        statsAndSaved
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(20))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                radarRotation = 360
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                nodeScale = 1.1
            }
        }
    }
    
    private var radarWidget: some View {
        VStack(alignment: .leading) {
            Text("TACTICAL RADAR")
                .font(.caption)
                .bold()
                .tracking(2)
                .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
            
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Colors_PM.cardBackground)
                    .frame(height: adaptyH(200))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.3), lineWidth: 1)
                    )
                
                Circle()
                    .strokeBorder(Colors_PM.accentBlue.opacity(0.4), lineWidth: 1)
                    .frame(width: adaptyW(150))
                Circle()
                    .strokeBorder(Colors_PM.accentBlue.opacity(0.2), lineWidth: 1)
                    .frame(width: adaptyW(100))
                Circle()
                    .strokeBorder(Colors_PM.accentBlue.opacity(0.1), lineWidth: 1)
                    .frame(width: adaptyW(50))
                
                Path { path in
                    path.move(to: CGPoint(x: 75, y: 75))
                    path.addLine(to: CGPoint(x: 150, y: 75))
                }
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Colors_PM.accent(for: viewModel.selectedTheme), .clear]), startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: adaptyW(150), height: adaptyH(150))
                .rotationEffect(.degrees(radarRotation))
                
                Circle()
                    .fill(Colors_PM.gold)
                    .frame(width: adaptyW(8), height: adaptyH(8))
                    .shadow(color: Colors_PM.gold, radius: 5)
                    .offset(x: -40, y: -30)
                    .scaleEffect(nodeScale)
                
                Circle()
                    .fill(Colors_PM.accentBlue)
                    .frame(width: adaptyW(10), height: adaptyH(10))
                    .shadow(color: Colors_PM.accentBlue, radius: 5)
                    .offset(x: 50, y: 20)
            }
        }
    }
    
    private var dailyTasks: [TrainingTask] {
        let tasks = viewModel.content.tasks
        guard !tasks.isEmpty else { return [] }
        guard tasks.count >= 3 else { return tasks }
        
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let offset = dayOfYear % tasks.count
        
        var selection: [TrainingTask] = []
        for i in 0..<3 {
            selection.append(tasks[(offset + i) % tasks.count])
        }
        return selection
    }
    
    private var dailyTrainingCards: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("DAILY SUGGESTIONS")
                .font(.caption)
                .bold()
                .tracking(2)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: adaptyW(16)) {
                    ForEach(dailyTasks, id: \.id) { task in
                        NavigationLink(destination: TaskDetailsView_PM(task: task)) {
                            VStack(alignment: .leading) {
                                Image(systemName: "figure.run")
                                    .font(.title)
                                    .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                                    .padding(.bottom, adaptyH(8))
                                    
                                Text(task.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                
                                Text(task.difficulty)
                                    .font(.caption)
                                    .foregroundColor(Colors_PM.gold)
                                    .padding(.top, adaptyH(4))
                            }
                            .padding()
                            .frame(width: adaptyW(160), height: adaptyH(160), alignment: .topLeading)
                            .background(Colors_PM.cardBackground)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.1)))
                        }
                    }
                }
            }
        }
    }
    
    private var quickSimLaunch: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("SIMULATION MODULES")
                .font(.caption)
                .bold()
                .tracking(2)
                .foregroundColor(.gray)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: adaptyH(16)) {
                NavigationLink(destination: PassDecisionSimulatorView_PM()) {
                    SimButton(title: "Pass Sim", icon: "arrow.turn.right.up")
                }
                NavigationLink(destination: DefenseReactionTrainerView_PM()) {
                    SimButton(title: "Defense", icon: "shield.fill")
                }
                NavigationLink(destination: MatchScenarioSimulatorView_PM()) {
                    SimButton(title: "Match Sim", icon: "sportscourt.fill")
                }
                NavigationLink(destination: FormationBuilderView_PM()) {
                    SimButton(title: "Builder", icon: "arrow.up.and.down.and.arrow.left.and.right")
                }
            }
        }
    }
    
    private var dailyTips: [StrategyTip] {
        let tips = viewModel.content.tips
        guard !tips.isEmpty else { return [] }
        guard tips.count >= 3 else { return tips }
        
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let offset = dayOfYear % tips.count
        
        var selection: [StrategyTip] = []
        for i in 0..<3 {
            selection.append(tips[(offset + i) % tips.count])
        }
        return selection
    }
    
    private var tacticalTips: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("TRENDING STRATEGIES")
                .font(.caption)
                .bold()
                .tracking(2)
                .foregroundColor(.gray)
            
            VStack(spacing: adaptyH(10)) {
                ForEach(dailyTips, id: \.id) { tip in
                    NavigationLink(destination: StrategyTipDetailView_PM(tip: tip)) {
                        HStack {
                            VStack(alignment: .leading, spacing: adaptyH(4)) {
                                Text(tip.title)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                Text(tip.summary)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                        }
                        .padding()
                        .background(Colors_PM.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var statsAndSaved: some View {
        HStack(spacing: adaptyW(16)) {
            VStack(alignment: .leading) {
                Text("FORMATION PREVIEW")
                    .font(.caption)
                    .bold()
                    .tracking(2)
                    .foregroundColor(.gray)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Colors_PM.cardBackground)
                        .frame(height: adaptyH(120))
                    
                    Image(systemName: "square.grid.3x3.fill")
                        .font(.largeTitle)
                        .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.3))
                }
            }
            
            VStack(alignment: .leading) {
                Text("MINI STATS")
                    .font(.caption)
                    .bold()
                    .tracking(2)
                    .foregroundColor(.gray)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Colors_PM.cardBackground)
                        .frame(height: adaptyH(120))
                    
                    VStack {
                        Text("\(completedTasksCount)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Colors_PM.gold)
                        Text("Tasks Done")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct SimButton: View {
    @Environment(MainViewModel.self) private var viewModel
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Colors_PM.darkBackground)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.5), lineWidth: 1))
    }
}

#Preview {
    let schema = Schema([
        UserProfile.self,
        FavoriteItem.self,
        CompletedTask.self,
        TrainingSession.self,
        StrategyBoard.self,
        MatchScenarioResult.self,
        JournalNote.self
    ])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])

    return HomeView_PM()
        .environment(MainViewModel.shared)
        .modelContainer(container)
}
