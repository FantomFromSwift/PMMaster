import SwiftUI
import SwiftData

struct TasksView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "TRAINING TASKS", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    LazyVStack(spacing: adaptyH(16)) {
                        ForEach(viewModel.content.tasks) { task in
                            NavigationLink(destination: TaskDetailsView_PM(task: task)) {
                                TaskCard(task: task)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
}

struct TaskCard: View {
    let task: TrainingTask
    
    var body: some View {
        HStack(spacing: adaptyW(16)) {
            ZStack {
                Circle()
                    .fill(Colors_PM.darkBackground)
                    .frame(width: adaptyW(60), height: adaptyH(60))
                
                Image(systemName: "figure.run.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Colors_PM.accentBlue)
            }
            
            VStack(alignment: .leading, spacing: adaptyH(6)) {
                Text(task.difficulty.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Colors_PM.gold)
                
                Text(task.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct TaskDetailsView_PM: View {
    let task: TrainingTask
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) private var viewModel
    
    @Query private var favorites: [FavoriteItem]
    
    private var isSaved: Bool {
        favorites.contains(where: { $0.id == task.id })
    }
    
    var body: some View {
        taskDetailsContent
        .onChange(of: viewModel.shouldPopTaskFlowToRoot) { _, shouldPop in
            if shouldPop {
                viewModel.shouldPopTaskFlowToRoot = false
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var taskDetailsContent: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: task.title.uppercased(), showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: adaptyH(24)) {
                        
                        Image(systemName: "flag.checkered.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(Colors_PM.neonGreen)
                            .frame(maxWidth: .infinity)
                            .padding(.top, adaptyH(40))
                        
                        Text(task.description)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineSpacing(8)
                            .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("DIFFICULTY")
                                    .font(.caption).foregroundColor(.gray)
                                Text(task.difficulty)
                                    .font(.headline).foregroundColor(Colors_PM.gold)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("REWARD")
                                    .font(.caption).foregroundColor(.gray)
                                Text("\(task.xpReward) XP")
                                    .font(.headline).foregroundColor(Colors_PM.accentBlue)
                            }
                        }
                        .padding()
                        .background(Colors_PM.cardBackground)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        Button(action: toggleFavorite) {
                            HStack {
                                Image(systemName: isSaved ? "star.fill" : "star")
                                Text(isSaved ? "Saved to Favorites" : "Save Task")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSaved ? Colors_PM.gold : Colors_PM.accentBlue)
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(destination: TaskStepsView_PM(task: task)) {
                            Text("START TRAINING")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Colors_PM.neonGreen)
                                .clipShape(Capsule())
                                .shadow(color: Colors_PM.neonGreen.opacity(0.5), radius: 10)
                        }
                        .padding(.horizontal)
                        .padding(.top, adaptyH(40))
                    }
                }
                .contentMargins(.bottom, 100)
            }
            .navigationBarHidden(true)
            .navigationBackWithSwipe()
        }
    }
    
    private func toggleFavorite() {
        if isSaved {
            if let item = favorites.first(where: { $0.id == task.id }) {
                modelContext.delete(item)
            }
        } else {
            let favItem = FavoriteItem(id: task.id, title: task.title, category: task.difficulty)
            modelContext.insert(favItem)
        }
        try? modelContext.save()
    }
}

struct TaskStepsView_PM: View {
    let task: TrainingTask
    @State private var currentStepIndex = 0
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: adaptyH(20)) {
                CustomHeader_PM(title: "STEP \(currentStepIndex + 1)/\(task.steps.count)", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                if currentStepIndex < task.steps.count {
                    let step = task.steps[currentStepIndex]
                    
                    VStack(spacing: adaptyH(40)) {
                        
                        Image(systemName: step.image ?? "sportscourt.fill")
                            .font(.system(size: 150))
                            .foregroundColor(Colors_PM.accentBlue)
                            .shadow(color: Colors_PM.accentBlue.opacity(0.5), radius: 20)
                            .animation(.spring(), value: currentStepIndex)
                        
                        Text(step.instruction)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, adaptyW(40))
                        
                        
                        Button(action: nextStep) {
                            Text("NEXT STEP")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Colors_PM.neonGreen)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, adaptyW(20))
                    }
                } else {
                    TaskFinishView_PM(task: task, completeAction: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private func nextStep() {
        withAnimation {
            currentStepIndex += 1
        }
    }
}

struct TaskFinishView_PM: View {
    let task: TrainingTask
    let completeAction: () -> Void
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    var body: some View {
        VStack(spacing: adaptyH(40)) {
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 120))
                .foregroundColor(Colors_PM.gold)
                .shadow(color: Colors_PM.gold.opacity(0.8), radius: 20)
            
            Text("TRAINING COMPLETE!")
                .font(.largeTitle)
                .bold()
                .tracking(2)
                .foregroundColor(.white)
            
            Text("You earned \(task.xpReward) XP for completing: \(task.title).")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, adaptyW(40))
            
            Spacer()
            
            Button(action: {
                saveCompletion()
                completeAction()
            }) {
                Text("FINISH")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Colors_PM.neonGreen)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, adaptyW(40))
            .padding(.bottom, adaptyH(60))
        }
        .navigationBackWithSwipe()
        .onAppear {
            saveCompletion()
        }
    }
    
    private func saveCompletion() {
        let completed = CompletedTask(taskId: task.id, score: task.xpReward)
        modelContext.insert(completed)
        
        let session = TrainingSession(mode: task.title, resultScore: task.xpReward, duration: task.steps.count * 2)
        modelContext.insert(session)
        
        try? modelContext.save()
    }
}
