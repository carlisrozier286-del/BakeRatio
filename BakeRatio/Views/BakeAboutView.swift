import SwiftUI

struct BakeAboutView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var state: BakeAppState

    var body: some View {
        NavigationStack {
            List {
                Section(BakeStrings.aboutWhatTitle) {
                    Text(BakeStrings.aboutWhat)
                        .font(.callout)
                }

                Section(BakeStrings.aboutSettings) {
                    HStack {
                        Text(BakeStrings.roomTemp)
                        Spacer()
                        Text("\(Int(state.settings.roomTemp)) ℃")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    Stepper("", value: $state.settings.roomTemp, in: 15...32, step: 1)
                        .labelsHidden()
                    Toggle(BakeStrings.starter, isOn: $state.settings.showStarterSplit)
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
