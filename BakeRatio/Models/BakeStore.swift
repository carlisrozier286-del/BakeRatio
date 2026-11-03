import Foundation
import Combine

/// 本地存储：配方与烘焙记录写入 App 沙盒内的一个 JSON 文件，不上传任何数据。
final class BakeStore: ObservableObject {
    @Published private(set) var recipes: [BakeRecipe] = []
    @Published private(set) var bakes: [BakeLogEntry] = []

    private struct Payload: Codable {
        var recipes: [BakeRecipe]
        var bakes: [BakeLogEntry]
    }

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("bakeratio.json")
    }

    init() { load() }

    // MARK: 配方

    func save(recipe: BakeRecipe) {
        if let i = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[i] = recipe
        } else {
            recipes.append(recipe)
        }
        persist()
    }

    func delete(recipe: BakeRecipe) {
        recipes.removeAll { $0.id == recipe.id }
        persist()
    }

    func deleteRecipes(at offsets: IndexSet) {
        remove(from: &recipes, offsets: offsets)
        persist()
    }

    // MARK: 烘焙记录

    func log(_ entry: BakeLogEntry) {
        bakes.append(entry)
        persist()
    }

    func deleteBakes(at offsets: IndexSet) {
        remove(from: &bakes, offsets: offsets)
        persist()
    }

    /// 从数组里删掉给定下标（不依赖 SwiftUI 的 remove(atOffsets:)）
    private func remove<T>(from array: inout [T], offsets: IndexSet) {
        for index in offsets.sorted(by: >) where array.indices.contains(index) {
            array.remove(at: index)
        }
    }

    // MARK: 持久化

    private func persist() {
        let payload = Payload(recipes: recipes, bakes: bakes)
        guard let data = try? JSONEncoder().encode(payload) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let payload = try? JSONDecoder().decode(Payload.self, from: data) else { return }
        recipes = payload.recipes
        bakes = payload.bakes
    }
}
