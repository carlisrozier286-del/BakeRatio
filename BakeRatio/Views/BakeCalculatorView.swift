import SwiftUI

struct BakeCalculatorView: View {
    @EnvironmentObject private var state: BakeAppState
    @Binding var mix: BakeMix
    var onOpenAbout: () -> Void

    @State private var showSaveDialog = false
    @State private var recipeName = ""
    @State private var showLogged = false
    @State private var showWaterTemp = false

    private var formula: BakeFormula { mix.formula }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                presetRow
                modeCard
                sizeCard
                ratioCard
                waterCard
                ingredientCard
                BakeResultCard(formula: formula, loaves: mix.loaves)
                actionRow
                Text(BakeStrings.timingNote)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }
            .padding(.horizontal)
            .padding(.bottom, 28)
        }
        .background(BakePalette.cream.opacity(0.35))
        .navigationTitle(BakeStrings.tabDough)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onOpenAbout) {
                    Image(systemName: "info.circle")
                }
                .accessibilityLabel(BakeStrings.about)
            }
        }
        .alert(BakeStrings.recipeName, isPresented: $showSaveDialog) {
            TextField(BakeStrings.recipeName, text: $recipeName)
            Button(BakeStrings.saveRecipe) {
                let name = recipeName.trimmingCharacters(in: .whitespaces)
                guard !name.isEmpty else { return }
                state.store.save(recipe: mix.asRecipe(named: name))
                recipeName = ""
            }
            Button("Cancel", role: .cancel) { recipeName = "" }
        }
    }

    // MARK: 风格预设

    private var presetRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(BakeStrings.sectionPresets)
                .font(.caption)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(BakePreset.all) { preset in
                        Button {
                            mix.hydration = preset.hydration
                            mix.saltPct = preset.saltPct
                            mix.starterPct = preset.starterPct
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(preset.name)
                                    .font(.subheadline.weight(.semibold))
                                Text(preset.note)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isActive(preset) ? BakePalette.flour.opacity(0.55) : BakePalette.card)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(.top, 8)
    }

    private func isActive(_ preset: BakePreset) -> Bool {
        abs(mix.hydration - preset.hydration) < 0.005
            && abs(mix.saltPct - preset.saltPct) < 0.0005
            && abs(mix.starterPct - preset.starterPct) < 0.005
    }

    // MARK: 模式

    private var modeCard: some View {
        Picker("", selection: $mix.mode) {
            ForEach(BakeInputMode.allCases) { mode in
                Text(mode.title).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: 份量

    private var sizeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(BakeStrings.sectionSize)
                .font(.caption)
                .foregroundStyle(.secondary)

            if mix.mode == .flour {
                BakeGramFieldRow(title: BakeStrings.flourWeight, grams: $mix.flourGrams, step: 50)
            } else {
                BakeGramFieldRow(title: BakeStrings.doughWeight, grams: $mix.totalDoughGrams, step: 50)
            }

            BakeStepperRow(title: BakeStrings.loaves, value: $mix.loaves, range: 1...8)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(BakePalette.card))
    }

    // MARK: 比例

    private var ratioCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(BakeStrings.sectionRatio)
                .font(.caption)
                .foregroundStyle(.secondary)

            BakeSliderRow(title: BakeStrings.hydration,
                          valueText: BakeNumbers.percent(mix.hydration),
                          value: $mix.hydration, range: 0.50...1.00, step: 0.01)
            BakeSliderRow(title: BakeStrings.salt,
                          valueText: BakeNumbers.percentFine(mix.saltPct),
                          value: $mix.saltPct, range: 0.005...0.035, step: 0.0005)
            BakeSliderRow(title: BakeStrings.starter,
                          valueText: BakeNumbers.percent(mix.starterPct),
                          value: $mix.starterPct, range: 0.05...0.40, step: 0.01)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(BakePalette.card))
    }

    // MARK: 水温

    private var waterTemp: Double {
        BakeTempMath.waterTemperature(desired: Double(state.settings.desiredDoughTemp),
                                     room: state.settings.roomTemp,
                                     flour: Double(state.settings.flourTemp),
                                     starter: state.settings.roomTemp,
                                     friction: Double(state.settings.friction),
                                     includesStarter: mix.starterPct > 0.02)
    }

    private var waterTempText: String {
        String(format: "%.0f ℃", waterTemp)
    }

    private var waterCard: some View {
        DisclosureGroup(isExpanded: $showWaterTemp) {
            VStack(spacing: 10) {
                BakeStepperRow(title: BakeStrings.desiredDoughTemp,
                               value: $state.settings.desiredDoughTemp, range: 16...30, suffix: " ℃")
                BakeStepperRow(title: BakeStrings.flourTemp,
                               value: $state.settings.flourTemp, range: 10...30, suffix: " ℃")
                BakeStepperRow(title: BakeStrings.friction,
                               value: $state.settings.friction, range: 0...8, suffix: " ℃")

                HStack {
                    Text(BakeStrings.waterNeeded)
                    Spacer()
                    Text(waterTempText)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(BakePalette.crust)
                        .monospacedDigit()
                }

                Text(BakeTempMath.advice(for: waterTemp))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 8)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(BakeStrings.waterTempTitle)
                        .font(.subheadline.weight(.medium))
                    Text(BakeStrings.waterTempSubtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(waterTempText)
                    .font(.headline)
                    .foregroundStyle(BakePalette.crust)
                    .monospacedDigit()
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(BakePalette.card))
    }

    // MARK: 配料

    private var ingredientCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(BakeStrings.sectionResult)
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(BakeIngredients.mainLines(formula)) { line in
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(line.name)
                        if !line.note.isEmpty {
                            Text(line.note)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text(BakeNumbers.percent(line.percentOfFlour))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                    Text(BakeNumbers.grams(line.grams))
                        .monospacedDigit()
                        .frame(minWidth: 78, alignment: .trailing)
                }
            }

            if state.settings.showStarterSplit {
                Divider()
                Text(BakeStrings.starter)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                ForEach(BakeIngredients.starterLines(formula)) { line in
                    HStack {
                        Text(line.name)
                            .font(.subheadline)
                        Spacer()
                        Text(BakeNumbers.grams(line.grams))
                            .font(.subheadline)
                            .monospacedDigit()
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(BakePalette.card))
    }

    // MARK: 操作

    private var actionRow: some View {
        HStack(spacing: 12) {
            Button {
                recipeName = ""
                showSaveDialog = true
            } label: {
                Label(BakeStrings.saveRecipe, systemImage: "bookmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(mix.mode == .totalDough && mix.totalDoughGrams <= 0)

            Button {
                state.store.log(BakeLogEntry(name: BakeStrings.appName,
                                             totalGrams: formula.totalGrams,
                                             loaves: mix.loaves,
                                             roomTemp: state.settings.roomTemp,
                                             hydration: formula.hydration))
                showLogged = true
            } label: {
                Label(BakeStrings.logBake, systemImage: "checkmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .overlay(alignment: .topTrailing) {
                if showLogged {
                    Text(BakeStrings.logged)
                        .font(.caption2)
                        .foregroundStyle(BakePalette.good)
                        .offset(y: -16)
                }
            }
        }
    }
}

/// 结果卡：总重、单只重量、含酸种的真实面粉/水
struct BakeResultCard: View {
    let formula: BakeFormula
    let loaves: Int

    private var totalFlour: Double { formula.flourGrams + formula.starterFlour }
    private var totalWater: Double { formula.waterGrams + formula.starterWater }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(BakeStrings.total)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(BakeNumbers.grams(formula.totalGrams))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(BakePalette.crust)
                        .monospacedDigit()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(BakeStrings.perLoaf)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(BakeNumbers.grams(formula.weightPerLoaf(loaves: loaves)))
                        .font(.title3.weight(.semibold))
                        .monospacedDigit()
                }
            }

            Divider()

            HStack(spacing: 16) {
                small(BakeStrings.totalFlour, BakeNumbers.grams(totalFlour))
                small(BakeStrings.totalWater, BakeNumbers.grams(totalWater))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(BakePalette.flour.opacity(0.28))
        )
    }

    private func small(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.medium))
                .monospacedDigit()
        }
    }
}
