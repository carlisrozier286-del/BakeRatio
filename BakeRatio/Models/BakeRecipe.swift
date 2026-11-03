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

/// 一次烘焙记录。评分与备注可以事后补上，所以解码时对缺失字段留默认值。
struct BakeLogEntry: Identifiable, Codable, Equatable {
    var id: UUID
    var date: Date
    var name: String
    var totalGrams: Double
    var loaves: Int
    var roomTemp: Double
    var hydration: Double
    var score: Int
    var note: String

    init(id: UUID = UUID(),
         date: Date = Date(),
         name: String,
         totalGrams: Double,
         loaves: Int,
         roomTemp: Double,
         hydration: Double = 0.75,
         score: Int = 3,
         note: String = "") {
        self.id = id
        self.date = date
        self.name = name
        self.totalGrams = totalGrams
        self.loaves = loaves
        self.roomTemp = roomTemp
        self.hydration = hydration
        self.score = score
        self.note = note
    }

    private enum CodingKeys: String, CodingKey {
        case id, date, name, totalGrams, loaves, roomTemp, hydration, score, note
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        date = try c.decodeIfPresent(Date.self, forKey: .date) ?? Date()
        name = try c.decodeIfPresent(String.self, forKey: .name) ?? BakeStrings.appName
        totalGrams = try c.decodeIfPresent(Double.self, forKey: .totalGrams) ?? 0
        loaves = try c.decodeIfPresent(Int.self, forKey: .loaves) ?? 1
        roomTemp = try c.decodeIfPresent(Double.self, forKey: .roomTemp) ?? 24
        hydration = try c.decodeIfPresent(Double.self, forKey: .hydration) ?? 0.75
        score = try c.decodeIfPresent(Int.self, forKey: .score) ?? 3
        note = try c.decodeIfPresent(String.self, forKey: .note) ?? ""
    }
}
