import Foundation

/// 本地偏好设置
struct BakeSettings: Codable, Equatable {
    var roomTemp: Double = 24          // ℃，用于估算主发酵时间
    var showStarterSplit: Bool = true  // 是否展开酸种里的面粉/水
    var loafWeightTarget: Double = 800 // 单只面包目标重量，仅作提示
}
