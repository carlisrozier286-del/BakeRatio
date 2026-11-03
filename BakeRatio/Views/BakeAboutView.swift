import SwiftUI

struct BakeAboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section(BakeStrings.aboutWhatTitle) {
                    Text(BakeStrings.aboutWhat)
                        .font(.callout)
                }

                Section {
                    NavigationLink {
                        BakeSettingsView()
                    } label: {
                        Label(BakeStrings.settings, systemImage: "slider.horizontal.3")
                    }
                }

                Section(BakeStrings.aboutDataTitle) {
                    Text(BakeStrings.aboutData)
                        .font(.callout)
                }

                Section(BakeStrings.aboutPrivacyTitle) {
                    Text(BakeStrings.aboutPrivacy)
                        .font(.callout)
                }

                Section(BakeStrings.aboutDisclaimerTitle) {
                    Text(BakeStrings.aboutDisclaimer)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    HStack {
                        Text(BakeStrings.appName)
                        Spacer()
                        Text(BakeStrings.aboutVersion)
                            .foregroundStyle(.secondary)
                    }
                    .font(.footnote)
                }
            }
            .navigationTitle(BakeStrings.about)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(BakeStrings.done) { dismiss() }
                }
            }
        }
    }
}

struct BakeSettingsView: View {
    @EnvironmentObject private var state: BakeAppState

    var body: some View {
        List {
            Section(BakeStrings.timingEstimate) {
                Stepper(value: $state.settings.roomTemp, in: 15...32, step: 1) {
                    HStack {
                        Text(BakeStrings.roomTemp)
                        Spacer()
                        Text("\(Int(state.settings.roomTemp)) ℃")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            }

            Section(BakeStrings.waterTempTitle) {
                BakeStepperRow(title: BakeStrings.desiredDoughTemp,
                               value: $state.settings.desiredDoughTemp, range: 16...30, suffix: " ℃")
                BakeStepperRow(title: BakeStrings.flourTemp,
                               value: $state.settings.flourTemp, range: 10...30, suffix: " ℃")
                BakeStepperRow(title: BakeStrings.friction,
                               value: $state.settings.friction, range: 0...8, suffix: " ℃")
            }

            Section(BakeStrings.planTitle) {
                BakeStepperRow(title: BakeStrings.folds,
                               value: $state.settings.folds, range: 0...4)
            }

            Section(BakeStrings.sectionResult) {
                Stepper(value: $state.settings.loafWeightTarget, in: 300...1200, step: 25) {
                    HStack {
                        Text(BakeStrings.loafTarget)
                        Spacer()
                        Text(BakeNumbers.grams(state.settings.loafWeightTarget))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }

                Toggle(BakeStrings.showStarterSplit, isOn: $state.settings.showStarterSplit)
            }

            Section {
                Text(BakeStrings.unitsNote)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(BakeStrings.settings)
        .navigationBarTitleDisplayMode(.inline)
    }
}
