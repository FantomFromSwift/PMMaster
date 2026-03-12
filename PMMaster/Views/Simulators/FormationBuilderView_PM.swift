import SwiftUI
import SwiftData

struct FormationBuilderView_PM: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    var boardToEdit: StrategyBoard?
    
    @State private var formationName = ""
    @State private var showingSaveAlert = false
    @State private var showingDeleteAlert = false
    @State private var positions: [CGPoint] = FormationFieldView_PM.defaultPositions
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "FORMATION LAB", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                ScrollView{
                    VStack{
                        HStack {
                            TextField("Formation Name (e.g. 4-3-3)", text: $formationName)
                                .padding()
                                .background(Colors_PM.cardBackground)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            if boardToEdit != nil {
                                Button(action: { showingDeleteAlert = true }) {
                                    Image(systemName: "trash.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(10)
                                }
                                .padding(.leading, adaptyW(10))
                            }
                            
                            Button(action: saveFormation) {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(formationName.isEmpty ? Color.gray : Colors_PM.neonGreen)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            .disabled(formationName.isEmpty)
                        }
                        .padding(.vertical, adaptyH(10))
                        
                        FormationFieldView_PM(positions: $positions)
                    }
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
        .onAppear {
            if let board = boardToEdit {
                formationName = board.formationName
                if let decoded = try? JSONSerialization.jsonObject(with: board.savedPositions) as? [[String: Double]] {
                    positions = decoded.map { CGPoint(x: $0["x"] ?? 0, y: $0["y"] ?? 0) }
                }
            }
        }
        .alert(isPresented: $showingSaveAlert) {
            Alert(
                title: Text("Saved"),
                message: Text(
                    "Formation '\(formationName)' has been saved to your arsenal."
                ),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .alert("Delete Formation?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteFormation()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this formation? This action cannot be undone.")
        }
    }
    
    private func deleteFormation() {
        if let board = boardToEdit {
            modelContext.delete(board)
            try? modelContext.save()
            presentationMode.wrappedValue.dismiss()
        }
    }
    private func saveFormation() {
        let codables = positions.map { ["x": Double($0.x), "y": Double($0.y)] }
        if let data = try? JSONSerialization.data(withJSONObject: codables, options: []) {
            if let board = boardToEdit {
                board.formationName = formationName
                board.savedPositions = data
                board.dateCreated = Date()
            } else {
                let board = StrategyBoard(formationName: formationName, savedPositions: data)
                modelContext.insert(board)
            }
            try? modelContext.save()
            showingSaveAlert = true
        }
    }
}



