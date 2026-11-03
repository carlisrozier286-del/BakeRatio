import Foundation

/// 输入模式：按面粉重量算，或按目标面团总重算
enum BakeInputMode: String, CaseIterable, Identifiable {
    case flour, totalDough

    var id: String { rawValue }

    var title: String {
        switch self {
        case .flour: return BakeStrings.modeFlour
        case .totalDough: return BakeStrings.modeTotal
        }
    }
}

/// 当前编辑中的配方（界面直接绑定它）
struct BakeMix: Equatable {
    var mode: BakeInputMode = .flour
    var flourGrams: Double = 1000
    var totalDoughGrams: Double = 1500
    var hydration: Double = 0.75
    var saltPct: Double = 0.02
    var starterPct: Double = 0.20
    var loaves: Int = 2

    /// 当前输入对应的配方
    var formula: BakeFormula {
        switch mode {
        case .flour:
            return BakeFormula(flourGrams: flourGrams, hydration: hydration,
                               saltPct: saltPct, starterPct: starterPct)
        case .totalDough:
            return .fromTotalDough(totalDoughGrams, hydration: hydration,
                                   saltPct: saltPct, starterPct: starterPct)
        }
    }

    static func from(_ recipe: BakeRecipe) -> BakeMix {
        BakeMix(mode: .flour,
                flourGrams: recipe.flourGrams,
                totalDoughGrams: recipe.formula.totalGrams,
                hydration: recipe.hydration,
                saltPct: recipe.saltPct,
                starterPct: recipe.starterPct,
                loaves: recipe.loaves)
    }

    func asRecipe(named name: String) -> BakeRecipe {
        BakeRecipe(name: name,
                   hydration: hydration,
                   saltPct: saltPct,
                   starterPct: starterPct,
                   flourGrams: formula.flourGrams,
                   loaves: loaves)
    }
}
