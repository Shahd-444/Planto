//
//  delet.swift
//  planto
//
//  Created by Shahd Muharrq on 04/05/1447 AH.
//

import SwiftUI
import Combine

// MARK: - ViewModel
final class EditPlantViewModel: ObservableObject {
    // Inputs
    @Published var plantName: String = ""
    @Published var room: String = "Bedroom"
    @Published var light: String = "Full sun"
    @Published var wateringDays: String = "Every day"
    @Published var waterAmount: String = "20–50 ml"

    // Options
    let roomOptions = ["Bedroom", "Living Room", "Balcony", "Kitchen"]
    let lightOptions = ["Full sun", "Partial shade", "Low light"]
    let daysOptions = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    let waterOptions = ["20–50 ml", "50–100 ml", "100–200 ml", "200–300 ml"]

    // Dependencies
    private let store: PlantStore
    private let originalPlant: Plant

    // Outputs
    @Published var showDeleteAlert: Bool = false

    init(store: PlantStore, plant: Plant) {
        self.store = store
        self.originalPlant = plant
        loadCurrentValues()
    }

    func loadCurrentValues() {
        if let latest = store.plant(with: originalPlant.id) {
            plantName = latest.name
            room = latest.room
            light = latest.sun
            wateringDays = latest.wateringDays
            waterAmount = latest.water
        } else {
            plantName = originalPlant.name
            room = originalPlant.room
            light = originalPlant.sun
            wateringDays = originalPlant.wateringDays
            waterAmount = originalPlant.water
        }
    }

    var isSaveDisabled: Bool {
        plantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func saveChanges() {
        var updated = originalPlant
        updated.name = plantName.trimmingCharacters(in: .whitespacesAndNewlines)
        updated.room = room
        updated.sun = light
        updated.wateringDays = wateringDays
        updated.water = waterAmount
        store.update(updated)
    }

    func requestDelete() {
        showDeleteAlert = true
    }

    func confirmDelete() {
        store.delete(id: originalPlant.id)
    }
}

// MARK: - View
struct EditPlantView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: EditPlantViewModel

    init(store: PlantStore, plant: Plant) {
        _viewModel = StateObject(wrappedValue: EditPlantViewModel(store: store, plant: plant))
    }

    var body: some View {
        Form {
            Section {
                TextField("Plant Name", text: $viewModel.plantName)
                    .textInputAutocapitalization(.words)
            }

            Section(header: Text("Room & Light")) {
                Picker("Room", selection: $viewModel.room) {
                    ForEach(viewModel.roomOptions, id: \.self) { Text($0) }
                }

                Picker("Light", selection: $viewModel.light) {
                    ForEach(viewModel.lightOptions, id: \.self) { Text($0) }
                }
            }

            Section(header: Text("Watering")) {
                Picker("Watering Days", selection: $viewModel.wateringDays) {
                    ForEach(viewModel.daysOptions, id: \.self) { Text($0) }
                }

                Picker("Water Amount", selection: $viewModel.waterAmount) {
                    ForEach(viewModel.waterOptions, id: \.self) { Text($0) }
                }
            }

            Section {
                Button("Delete Reminder", role: .destructive) {
                    viewModel.requestDelete()
                }
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Edit Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button { dismiss() } label: { Image(systemName: "xmark") }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    viewModel.saveChanges()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark").foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.lightGreen).opacity(0.65))
                .disabled(viewModel.isSaveDisabled)
            }
        }
        .alert("Delete Reminder", isPresented: $viewModel.showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.confirmDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this reminder?")
        }
    }
}

#Preview {
    let store = PlantStore()
    store.add(name: "Monstera", room: "Living Room", sun: "Partial shade", wateringDays: "Every 3 days", water: "100–200 ml")
    return NavigationStack {
        if let first = store.plants.first {
            EditPlantView(store: store, plant: first)
        }
    }
}
