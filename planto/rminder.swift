
//  
import SwiftUI

struct RontentView: View {
    @Environment(\.dismiss) var dismiss

    @State private var plantName: String = ""
    @State private var room: String = "Bedroom"
    @State private var light: String = "Full sun"
    @State private var wateringDays: String = "Every day"
    @State private var waterAmount: String = "20–50 ml"

    let roomOptions = ["Bedroom", "Living Room", "Balcony", "Kitchen"]
    let lightOptions = ["Full sun", "Partial shade", "Low light"]
    let daysOptions = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    let waterOptions = ["20–50 ml", "50–100 ml", "100–200 ml", "200–300 ml"]

    @State private var isActive = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Plant Name", text: $plantName)
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
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveReminder()
                        isActive = true
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.lightGreen).opacity(0.65))                }
            }

            .navigationDestination(isPresented: $isActive) {
                TodayReminder()
                      .navigationBarBackButtonHidden(true)
                  }
        }
    }

    func saveReminder() {
        print("Saved: \(plantName), \(room), \(light), \(wateringDays), \(waterAmount)")
    }
}

#Preview{
           RontentView()
        }
