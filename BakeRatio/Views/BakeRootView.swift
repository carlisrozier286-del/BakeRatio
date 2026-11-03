import SwiftUI

struct BakeRootView: View {
    @EnvironmentObject private var state: BakeAppState
    @State private var mix = BakeMix()
    @State private var showRecipes = false
    @State private var showTiming = false
    @State private var showAbout = false

    var body: some View {
        NavigationStack {
            BakeCalculatorView(mix: $mix,
                               onOpenRecipes: { showRecipes = true },
                               onOpenTiming: { showTiming = true })
            .navigationTitle(BakeStrings.appName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showRecipes = true
                        } label: {
                            Label(BakeStrings.recipes, systemImage: "book")
                        }
                        Button {
                            showTiming = true
                        } label: {
                            Label(BakeStrings.timing, systemImage: "clock")
                        }
                        Divider()
                        Button {
                            showAbout = true
                        } label: {
                            Label(BakeStrings.about, systemImage: "info.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showRecipes) {
                BakeRecipeSheet(mix: $mix)
            }
            .sheet(isPresented: $showTiming) {
                BakeTimingSheet(starterPct: mix.starterPct)
            }
            .sheet(isPresented: $showAbout) {
                BakeAboutView()
            }
        }
    }
}

#Preview {
    BakeRootView().environmentObject(BakeAppState())
}
