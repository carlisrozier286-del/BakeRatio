import Foundation

/// 面团配比计算。所有百分比都相对「面粉总重」。
/// 酸种默认按 100% 水粉比处理（面粉:水 = 1:1），界面上有说明。
struct BakeFormula: Equatable {
    var flourGrams: Double
    var hydration: Double        // 0.75 = 75%
    var saltPct: Double          // 0.02 = 2%
    var starterPct: Double       // 0.20 = 20%

    var waterGrams: Double { flourGrams * hydration }
    var saltGrams: Double { flourGrams * saltPct }
    var starterGrams: Double { flourGrams * starterPct }

    /// 面团总重（含酸种里的水与面粉）
    var totalGrams: Double { flourGrams + waterGrams + saltGrams + starterGrams }

    /// 酸种里的面粉与水分（100% 水粉比）
    var starterFlour: Double { starterGrams / 2 }
    var starterWater: Double { starterGrams / 2 }

    /// 把总重按同样比例缩放
    func scaled(toTotal target: Double) -> BakeFormula {
        guard totalGrams > 0 else { return self }
        var copy = self
        copy.flourGrams = flourGrams * (target / totalGrams)
        return copy
    }

    /// 由「目标面团总重」反推面粉量
    static func fromTotalDough(_ total: Double,
                               hydration: Double,
                               saltPct: Double,
                               starterPct: Double) -> BakeFormula {
        let factor = 1 + hydration + saltPct + starterPct
        guard factor > 0 else {
            return BakeFormula(flourGrams: 0, hydration: hydration, saltPct: saltPct, starterPct: starterPct)
        }
        return BakeFormula(flourGrams: total / factor,
                           hydration: hydration, saltPct: saltPct, starterPct: starterPct)
    }

    /// 分成若干份之后每份重量
    func weightPerLoaf(loaves: Int) -> Double {
        guard loaves > 0 else { return totalGrams }
        return totalGrams / Double(loaves)
    }
}

/// 大致发酵时间（小时）。默认按室温 24℃、酸种 20% 为基准估算，
/// 温度每升 1℃ 约缩短 8%，酸种比例每高 5% 约缩短 10%。
enum BakeFerment {
    static func bulkHours(roomTemp: Double, starterPct: Double) -> Double {
        let base = 4.5
        let tempFactor = pow(0.92, roomTemp - 24)
        let starterFactor = pow(0.90, (starterPct - 0.20) * 20)
        let hours = base * tempFactor * starterFactor
        return min(max(hours, 1.5), 14)
    }

    static func window(roomTemp: Double, starterPct: Double) -> (low: Double, high: Double) {
        let h = bulkHours(roomTemp: roomTemp, starterPct: starterPct)
        return (h * 0.85, h * 1.15)
    }
}
