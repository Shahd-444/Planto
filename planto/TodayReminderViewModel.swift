import SwiftUI
import Combine

final class TodayReminderViewModel: ObservableObject {

    private let store: PlantStore
    private var cancellables = Set<AnyCancellable>()

    @Published var selectedPlantIDs: Set<UUID> = []
    @Published var isAdding: Bool = false
    @Published var editingPlant: Plant?
    @Published var isWellDonePresented: Bool = false

    @Published private(set) var plants: [Plant] = []

    init(store: PlantStore) {
        self.store = store

        store.$plants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPlants in
                guard let self else { return }
                self.plants = newPlants
                let validIDs = Set(newPlants.map(\.id))
                self.selectedPlantIDs = self.selectedPlantIDs.intersection(validIDs)
                self.checkCompletion()
            }
            .store(in: &cancellables)
    }

    func openAddSheet() { isAdding = true }
    func closeAddSheet() { isAdding = false }
    func openEdit(for plant: Plant) { editingPlant = plant }
    func closeEdit() { editingPlant = nil }

    func toggleSelection(for plantID: UUID) {
        if selectedPlantIDs.contains(plantID) { selectedPlantIDs.remove(plantID) }
        else { selectedPlantIDs.insert(plantID) }
        checkCompletion()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let id = plants[index].id
            store.delete(id: id)
            selectedPlantIDs.remove(id)
        }
        checkCompletion()
    }

    func update(_ updated: Plant) {
        store.update(updated)
    }

    func checkCompletion() {
        let total = plants.count
        guard total > 0 else { isWellDonePresented = false; return }
        isWellDonePresented = selectedPlantIDs.count == total
    }
}
