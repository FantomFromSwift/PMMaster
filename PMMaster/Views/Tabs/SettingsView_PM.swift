import SwiftUI
import StoreKit

struct SettingsView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(IAPManagerVE.self) private var iapManager
    @Environment(\.requestReview) private var requestReview
    @State private var showingPaywall = false
    @State private var newUsername = ""
    @FocusState private var isUsernameFocused: Bool
    
    let themes = ["Neon Stadium", "Golden Tactics", "Dark Coach Room", "Elite Training"]
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "SETTINGS", showBackButton: false)
                
                ScrollView {
                    VStack(spacing: adaptyH(24)) {
                        
                        VStack(alignment: .leading, spacing: adaptyH(12)) {
                            Text("COACH PROFILE")
                                .font(.caption)
                                .bold()
                                .tracking(2)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Image(systemName: "person.crop.circle.badge.checkmark")
                                    .font(.system(size: 40))
                                    .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                                
                                TextField("Enter username", text: $newUsername)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                                    .focused($isUsernameFocused)
                                    .onSubmit(saveUsername)
                                
                                Button(action: saveUsername) {
                                    Text("SAVE")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, adaptyW(12))
                                        .padding(.vertical, adaptyH(8))
                                        .background(Colors_PM.accent(for: viewModel.selectedTheme))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                            .padding()
                            .background(Colors_PM.cardBackground)
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        }
                        
                        VStack(alignment: .leading, spacing: adaptyH(12)) {
                            Text("LAB MODULE THEMES")
                                .font(.caption)
                                .bold()
                                .tracking(2)
                                .foregroundColor(.gray)
                                .padding(.top, adaptyH(10))
                            
                            ForEach(themes, id: \.self) { theme in
                                ThemeRow_PM(
                                    themeName: theme,
                                    isSelected: viewModel.selectedTheme == theme,
                                    isFree: theme == "Neon Stadium",
                                    isPurchased: iapManager.isPurchased(productIdFor(theme)),
                                    action: { selectTheme(theme) }
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: adaptyH(12)) {
                            Text("STORE")
                                .font(.caption)
                                .bold()
                                .tracking(2)
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                requestReview()
                            }) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("Rate App")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(Colors_PM.cardBackground)
                                .cornerRadius(12)
                            }
                                
                            Button(action: { iapManager.restorePurchases() }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise.circle")
                                        .foregroundColor(Colors_PM.accent(for: viewModel.selectedTheme))
                                    Text("Restore Purchases")
                                        .foregroundColor(.white)
                                    Spacer()
                                    if iapManager.isRestoring {
                                        ProgressView().tint(.white)
                                    }
                                }
                                .padding()
                                .background(Colors_PM.cardBackground)
                                .cornerRadius(12)
                            }
                        }
                        
                        NavigationLink(destination: AboutView_PM()) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.gray)
                                Text("About PM Master")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Colors_PM.cardBackground)
                            .cornerRadius(12)
                        }
                        
                        Spacer().frame(height: adaptyH(100))
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            newUsername = viewModel.appUsername
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView_PM()
        }
    }
    
    private func saveUsername() {
        viewModel.appUsername = newUsername
        isUsernameFocused = false
    }
    
    private func productIdFor(_ theme: String) -> String {
        switch theme {
        case "Golden Tactics": return "com.pmmaster.goldentactics"
        case "Dark Coach Room": return "com.pmmaster.darkcoachroom"
        case "Elite Training": return "com.pmmaster.elitetraining"
        default: return ""
        }
    }
    
    private func selectTheme(_ theme: String) {
        if theme == "Neon Stadium" || iapManager.isPurchased(productIdFor(theme)) {
            viewModel.selectedTheme = theme
        } else {
            showingPaywall = true
        }
    }
}

struct ThemeRow_PM: View {
    let themeName: String
    let isSelected: Bool
    let isFree: Bool
    let isPurchased: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                HStack(spacing: adaptyW(12)) {
                    Circle()
                        .fill(isSelected ? Colors_PM.accent(for: themeName) : .clear)
                        .frame(width: adaptyW(14), height: adaptyH(14))
                        .overlay(Circle().stroke(isSelected ? Colors_PM.accent(for: themeName) : .white, lineWidth: 2))
                    
                    Text(themeName)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                if !isFree && !isPurchased {
                    HStack(spacing: adaptyW(4)) {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                        Text("PRO")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(Colors_PM.gold)
                    .padding(.horizontal, adaptyW(8))
                    .padding(.vertical, adaptyH(4))
                    .background(Colors_PM.gold.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(isSelected ? Colors_PM.accent(for: themeName).opacity(0.1) : Colors_PM.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Colors_PM.accent(for: themeName).opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
