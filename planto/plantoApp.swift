import SwiftUI
import UserNotifications

@main
struct plantoApp: App {
    @StateObject private var store = PlantStore()

    init() {
        // تعيين الـ delegate لعرض الإشعارات حتى في foreground
        UNUserNotificationCenter.current().delegate = NotificationManager.shared

        // استدعاء الدالة async داخل Task
        Task {
            _ = await NotificationManager.shared.requestAuthorization()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
