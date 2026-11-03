import SwiftUI

/// 全局状态：配方库与烘焙记录都在本机
final class BakeAppState: ObservableObject {
    @Published var store = BakeStore()
    @Published var settings = BakeSettings()
}

@main
struct BakeRatioApp: App {
    @StateObject private var state = BakeAppState()

    var body: some Scene {
        WindowGroup {
            BakeRootView()
                .environmentObject(state)
                .tint(BakePalette.crust)
        }
    }
}

/// 麦棕 + 奶白（与其它 App 的配色完全不同）
enum BakePalette {
    static let crust = Color(red: 0.62, green: 0.38, blue: 0.16)
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let card = Color(.secondarySystemBackground)
    static let flour = Color(red: 0.85, green: 0.80, blue: 0.71)
    static let good = Color(red: 0.30, green: 0.52, blue: 0.28)
}
