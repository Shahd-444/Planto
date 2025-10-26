import SwiftUI
import Combine

// Model
struct Plant: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var room: String
    var sun: String
    var wateringDays: String
    var water: String
}

// Store
final class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []

    func add(name: String, room: String, sun: String, wateringDays: String, water: String) {
        let plant = Plant(name: name, room: room, sun: sun, wateringDays: wateringDays, water: water)
        plants.append(plant)
    }

    func delete(id: UUID) {
        plants.removeAll { $0.id == id }
    }

    func update(_ updated: Plant) {
        if let idx = plants.firstIndex(where: { $0.id == updated.id }) {
            plants[idx] = updated
        }
    }

    func plant(with id: UUID) -> Plant? {
        plants.first(where: { $0.id == id })
    }
}

