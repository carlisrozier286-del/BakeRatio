import Foundation

/// 配料清单里的一行（用于展示与导出）
struct BakeIngredientLine: Identifiable, Equatable {
    var id: String { name }
    var name: String
    var grams: Double
    var percentOfFlour: Double
    var note: String = ""
}

enum BakeIngredients {

    /// 主要配料（不含酸种拆分）
    static func mainLines(_ f: BakeFormula) -> [BakeIngredientLine] {
        [
            BakeIngredientLine(name: BakeStrings.flour, grams: f.flourGrams,
                               percentOfFlour: 1.0),
            BakeIngredientLine(name: BakeStrings.water, grams: f.waterGrams,
                               percentOfFlour: f.hydration),
            BakeIngredientLine(name: BakeStrings.salt, grams: f.saltGrams,
                               percentOfFlour: f.saltPct),
            BakeIngredientLine(name: BakeStrings.starter, grams: f.starterGrams,
                               percentOfFlour: f.starterPct,
                               note: BakeStrings.starterNote)
        ]
    }

    /// 酸种拆分（面粉/水）
    static func starterLines(_ f: BakeFormula) -> [BakeIngredientLine] {
        [
            BakeIngredientLine(name: BakeStrings.starterFlour, grams: f.starterFlour,
                               percentOfFlour: f.starterPct / 2),
            BakeIngredientLine(name: BakeStrings.starterWater, grams: f.starterWater,
                               percentOfFlour: f.starterPct / 2)
        ]
    }
}
