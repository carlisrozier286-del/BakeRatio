import SwiftUI

struct BakeRecipeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var state: BakeAppState
    @Binding var mix: BakeMix

    @State private var showNameDialog = false
    @State private var newName = ""

    var body: some View {
        NavigationStack {
            List {
                if state.store.recipes.isEmpty {
                    Text(BakeStrings.noRecipes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(state.store.recipes) { recipe in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(recipe.name)
                                    .font(.subheadline.weight(.medium))
                                Spacer()
                                Button(BakeStrings.load) {
                                    mix = BakeMix.from(recipe)
                                    dismiss()
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            }
                            Text(recipe.summary)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Text("\(BakeNumbers.grams(recipe.formula.totalGrams)) · \(recipe.loaves) loaf(s)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete { offsets in
                        state.store.deleteRecipes(at: offsets)
                    }
                }

                if !state.store.bakes.isEmpty {
                    Section(BakeStrings.logBake) {
                        ForEach(state.store.bakes.reversed()) { entry in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(BakeDate.short(entry.date))
                                    .font(.caption)
                                Text("\(BakeNumbers.grams(entry.totalGrams)) · \(entry.loaves) loaf(s)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                            }
                        }
                        .onDelete { offsets in
                            state.store.deleteBakes(at: offsets)
                        }
                    }
                }
            }
            .navigationTitle(BakeStrings.recipes)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(BakeStrings.done) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        newName = ""
                        showNameDialog = true
                    } label: {
                        Label(BakeStrings.saveRecipe, systemImage: "plus")
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
    }
}
