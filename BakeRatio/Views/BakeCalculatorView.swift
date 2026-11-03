import SwiftUI

struct BakeCalculatorView: View {
    @EnvironmentObject private var state: BakeAppState
    @Binding var mix: BakeMix
    var onOpenRecipes: () -> Void
    var onOpenTiming: () -> Void

    @State private var showSaveDialog = false
    @State private var recipeName = ""
    @State private var showLogged = false

    private var formula: BakeFormula { mix.formula }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                modeCard
                sizeCard
                ratioCard
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

    private var modeCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Picker("", selection: $mix.mode) {
                ForEach(BakeInputMode.allCases) { m in
                    Text(m.title).tag(m)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.top, 8)
    }

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

            Button {
                state.store.log(BakeLogEntry(name: BakeStrings.appName,
                                             totalGrams: formula.totalGrams,
                                             loaves: mix.loaves,
                                             roomTemp: state.settings.roomTemp))
                showLogged = true
            } label: {
                Label(BakeStrings.logBake, systemImage: "checkmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .overlay(alignment: .topTrailing) {
                if showLogged {
                    Text("logged")
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
