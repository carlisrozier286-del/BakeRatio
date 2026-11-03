import SwiftUI

struct BakeRecipeListView: View {
    @EnvironmentObject private var state: BakeAppState
    @Binding var mix: BakeMix
    var onUse: () -> Void

    @State private var showNameDialog = false
    @State private var newName = ""

    var body: some View {
        List {
            Section {
                if state.store.recipes.isEmpty {
                    Text(BakeStrings.noRecipes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                ForEach(state.store.recipes) { recipe in
                    NavigationLink {
                        BakeRecipeDetailView(recipe: recipe, mix: $mix, onUse: onUse)
                    } label: {
                        row(recipe)
                    }
                }
                .onDelete { offsets in
                    state.store.deleteRecipes(at: offsets)
                }
            } header: {
                Text("\(state.store.recipes.count) saved")
            }
        }
        .navigationTitle(BakeStrings.tabRecipes)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    newName = ""
                    showNameDialog = true
                } label: {
                    Label(BakeStrings.saveCurrent, systemImage: "plus")
                }
            }
        }
        .alert(BakeStrings.recipeName, isPresented: $showNameDialog) {
            TextField(BakeStrings.recipeName, text: $newName)
            Button(BakeStrings.saveRecipe) {
                let name = newName.trimmingCharacters(in: .whitespaces)
                guard !name.isEmpty else { return }
                state.store.save(recipe: mix.asRecipe(named: name))
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    private func row(_ recipe: BakeRecipe) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(recipe.name)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text(BakeNumbers.grams(recipe.formula.totalGrams))
                    .font(.caption)
                    .foregroundStyle(BakePalette.crust)
                    .monospacedDigit()
            }
            Text(recipe.summary)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("\(recipe.loaves) loaf · \(BakeNumbers.grams(recipe.formula.weightPerLoaf(loaves: recipe.loaves))) each")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .padding(.vertical, 2)
    }
}

struct BakeRecipeDetailView: View {
    @EnvironmentObject private var state: BakeAppState
    @Environment(\.dismiss) private var dismiss

    let recipe: BakeRecipe
    @Binding var mix: BakeMix
    var onUse: () -> Void

    @State private var note = ""
    @State private var loaded = false

    private var current: BakeRecipe {
        state.store.recipes.first(where: { $0.id == recipe.id }) ?? recipe
    }

    private var lines: [BakeIngredientLine] {
        BakeIngredients.mainLines(current.formula)
    }

    var body: some View {
        List {
            Section {
                ForEach(lines) { line in
                    HStack {
                        Text(line.name)
                        Spacer()
                        Text(BakeNumbers.percent(line.percentOfFlour))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                        Text(BakeNumbers.grams(line.grams))
                            .monospacedDigit()
                    }
                }
            } header: {
                Text(current.summary)
            } footer: {
                Text("\(BakeNumbers.grams(current.formula.totalGrams)) total · \(current.loaves) loaf")
            }

            Section(BakeStrings.recipeNote) {
                TextField(BakeStrings.recipeNotePlaceholder, text: $note, axis: .vertical)
                    .lineLimit(2...6)
                    .font(.callout)
            }

            Section {
                Button {
                    mix = BakeMix.from(current)
                    onUse()
                    dismiss()
                } label: {
                    Label(BakeStrings.useInCalculator, systemImage: "arrow.down.left.circle")
                }

                Button(role: .destructive) {
                    state.store.delete(recipe: current)
                    dismiss()
                } label: {
                    Label(BakeStrings.delete, systemImage: "trash")
                }
            }
        }
        .navigationTitle(current.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            note = current.note
            loaded = true
        }
        .onChange(of: note) { _, newValue in
            guard loaded else { return }
            var copy = current
            copy.note = newValue
            state.store.save(recipe: copy)
        }
    }
}
