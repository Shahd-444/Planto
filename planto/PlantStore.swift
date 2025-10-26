import SwiftUI
import Combine

// Model
struct Plant: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let room: String
    let sun: String
    let wateringDays: String
    let water: String
}

// Store
final class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []

    func add(name: String, room: String, sun: String, wateringDays: String, water: String) {
        let plant = Plant(name: name, room: room, sun: sun, wateringDays: wateringDays, water: water)
        plants.append(plant)
    }
}
