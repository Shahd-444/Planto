import SwiftUI
import Combine

final class ReminderViewModel: ObservableObject {
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

    // Dependency
    private let store: PlantStore

    // Navigation/output
    @Published var isActive: Bool = false

    init(store: PlantStore) {
        self.store = store
    }

    var isSaveDisabled: Bool {
        plantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func saveReminder() {
        let name = plantName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        // 1) حفظ النبات
        store.add(name: name, room: room, sun: light, wateringDays: wateringDays, water: waterAmount)

        // 2) جدولة الإشعار باستخدام NotificationManager الجديد (intervals للاختبار)
        if let plant = store.plants.last {
            NotificationManager.shared.scheduleNotification(for: plant)
        } else {
            print("Warning: Could not find saved plant to schedule notification.")
        }

        // 3) الانتقال
        isActive = true
    }
}
