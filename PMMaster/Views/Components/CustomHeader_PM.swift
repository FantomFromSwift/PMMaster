import SwiftUI

struct CustomHeader_PM: View {
    @Environment(MainViewModel.self) private var viewModel
    let title: String
    let showBackButton: Bool
    var backAction: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .center){
            HStack {
                if showBackButton {
                    Button(action: {
                        backAction?()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: adaptyW(44), height: adaptyH(44))
                            .background(Circle().fill(Color.black.opacity(0.5)))
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                } else {
                    Spacer().frame(width: adaptyW(44), height: adaptyH(44))
                }

                Spacer()
            }
            Text(title)
                .font(.system(size: 20, weight: .black, design: .default))
                .foregroundColor(.white)
                .tracking(2)
                .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 2)
                .frame(maxWidth: adaptyW(300))
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top, adaptyH(10))
        .padding(.bottom, adaptyH(10))
        .background(
            Rectangle()
                .fill(Color.clear)
                .overlay(
                    Image(headerImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(y: 30)
                )
                .overlay(Color.black.opacity(0.4))
                .clipped()
                .ignoresSafeArea(edges: .top)
        )
    }

    private var headerImageName: String {
        switch viewModel.selectedTheme {
        case "Golden Tactics": return "headerGolden"
        case "Dark Coach Room": return "headerDark"
        case "Elite Training": return "headerElite"
        default: return "header"
        }
    }
}
