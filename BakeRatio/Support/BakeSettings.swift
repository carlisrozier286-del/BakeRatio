import Foundation

/// 本地偏好设置（不写入磁盘文件，每次启动用默认值）
struct BakeSettings: Codable, Equatable {
    var roomTemp: Double = 24          // ℃，用于估算主发酵时间与水温
    var showStarterSplit: Bool = true  // 是否展开酸种里的面粉/水
    var loafWeightTarget: Double = 800 // 单只面包目标重量，仅作提示
    var desiredDoughTemp: Int = 24     // ℃，目标面团温度
    var flourTemp: Int = 21            // ℃，面粉温度
    var friction: Int = 4              // ℃，搅拌升温
    var folds: Int = 3                 // 时间表里安排几次折叠
}
