//
//  delet.swift
//  planto
//
//  Created by Shahd Muharrq on 04/05/1447 AH.
//

import SwiftUI

struct EditPlantView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: PlantStore

    // نستقبل نسخة من النبات للتعديل
    let plant: Plant

    // حالات قابلة للتعديل
    @State private var plantName: String = ""
    @State private var room: String = "Bedroom"
    @State private var light: String = "Full sun"
    @State private var wateringDays: String = "Every day"
    @State private var waterAmount: String = "20–50 ml"

    let roomOptions = ["Bedroom", "Living Room", "Balcony", "Kitchen"]
    let lightOptions = ["Full sun", "Partial shade", "Low light"]
    let daysOptions = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    let waterOptions = ["20–50 ml", "50–100 ml", "100–200 ml", "200–300 ml"]

    @State private var showDeleteAlert = false

    var body: some View {
        Form {
            Section {
                TextField("Plant Name", text: $plantName)
                    .textInputAutocapitalization(.words)
            }

            Section(header: Text("Room & Light")) {
                Picker("Room", selection: $room) {
                    ForEach(roomOptions, id: \.self) { Text($0) }
                }

                Picker("Light", selection: $light) {
                    ForEach(lightOptions, id: \.self) { Text($0) }
                }
            }

            Section(header: Text("Watering")) {
                Picker("Watering Days", selection: $wateringDays) {
                    ForEach(daysOptions, id: \.self) { Text($0) }
                }

                Picker("Water Amount", selection: $waterAmount) {
                    ForEach(waterOptions, id: \.self) { Text($0) }
                }
            }

            // زر الحذف بنفس الشكل القديم، لكن وظيفي
            Section {
                Button("Delete Reminder", role: .destructive) {
                    showDeleteAlert = true
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
                    saveChanges()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark").foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.lightGreen).opacity(0.65))
                .disabled(plantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear {
            // تعبئة الحقول بالقيم الحالية
            if let latest = store.plant(with: plant.id) {
                plantName = latest.name
                room = latest.room
                light = latest.sun
                wateringDays = latest.wateringDays
                waterAmount = latest.water
            } else {
                plantName = plant.name
                room = plant.room
                light = plant.sun
                wateringDays = plant.wateringDays
                waterAmount = plant.water
            }
        }
        .alert("Delete Reminder", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                store.delete(id: plant.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this reminder?")
        }
    }

    private func saveChanges() {
        var updated = plant
        updated.name = plantName
        updated.room = room
        updated.sun = light
        updated.wateringDays = wateringDays
        updated.water = waterAmount
        store.update(updated)
    }
}

#Preview {
    let store = PlantStore()
    store.add(name: "Monstera", room: "Living Room", sun: "Partial shade", wateringDays: "Every 3 days", water: "100–200 ml")
    return NavigationStack {
        if let first = store.plants.first {
            EditPlantView(plant: first)
                .environmentObject(store)
        }
    }
}
