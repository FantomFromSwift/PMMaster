import SwiftUI

struct MainTabView_PM: View {
    @Environment(MainViewModel.self) private var viewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch viewModel.selectedTab {
                case 0:
                    NavigationStack {
                        HomeView_PM()
                    }
                case 1:
                    NavigationStack {
                        JournalView_PM()
                    }
                case 2:
                    NavigationStack {
                        SearchView_PM()
                    }
                case 3:
                    NavigationStack {
                        FavoritesView_PM()
                    }
                case 4:
                    NavigationStack {
                        SettingsView_PM()
                    }
                default: EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar_PM(selectedTab: Bindable(viewModel).selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar_PM: View {
    @Binding var selectedTab: Int
    @Environment(MainViewModel.self) private var viewModel

    let items = [
        ("rectangle.3.group.fill", "Home"),
        ("doc.text.fill", "Journal"),
        ("magnifyingglass", "Search"),
        ("star.fill", "Favorites"),
        ("gearshape.fill", "Settings"),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7))
                    {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: adaptyH(6)) {
                        Image(systemName: items[index].0)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(
                                selectedTab == index
                                    ? Colors_PM.accent(for: viewModel.selectedTheme) : .gray
                            )
                            .shadow(
                                color: selectedTab == index
                                    ? Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.8) : .clear,
                                radius: 10
                            )

                        Text(items[index].1)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(
                                selectedTab == index ? .white : .gray
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, adaptyH(12))
                }
            }
        }
        .background(
            ZStack {
                Colors_PM.darkBackground.opacity(0.95)
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Colors_PM.accent(for: viewModel.selectedTheme).opacity(0.3), lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .black.opacity(0.5), radius: 20, y: -10)
        .padding(.horizontal, adaptyW(16))
    }
}
