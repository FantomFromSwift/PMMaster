import SwiftUI
import SwiftData

struct JournalView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \JournalNote.date, order: .reverse) private var notes: [JournalNote]
    @Query(sort: \StrategyBoard.dateCreated, order: .reverse) private var formations: [StrategyBoard]
    
    @State private var selectedCategory = "All"
    let categories = ["All", "My Tactical Notes", "Match Analysis Notes", "Saved Formations"]
    
    var filteredNotes: [JournalNote] {
        if selectedCategory == "All" { return notes }
        if selectedCategory == "Saved Formations" { return [] }
        return notes.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "JOURNAL", showBackButton: false)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { cat in
                            Button(action: { selectedCategory = cat }) {
                                Text(cat)
                                    .font(.caption)
                                    .bold()
                                    .padding(.horizontal, adaptyW(16))
                                    .padding(.vertical, adaptyH(8))
                                    .background(selectedCategory == cat ? Colors_PM.accent(for: viewModel.selectedTheme) : Colors_PM.cardBackground)
                                    .foregroundColor(selectedCategory == cat ? .black : .white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding()
                }
                
                ScrollView {
                    LazyVStack(spacing: adaptyH(16)) {
                        if selectedCategory == "Saved Formations" || selectedCategory == "All" {
                            ForEach(formations) { formation in
                                NavigationLink(destination: FormationBuilderView_PM(boardToEdit: formation)) {
                                    FormationCard_PM(formation: formation)
                                }
                            }
                        }
                        
                        ForEach(filteredNotes) { note in
                            NavigationLink(destination: NoteDetailView_PM(note: note)) {
                                JournalNoteCard_PM(note: note)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    .padding(.bottom, adaptyH(100))
                }
                .overlay {
                    if filteredNotes.isEmpty && (selectedCategory != "Saved Formations" || formations.isEmpty) && (selectedCategory != "All" || (notes.isEmpty && formations.isEmpty)) {
                        ContentUnavailableView {
                            Label("No Content", systemImage: "doc.text.magnifyingglass")
                                .foregroundStyle(Colors_PM.accent(for: viewModel.selectedTheme))
                        } description: {
                            Text("Add items to see them here.")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: EditNoteView_PM(noteToEdit: nil)) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(width: adaptyW(60), height: adaptyH(60))
                            .background(Colors_PM.accent(for: viewModel.selectedTheme))
                            .clipShape(Circle())
                            .shadow(color: Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.6), radius: 10, y: 5)
                            .padding()
                    }
                }
                .padding(.bottom, adaptyH(80))
            }
        }
        .navigationBarHidden(true)
    }
}

struct JournalNoteCard_PM: View {
    let note: JournalNote
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: adaptyH(8)) {
            HStack {
                Text(note.category.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                Spacer()
                Button(action: toggleFavorite) {
                    Image(systemName: note.isFavorite ? "star.fill" : "star")
                        .foregroundColor(note.isFavorite ? Colors_PM.gold : .gray)
                }
            }
            
            Text(note.title)
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(note.text)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Text(note.date, style: .date)
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.8))
                .padding(.top, adaptyH(4))
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
    
    private func toggleFavorite() {
        note.isFavorite.toggle()
        try? modelContext.save()
    }
}

struct FormationCard_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    let formation: StrategyBoard
    
    var body: some View {
        VStack(alignment: .leading, spacing: adaptyH(8)) {
            HStack {
                Text("SAVED FORMATION")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                Spacer()
                Image(systemName: "square.grid.3x3.fill")
                    .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
            }
            
            Text(formation.formationName)
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("Custom tactical setup")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(formation.dateCreated, style: .date)
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.8))
                .padding(.top, adaptyH(4))
        }
        .padding()
        .background(Colors_PM.cardBackground)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct NoteDetailView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    let note: JournalNote
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "NOTE", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: adaptyH(20)) {
                        Text(note.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                        
                        Text(note.date, style: .date)
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        Text(note.text)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineSpacing(8)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
}

struct EditNoteView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    var noteToEdit: JournalNote?
    
    @State private var title = ""
    @State private var text = ""
    @State private var category = "My Tactical Notes"
    
    let categories = ["My Tactical Notes", "Match Analysis Notes"]
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: noteToEdit == nil ? "NEW NOTE" : "EDIT NOTE", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                Form {
                    Section(header: Text("Details").foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))) {
                        TextField("Note Title", text: $title)
                            .foregroundColor(.white)
                        
                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) {
                                Text($0).foregroundColor(.white)
                            }
                        }
                    }
                    .listRowBackground(Colors_PM.cardBackground)
                    
                    Section(header: Text("Content").foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))) {
                        TextEditor(text: $text)
                            .frame(height: adaptyH(200))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .listRowBackground(Colors_PM.cardBackground)
                    
                    Button(action: saveChange) {
                        Text("SAVE NOTE")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty || text.isEmpty ? Color.gray : Colors_PM.accent(for: viewModel.selectedTheme))
                            .clipShape(Capsule())
                    }
                    .listRowBackground(Colors_PM.cardBackground)
                    .disabled(title.isEmpty || text.isEmpty)
                    .padding()
                }
                .scrollContentBackground(.hidden)
                
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
        .onAppear {
            if let note = noteToEdit {
                title = note.title
                text = note.text
                category = note.category
            }
        }
    }
    
    private func saveChange() {
        if let note = noteToEdit {
            note.title = title
            note.text = text
            note.category = category
        } else {
            let note = JournalNote(title: title, text: text, category: category)
            modelContext.insert(note)
        }
        try? modelContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}
