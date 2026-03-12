import SwiftUI

struct ThemeCR: Identifiable {
    let id: String
    let name: String
    let isPremium: Bool
    let price: String
    let primaryGradient: LinearGradient
    let secondaryGradient: LinearGradient
    let accentColor: Color
    let cardBackground: Color
    let textPrimary: Color
    let textSecondary: Color
}

class ThemeManagerCR {
    static let shared = ThemeManagerCR()
    
    let themes: [ThemeCR] = [
        ThemeCR(
            id: "warm_glow",
            name: "Warm Glow",
            isPremium: false,
            price: "Free",
            primaryGradient: LinearGradient(
                colors: [Color(red: 0.95, green: 0.85, blue: 0.75), Color(red: 0.85, green: 0.65, blue: 0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            secondaryGradient: LinearGradient(
                colors: [Color(red: 0.9, green: 0.7, blue: 0.6), Color(red: 0.8, green: 0.6, blue: 0.5)],
                startPoint: .top,
                endPoint: .bottom
            ),
            accentColor: Color(red: 0.9, green: 0.5, blue: 0.3),
            cardBackground: Color(red: 0.98, green: 0.95, blue: 0.92).opacity(0.9),
            textPrimary: Color(red: 0.2, green: 0.15, blue: 0.1),
            textSecondary: Color(red: 0.4, green: 0.35, blue: 0.3)
        ),
        ThemeCR(
            id: "ember_sunset",
            name: "Ember Sunset",
            isPremium: true,
            price: "$1.99",
            primaryGradient: LinearGradient(
                colors: [Color(red: 0.98, green: 0.75, blue: 0.65), Color(red: 0.92, green: 0.55, blue: 0.45)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            secondaryGradient: LinearGradient(
                colors: [Color(red: 0.95, green: 0.65, blue: 0.55), Color(red: 0.88, green: 0.5, blue: 0.4)],
                startPoint: .top,
                endPoint: .bottom
            ),
            accentColor: Color(red: 0.95, green: 0.45, blue: 0.25),
            cardBackground: Color(red: 0.99, green: 0.93, blue: 0.88).opacity(0.92),
            textPrimary: Color(red: 0.15, green: 0.1, blue: 0.08),
            textSecondary: Color(red: 0.35, green: 0.3, blue: 0.25)
        ),
        ThemeCR(
            id: "smoky_char",
            name: "Smoky Char",
            isPremium: true,
            price: "$1.99",
            primaryGradient: LinearGradient(
                colors: [Color(red: 0.88, green: 0.82, blue: 0.78), Color(red: 0.75, green: 0.62, blue: 0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            secondaryGradient: LinearGradient(
                colors: [Color(red: 0.85, green: 0.75, blue: 0.68), Color(red: 0.72, green: 0.58, blue: 0.5)],
                startPoint: .top,
                endPoint: .bottom
            ),
            accentColor: Color(red: 0.85, green: 0.55, blue: 0.35),
            cardBackground: Color(red: 0.96, green: 0.94, blue: 0.91).opacity(0.88),
            textPrimary: Color(red: 0.18, green: 0.12, blue: 0.08),
            textSecondary: Color(red: 0.38, green: 0.32, blue: 0.28)
        )
    ]
    
    func getTheme(by id: String) -> ThemeCR {
        themes.first { $0.id == id } ?? themes[0]
    }
}
