import Foundation

enum BakeNumbers {

    /// 1000 -> "1,000 g"，小于 10 g 保留一位小数
    static func grams(_ value: Double) -> String {
        if value < 10 {
            return String(format: "%.1f g", value)
        }
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_GB")
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        let s = f.string(from: NSNumber(value: value.rounded())) ?? "0"
        return "\(s) g"
    }

    /// 0.75 -> "75%"
    static func percent(_ value: Double) -> String {
        String(format: "%.0f%%", value * 100)
    }

    /// 0.755 -> "75.5%"
    static func percentFine(_ value: Double) -> String {
        String(format: "%.1f%%", value * 100)
    }

    /// 小时 -> "4 h 30 min"
    static func hours(_ value: Double) -> String {
        let totalMinutes = Int((value * 60).rounded())
        let h = totalMinutes / 60
        let m = totalMinutes % 60
        if h == 0 { return "\(m) min" }
        if m == 0 { return "\(h) h" }
        return "\(h) h \(m) min"
    }

    /// 剩余秒数 -> "01:23:45"
    static func countdown(_ seconds: TimeInterval) -> String {
        let total = max(0, Int(seconds))
        return String(format: "%02d:%02d:%02d", total / 3600, (total % 3600) / 60, total % 60)
    }

    /// 时间点 -> "14:05"
    static func clockTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_GB")
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}

/// 日期格式
enum BakeDate {
    static func short(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_GB")
        f.dateStyle = .medium
        f.timeStyle = .none
        return f.string(from: date)
    }
}
