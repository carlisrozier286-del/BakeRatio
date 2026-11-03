import Foundation

/// 常见面团风格：只替换三个比例，其它输入保持不变。
struct BakePreset: Identifiable, Equatable {
    let id: String
    let name: String
    let hydration: Double
    let saltPct: Double
    let starterPct: Double
    let note: String

    static let all: [BakePreset] = [
        BakePreset(id: "country", name: BakeStrings.presetCountry,
                   hydration: 0.75, saltPct: 0.020, starterPct: 0.20,
                   note: BakeStrings.presetCountryNote),
        BakePreset(id: "baguette", name: BakeStrings.presetBaguette,
                   hydration: 0.72, saltPct: 0.018, starterPct: 0.30,
                   note: BakeStrings.presetBaguetteNote),
        BakePreset(id: "sandwich", name: BakeStrings.presetSandwich,
                   hydration: 0.68, saltPct: 0.020, starterPct: 0.25,
                   note: BakeStrings.presetSandwichNote),
        BakePreset(id: "pizza", name: BakeStrings.presetPizza,
                   hydration: 0.62, saltPct: 0.025, starterPct: 0.10,
                   note: BakeStrings.presetPizzaNote)
    ]
}

/// 水温：由目标面团温度倒推需要多少度的水。
/// 经典写法是 DDT × 因子数 −（室温 + 面粉温 + 酸种温 + 摩擦升温）。
enum BakeTempMath {

    /// 需要的水温（℃）
    static func waterTemperature(desired: Double,
                                 room: Double,
                                 flour: Double,
                                 starter: Double,
                                 friction: Double,
                                 includesStarter: Bool) -> Double {
        let factorCount = includesStarter ? 4.0 : 3.0
        var deducted = room + flour + friction
        if includesStarter {
            deducted += starter
        }
        return desired * factorCount - deducted
    }

    /// 一句人话解释算出来的水温
    static func advice(for temp: Double) -> String {
        if temp < 5 {
            return BakeStrings.waterColder
        } else if temp > 30 {
            return BakeStrings.waterWarmer
        }
        return BakeStrings.waterFine
    }
}

/// 发酵时间表：从开始混合起，每一步在多少分钟后发生。
struct BakeScheduleStep: Identifiable, Equatable {
    let id: Int
    let title: String
    let detail: String
    let offsetMinutes: Double
}

enum BakeTimeline {

    /// 把「主发酵时长 + 冷藏时长 + 折叠次数」展开成一份时间表
    static func build(bulkHours: Double,
                      retardHours: Double,
                      folds: Int,
                      roomTemp: Double) -> [BakeScheduleStep] {
        var steps: [BakeScheduleStep] = []
        var index = 0

        func add(_ title: String, _ detail: String, _ minutes: Double) {
            steps.append(BakeScheduleStep(id: index, title: title, detail: detail, offsetMinutes: minutes))
            index += 1
        }

        let bulk = bulkHours * 60
        let rest = 25.0

        add(BakeStrings.stepMix, String(format: BakeStrings.stepMixNote, Int(roomTemp)), 0)
        add(BakeStrings.stepRest, BakeStrings.stepRestNote, rest)
        add(BakeStrings.stepBulk, BakeStrings.stepBulkNote, rest)

        let bulkStart = rest
        if folds >= 1 {
            add(BakeStrings.stepFold(1), BakeStrings.stepFoldNote, bulkStart + bulk * 0.30)
        }
        if folds >= 2 {
            add(BakeStrings.stepFold(2), BakeStrings.stepFoldNote, bulkStart + bulk * 0.55)
        }
        if folds >= 3 {
            add(BakeStrings.stepFold(3), BakeStrings.stepFoldNote, bulkStart + bulk * 0.80)
        }

        add(BakeStrings.stepShape, BakeStrings.stepShapeNote, bulkStart + bulk)

        var cursor = bulkStart + bulk + 30
        if retardHours > 0 {
            add(BakeStrings.stepRetard, BakeStrings.stepRetardNote, bulkStart + bulk)
            cursor = bulkStart + bulk + retardHours * 60
        }

        add(BakeStrings.stepBake, BakeStrings.stepBakeNote, cursor)
        add(BakeStrings.stepCool, BakeStrings.stepCoolNote, cursor + 45)
        return steps
    }

    /// 从开始时间推算出每一刻的钟点
    static func clock(_ start: Date, offsetMinutes: Double) -> Date {
        start.addingTimeInterval(offsetMinutes * 60)
    }
}
