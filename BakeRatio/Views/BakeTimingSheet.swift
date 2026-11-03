import SwiftUI

struct BakeTimingSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var state: BakeAppState

    let starterPct: Double

    @State private var endDate: Date?
    @State private var now = Date()

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var window: (low: Double, high: Double) {
        BakeFerment.window(roomTemp: state.settings.roomTemp, starterPct: starterPct)
    }

    var body: some View {
        NavigationStack {
            List {
                Section(BakeStrings.timingEstimate) {
                    HStack {
                        Text(BakeStrings.roomTemp)
                        Spacer()
                        Text("\(Int(state.settings.roomTemp)) ℃")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    Stepper("", value: $state.settings.roomTemp, in: 15...32, step: 1)
                        .labelsHidden()

                    HStack {
                        Text(BakeStrings.timing)
                        Spacer()
                        Text("\(BakeNumbers.hours(window.low)) – \(BakeNumbers.hours(window.high))")
                            .foregroundStyle(BakePalette.crust)
                            .monospacedDigit()
                    }

                    Text(BakeStrings.timingNote)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Section(BakeStrings.timerRunning) {
                    if let end = endDate {
                        Text(BakeNumbers.countdown(end.timeIntervalSince(now)))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(BakePalette.crust)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Button(BakeStrings.stopTimer) {
                            endDate = nil
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Button(BakeStrings.startTimer) {
                            let hours = (window.low + window.high) / 2
                            endDate = Date().addingTimeInterval(hours * 3600)
                            now = Date()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle(BakeStrings.timing)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(BakeStrings.done) { dismiss() }
                }
            }
            .onReceive(ticker) { value in
                now = value
            }
        }
    }
}
