import SwiftUI

/// 底部四个页签
enum BakeTab: Hashable {
    case dough, recipes, schedule, bakes
}

struct BakeRootView: View {
    @EnvironmentObject private var state: BakeAppState
    @State private var mix = BakeMix()
    @State private var tab: BakeTab = .dough
    @State private var showAbout = false

    var body: some View {
        TabView(selection: $tab) {
            NavigationStack {
                BakeCalculatorView(mix: $mix, onOpenAbout: { showAbout = true })
            }
            .tabItem {
                Label(BakeStrings.tabDough, systemImage: "scalemass")
            }
            .tag(BakeTab.dough)

            NavigationStack {
                BakeRecipeListView(mix: $mix, onUse: { tab = .dough })
            }
            .tabItem {
                Label(BakeStrings.tabRecipes, systemImage: "book.closed")
            }
            .tag(BakeTab.recipes)

            NavigationStack {
                BakeScheduleView(mix: $mix)
            }
            .tabItem {
                Label(BakeStrings.tabSchedule, systemImage: "clock.badge.checkmark")
            }
            .tag(BakeTab.schedule)

            NavigationStack {
                BakeBakesView()
            }
            .tabItem {
                Label(BakeStrings.tabBakes, systemImage: "chart.bar.doc.horizontal")
            }
            .tag(BakeTab.bakes)
        }
        .sheet(isPresented: $showAbout) {
            BakeAboutView()
        }
    }
}

#Preview {
    BakeRootView().environmentObject(BakeAppState())
}
