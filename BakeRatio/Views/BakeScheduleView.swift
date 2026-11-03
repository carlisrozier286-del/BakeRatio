import SwiftUI

struct BakeScheduleView: View {
    @EnvironmentObject private var state: BakeAppState
    @Binding var mix: BakeMix

    @State private var start = Date()
    @State private var useRetard = true
    @State private var retardHours = 12.0
    @State private var checked: Set<Int> = []
    @State private var now = Date()

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var bulk: (low: Double, high: Double) {
        BakeFerment.window(roomTemp: state.settings.roomTemp, starterPct: mix.starterPct)
    }

    private var steps: [BakeScheduleStep] {
        BakeTimeline.build(bulkHours: (bulk.low + bulk.high) / 2,
                           retardHours: useRetard ? retardHours : 0,
                           folds: state.settings.folds,
                           roomTemp: state.settings.roomTemp)
    }

    private var nextStep: BakeScheduleStep? {
        steps.first { step in
            !checked.contains(step.id)
                && BakeTimeline.clock(start, offsetMinutes: step.offsetMinutes) > now
        }
    }

    var body: some View {
        List {
            nextCardSection

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
                    Text("\(BakeNumbers.hours(bulk.low)) – \(BakeNumbers.hours(bulk.high))")
                        .foregroundStyle(BakePalette.crust)
                        .monospacedDigit()
                }
            }

            Section(BakeStrings.planTitle) {
                DatePicker(BakeStrings.startTime, selection: $start, displayedComponents: [.date, .hourAndMinute])

                HStack {
                    Text(BakeStrings.startNow)
                    Spacer()
                    Button(BakeStrings.startNow) {
                        start = Date()
                        checked = []
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }

                BakeStepperRow(title: BakeStrings.folds, value: $state.settings.folds, range: 0...4)

                Toggle(BakeStrings.coldRetard, isOn: $useRetard)

                if useRetard {
                    Stepper(value: $retardHours, in: 4...24, step: 1) {
                        HStack {
                            Text(BakeStrings.retardHours)
                            Spacer()
                            Text(BakeNumbers.hours(retardHours))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                }
            }

            Section {
                ForEach(steps) { step in
                    stepRow(step)
                }
            } header: {
                HStack {
                    Text(BakeStrings.timelineTitle)
                    Spacer()
                    if !checked.isEmpty {
                        Button(BakeStrings.clearPlan) { checked = [] }
                            .font(.caption2)
                            .buttonStyle(.plain)
                            .foregroundStyle(BakePalette.crust)
                    }
                }
            } footer: {
                Text(BakeStrings.timingNote)
                    .font(.caption2)
            }
        }
        .navigationTitle(BakeStrings.tabSchedule)
        .onReceive(ticker) { value in
            now = value
        }
    }

    private var nextCardSection: some View {
        Section {
            if let step = nextStep {
                VStack(alignment: .leading, spacing: 6) {
                    Text(BakeStrings.nextUp)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(alignment: .firstTextBaseline) {
                        Text(step.title)
                            .font(.title3.weight(.semibold))
                        Spacer()
                        Text(BakeNumbers.clockTime(BakeTimeline.clock(start, offsetMinutes: step.offsetMinutes)))
                            .font(.title3.weight(.bold))
                            .foregroundStyle(BakePalette.crust)
                            .monospacedDigit()
                    }

                    Text(BakeNumbers.countdown(BakeTimeline.clock(start, offsetMinutes: step.offsetMinutes).timeIntervalSince(now)))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(BakePalette.crust)
                        .monospacedDigit()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)

                    Text(step.detail)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            } else {
                Text(BakeStrings.timingNote)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func stepRow(_ step: BakeScheduleStep) -> some View {
        let when = BakeTimeline.clock(start, offsetMinutes: step.offsetMinutes)
        let isDone = checked.contains(step.id)
        let isPast = when < now

        return HStack(alignment: .top, spacing: 12) {
            Button {
                if isDone {
                    checked.remove(step.id)
                } else {
                    checked.insert(step.id)
                }
            } label: {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isDone ? BakePalette.good : Color.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(step.title)
                        .font(.subheadline.weight(isDone ? .regular : .medium))
                        .strikethrough(isDone)
                    Spacer()
                    Text(BakeNumbers.clockTime(when))
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundStyle(isPast && !isDone ? BakePalette.crust : .secondary)
                }
                Text(step.detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 1)
    }
}
