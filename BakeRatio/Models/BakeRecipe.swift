import Foundation

/// 保存下来的配方
struct BakeRecipe: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var hydration: Double
    var saltPct: Double
    var starterPct: Double
    var flourGrams: Double
    var loaves: Int
    var note: String = ""
    var createdAt: Date = Date()

    var formula: BakeFormula {
        BakeFormula(flourGrams: flourGrams, hydration: hydration,
                    saltPct: saltPct, starterPct: starterPct)
    }

    var summary: String {
        "\(BakeNumbers.percent(hydration)) water · \(BakeNumbers.percent(saltPct)) salt · \(BakeNumbers.percent(starterPct)) starter"
    }
}

/// 一次烘焙记录（用于回顾）
struct BakeLogEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var name: String
    var totalGrams: Double
    var loaves: Int
    var roomTemp: Double
    var note: String = ""
}
