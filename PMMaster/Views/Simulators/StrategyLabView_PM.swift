import SwiftUI

struct StrategyLabView_PM: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(MainViewModel.self) private var viewModel
    
    @State private var pressingIntensity: Double = 50
    @State private var defensiveLineHeight: Double = 50
    @State private var possessionTempo: Double = 50
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundFor(theme: viewModel.selectedTheme)
            
            VStack(spacing: 0) {
                CustomHeader_PM(title: "STRATEGY LAB", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                
                ScrollView {
                    VStack(spacing: adaptyH(30)) {
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Colors_PM.cardBackground)
                                .frame(height: adaptyH(200))
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Colors_PM.neonGreen.opacity(0.3), lineWidth: 2))
                            
                            VStack(spacing: adaptyH(8)) {
                                Text(overallPhilosophy)
                                    .font(.title2).bold().foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(analysisText)
                                    .font(.subheadline).foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                HStack(spacing: adaptyW(20)) {
                                    LabStatCircle(title: "Energy Drain", percent: pressingIntensity * 0.8)
                                    LabStatCircle(title: "Counter Risk", percent: (defensiveLineHeight * 0.7) + (possessionTempo * 0.3))
                                }
                                .padding(.top, adaptyH(10))
                            }
                        }
                        .padding(.top, adaptyH(20))
                        
                        
                        VStack(spacing: adaptyH(24)) {
                            LabSliderRow(title: "Pressing Intensity", value: $pressingIntensity, minLbl: "Low Block", maxLbl: "Gegenpress", color: Colors_PM.neonGreen)
                            
                            LabSliderRow(title: "Defensive Line", value: $defensiveLineHeight, minLbl: "Deep", maxLbl: "High", color: Colors_PM.gold)
                            
                            LabSliderRow(title: "Attacking Tempo", value: $possessionTempo, minLbl: "Slow buildup", maxLbl: "Fast transitions", color: Colors_PM.accentBlue)
                        }
                        .padding()
                        .background(Colors_PM.darkBackground)
                        .cornerRadius(20)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBackWithSwipe()
    }
    
    private var overallPhilosophy: String {
        if pressingIntensity > 75 && defensiveLineHeight > 75 { return "Total Football / High Press" }
        if pressingIntensity < 30 && defensiveLineHeight < 30 && possessionTempo > 70 { return "Park the Bus & Counter" }
        if possessionTempo < 30 { return "Tiki-Taka / Control" }
        return "Balanced Approach"
    }
    
    private var analysisText: String {
        if pressingIntensity > 70 {
            return "Expect high ball recovery in opponent's half, but severe stamina depletion."
        } else if defensiveLineHeight < 40 {
            return "Solid defensively, difficult to break down, but invites opponent pressure."
        }
        return "Adaptable setup. Good for feeling out the opponent early in the match."
    }
}

struct LabSliderRow: View {
    let title: String
    @Binding var value: Double
    let minLbl: String
    let maxLbl: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: adaptyH(8)) {
            HStack {
                Text(title).font(.subheadline).bold().foregroundColor(.white)
                Spacer()
                Text("\(Int(value))%").font(.caption).foregroundColor(color)
            }
            
            Slider(value: $value, in: 0...100)
                .tint(color)
            
            HStack {
                Text(minLbl).font(.caption2).foregroundColor(.gray)
                Spacer()
                Text(maxLbl).font(.caption2).foregroundColor(.gray)
            }
        }
    }
}

struct LabStatCircle: View {
    let title: String
    let percent: Double
    
    var body: some View {
        VStack {
            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 4).frame(width: adaptyW(40), height: adaptyH(40))
                Circle().trim(from: 0, to: CGFloat(percent / 100))
                    .stroke(percent > 70 ? Color.red : Colors_PM.accentBlue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: adaptyW(40), height: adaptyH(40)).rotationEffect(.degrees(-90))
                Text("\(Int(percent))").font(.caption2).bold().foregroundColor(.white)
            }
            Text(title).font(.system(size: 8)).foregroundColor(.gray)
        }
    }
}
