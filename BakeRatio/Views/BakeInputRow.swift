import SwiftUI

/// 带滑块的一行（标签 + 当前值 + 滑杆）
struct BakeSliderRow: View {
    let title: String
    let valueText: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(valueText)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            Slider(value: $value, in: range, step: step)
        }
    }
}

/// 带步进器的一行（标签 + 当前值 + 加减）
struct BakeStepperRow: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    var suffix: String = ""

    var body: some View {
        Stepper(value: $value, in: range) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value)\(suffix)")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
    }
}

/// 重量输入行（点击右侧数字可微调，避免键盘遮挡）
struct BakeGramFieldRow: View {
    let title: String
    @Binding var grams: Double
    let step: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(BakeNumbers.grams(grams))
                    .foregroundStyle(BakePalette.crust)
                    .monospacedDigit()
            }
            HStack(spacing: 12) {
                Button {
                    grams = max(50, grams - step)
                } label: {
                    Image(systemName: "minus.circle")
                }
                Slider(value: $grams, in: 100...3000, step: step)
                Button {
                    grams = min(3000, grams + step)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .buttonStyle(.plain)
            .font(.title3)
        }
    }
}
