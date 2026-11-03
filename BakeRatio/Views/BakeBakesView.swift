import SwiftUI

struct BakeBakesView: View {
    @EnvironmentObject private var state: BakeAppState

    private var sorted: [BakeLogEntry] {
        state.store.bakes.sorted { $0.date > $1.date }
    }

    private var averageGrams: Double {
        guard !sorted.isEmpty else { return 0 }
        let total = sorted.reduce(0.0) { $0 + $1.totalGrams }
        return total / Double(sorted.count)
    }

    private var averageScore: Double {
        guard !sorted.isEmpty else { return 0 }
        let total = sorted.reduce(0.0) { $0 + Double($1.score) }
        return total / Double(sorted.count)
    }

    var body: some View {
        List {
            if !sorted.isEmpty {
                Section(BakeStrings.summaryTitle) {
                    statRow(BakeStrings.totalBakes, "\(sorted.count)")
                    statRow(BakeStrings.averageScore, String(format: "%.1f / 5", averageScore))
                    statRow("Average dough", BakeNumbers.grams(averageGrams))
                    if let last = sorted.first {
                        statRow(BakeStrings.lastBake, BakeDate.short(last.date))
                    }
                }
            }

            Section {
                if sorted.isEmpty {
                    Text(BakeStrings.noBakes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                ForEach(sorted) { entry in
                    NavigationLink {
                        BakeBakeDetailView(entry: entry)
                    } label: {
                        row(entry)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            state.store.deleteBake(entry)
                        } label: {
                            Text(BakeStrings.delete)
                        }
                    }
                }
            } header: {
                Text(BakeStrings.tabBakes)
            }
        }
        .navigationTitle(BakeStrings.tabBakes)
    }

    private func statRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .font(.subheadline)
    }

    private func row(_ entry: BakeLogEntry) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(BakeDate.short(entry.date))
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text(String(repeating: "★", count: max(0, min(5, entry.score))))
                    .font(.caption)
                    .foregroundStyle(BakePalette.crust)
            }
            Text("\(BakeNumbers.grams(entry.totalGrams)) · \(entry.loaves) loaf · \(Int(entry.roomTemp)) ℃")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .monospacedDigit()
            if !entry.note.isEmpty {
                Text(entry.note)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 2)
    }
}

struct BakeBakeDetailView: View {
    @EnvironmentObject private var state: BakeAppState
    @Environment(\.dismiss) private var dismiss

    let entry: BakeLogEntry

    @State private var score = 3
    @State private var note = ""
    @State private var loaded = false

    private var current: BakeLogEntry {
        state.store.bakes.first(where: { $0.id == entry.id }) ?? entry
    }

    private func detailRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
        .font(.subheadline)
    }

    var body: some View {
        List {
            Section {
                detailRow(BakeDate.short(current.date), "")
                detailRow(BakeStrings.total, BakeNumbers.grams(current.totalGrams))
                detailRow(BakeStrings.loaves, "\(current.loaves)")
                detailRow(BakeStrings.roomTemp, "\(Int(current.roomTemp)) ℃")
                detailRow(BakeStrings.hydration, BakeNumbers.percent(current.hydration))
            }

            Section(BakeStrings.score) {
                Stepper(value: $score, in: 1...5) {
                    HStack {
                        Text(String(repeating: "★", count: score) + String(repeating: "☆", count: 5 - score))
                            .foregroundStyle(BakePalette.crust)
                        Spacer()
                        Text("\(score) / 5")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            }

            Section(BakeStrings.recipeNote) {
                TextField(BakeStrings.recipeNotePlaceholder, text: $note, axis: .vertical)
                    .lineLimit(2...6)
                    .font(.callout)
            }

            Section {
                Button(role: .destructive) {
                    state.store.deleteBake(current)
                    dismiss()
                } label: {
                    Label(BakeStrings.delete, systemImage: "trash")
                }
            }
        }
        .navigationTitle(BakeStrings.bakesTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            score = current.score
            note = current.note
            loaded = true
        }
        .onChange(of: score) { _, newValue in
            guard loaded else { return }
            var copy = current
            copy.score = newValue
            state.store.update(bake: copy)
        }
        .onChange(of: note) { _, newValue in
            guard loaded else { return }
            var copy = current
            copy.note = newValue
            state.store.update(bake: copy)
        }
    }
}
