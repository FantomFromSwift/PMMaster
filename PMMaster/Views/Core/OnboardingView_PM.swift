import SwiftUI
import StoreKit

struct OnboardingStep {
    let title: String
    let subtitle: String
    let imageName: AppImage
}

struct OnboardingView_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    @Environment(\.requestReview) var requestReview
    
    @State private var currentStep = 0
    
    let steps: [OnboardingStep] = [
        OnboardingStep(title: "TACTICAL HUB", subtitle: "Immerse yourself in a full-fledged football laboratory.", imageName: .onbO),
        OnboardingStep(title: "SIMULATE SCENARIOS", subtitle: "Train your decision-making in real-match situations.", imageName: .onbT),
        OnboardingStep(title: "IMPROVE SKILLS", subtitle: "Master formations and defensive walls.", imageName: .onbTh),
        OnboardingStep(title: "TRACK PROGRESS", subtitle: "Detailed stats to monitor your tactical growth.", imageName: .onbF)
    ]
    
    var body: some View {
        ZStack {
            Image(steps[currentStep].imageName.rawValue)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.3))
                .animation(.easeInOut(duration: 0.5), value: currentStep)
            
            VStack(spacing: 0) {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 6) {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentStep ? Colors_PM.neonGreen : Color.white.opacity(0.15))
                                .frame(width: index == currentStep ? adaptyW(30) : adaptyW(8), height: adaptyH(4))
                        }
                    }
                    .padding(.top, adaptyH(35))
                    .padding(.bottom, adaptyH(25))
                    
                    VStack(alignment: .leading, spacing: adaptyH(10)) {
                        Text(steps[currentStep].title)
                            .font(.system(size: 34, weight: .black))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                            .shadow(color: Colors_PM.neonGreen.opacity(0.4), radius: 5)
                            .shadow(color: Colors_PM.neonGreen.opacity(0.4), radius: 10)
                            .tracking(1)
                        
                        
                        Rectangle()
                            .fill(Colors_PM.neonGreen)
                            .frame(width: adaptyW(55), height: adaptyH(4))
                    }
                    .padding(.bottom, adaptyH(30))
                    
                    Text(steps[currentStep].subtitle)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white.opacity(0.85))
                        .minimumScaleFactor(0.5)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                    
                    
                    Spacer()
                    
                    Button(action: nextStep) {
                        Text(currentStep == steps.count - 1 ? "GET STARTED" : "CONTINUE")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, adaptyH(20))
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .padding(.bottom, adaptyH(50))
                }
                .padding(.horizontal, adaptyW(30))
                .frame(maxWidth: .infinity)
                .frame(height: adaptyH(300))
                .background(
                    UnevenRoundedRectangle(topLeadingRadius: 45, topTrailingRadius: 45)
                        .fill(Color(red: 0.08, green: 0.09, blue: 0.1))
                        .ignoresSafeArea(.container, edges: .bottom)
                        .overlay(
                            UnevenRoundedRectangle(topLeadingRadius: 45, topTrailingRadius: 45)
                                .stroke(Colors_PM.neonGreen, lineWidth: 4)
                                .offset(y: 3)
                            
                        )
                        .ignoresSafeArea(.container, edges: .bottom)
                    
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }
    
    private func nextStep() {
        if currentStep == 2 {
            requestReview()
        }
        
        if currentStep < steps.count - 1 {
            currentStep += 1
        } else {
            viewModel.completeOnboarding()
        }
    }
}
#Preview("OnboardingView_PM Preview") {
    
    let mockVM = MainViewModel()
    
    OnboardingView_PM()
        .environment(mockVM)
}

