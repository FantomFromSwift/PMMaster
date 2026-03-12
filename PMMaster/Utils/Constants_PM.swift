import SwiftUI

enum AppImage: String {
    case stadiumFieldDay = "stadium_field_day"
    case tacticalBoard = "tactical_board"
    case footballPlayersSilhouette = "football_players_silhouette"
    case neonBall = "neon_ball"
    case defenseWall = "defense_wall"
    case attackArrows = "attack_arrows"
    case passChoices = "pass_choices"
    case labSliders = "lab_sliders"
    case headerArt1 = "header_art_1"
    case headerArt2 = "header_art_2"
    case coachRoomDark = "coach_room_dark"
    case goldenTrophy = "golden_trophy"
    case neonStadiumBG = "neon_stadium_bg"
    case trainingCone = "training_cone"
    case onbO = "onbO"
    case onbT = "onbT"
    case onbTh = "onbTh"
    case onbF = "onbF"
}

extension Image {
    init(_ appImage: AppImage) {
        self.init(appImage.rawValue)
    }
}

struct Colors_PM {
    static let neonGreen = Color(red: 0.2, green: 0.9, blue: 0.3)
    static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.08)
    static let cardBackground = Color.white.opacity(0.05)
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let surfaceColor = Color.white.opacity(0.1)
    static let premiumPurple = Color(red: 0.6, green: 0.3, blue: 1.0)
    
    static func accent(for theme: String) -> Color {
        switch theme {
        case "Golden Tactics": return gold
        case "Dark Coach Room": return accentBlue
        case "Elite Training": return premiumPurple
        default: return neonGreen
        }
    }
}

struct ThemeManager {
    static func backgroundFor(theme: String) -> some View {
        ZStack {
            
            backgroundGradient(for: theme)
                .ignoresSafeArea()
            
            
            Group {
                if theme == "Neon Stadium" {
                    neonStadiumElements()
                } else if theme == "Golden Tactics" {
                    goldenTacticsElements()
                } else if theme == "Dark Coach Room" {
                    darkCoachRoomElements()
                } else if theme == "Elite Training" {
                    
                    Color.clear
                }
            }
            .allowsHitTesting(false)
            
            
            gridOverlay(for: theme)
                .allowsHitTesting(false)
        }
    }
    
    private static func backgroundGradient(for theme: String) -> LinearGradient {
        let baseColor = Colors_PM.darkBackground
        let tintColor: Color
        
        switch theme {
        case "Golden Tactics":
            tintColor = Colors_PM.gold.opacity(0.08)
        case "Dark Coach Room":
            tintColor = Colors_PM.accentBlue.opacity(0.08)
        case "Elite Training":
            tintColor = Colors_PM.premiumPurple.opacity(0.1)
        default:
            tintColor = Colors_PM.neonGreen.opacity(0.08)
        }
        
        return LinearGradient(
            gradient: Gradient(colors: [baseColor, tintColor, baseColor]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private static func gridOverlay(for theme: String) -> some View {
        let color = Colors_PM.accent(for: theme).opacity(0.03)
        return Path { path in
            for i in stride(from: 0, to: UIScreen.main.bounds.height, by: 50) {
                path.move(to: CGPoint(x: 0, y: i))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: i))
            }
            for i in stride(from: 0, to: UIScreen.main.bounds.width, by: 50) {
                path.move(to: CGPoint(x: i, y: 0))
                path.addLine(to: CGPoint(x: i, y: UIScreen.main.bounds.height))
            }
        }
        .stroke(color, lineWidth: 1)
    }
    
    private static func neonStadiumElements() -> some View {
        ZStack {
            
            Circle()
                .fill(Colors_PM.neonGreen.opacity(0.2))
                .blur(radius: 80)
                .frame(width: adaptyW(400), height: adaptyH(400))
                .position(x: 50, y: 150)
            
            
            Circle()
                .fill(Colors_PM.neonGreen.opacity(0.1))
                .blur(radius: 100)
                .frame(width: adaptyW(350), height: adaptyH(350))
                .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 200)
            
            
            ScanningLineEffect(color: Colors_PM.neonGreen.opacity(0.05))
        }
    }
    
    private static func goldenTacticsElements() -> some View {
        ZStack {
            
            Circle()
                .fill(Colors_PM.gold.opacity(0.15))
                .blur(radius: 120)
                .frame(width: adaptyW(500), height: adaptyH(500))
                .position(x: UIScreen.main.bounds.width / 2, y: 300)
            
            
            Rectangle()
                .stroke(Colors_PM.gold.opacity(0.1), lineWidth: 2)
                .frame(width: adaptyW(200), height: adaptyH(200))
                .rotationEffect(.degrees(45))
                .position(x: UIScreen.main.bounds.width + 20, y: 400)
            
            Rectangle()
                .stroke(Colors_PM.gold.opacity(0.15), lineWidth: 1)
                .frame(width: adaptyW(150), height: adaptyH(150))
                .rotationEffect(.degrees(15))
                .position(x: -30, y: 200)
        }
    }
    
    private static func darkCoachRoomElements() -> some View {
        ZStack {
            Ellipse()
                .fill(Colors_PM.accentBlue.opacity(0.2))
                .blur(radius: 100)
                .frame(width: adaptyW(600), height: adaptyH(400))
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height)
            
    
            Circle()
                .fill(Colors_PM.accentBlue.opacity(0.1))
                .blur(radius: 80)
                .frame(width: adaptyW(300), height: adaptyH(300))
                .position(x: UIScreen.main.bounds.width, y: 0)
        
        }
    }
}

struct ScanningLineEffect: View {
    let color: Color
    @State private var offset: CGFloat = -UIScreen.main.bounds.height
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, color, .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: adaptyH(100))
            .offset(y: offset)
            .onAppear {
                withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                    offset = UIScreen.main.bounds.height
                }
            }
    }
}
