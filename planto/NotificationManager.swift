//
//  NotificationManager.swift
//  planto
//
//  Created by Shahd Muharrq on 04/05/1447 AH.
//

import Foundation
import UserNotifications
import Combine

final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    @Published var isAuthorized = false

    private override init() {
        super.init()
        checkAuthorizationStatus()
    }

    // MARK: - Request Permission (async/await)
    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])

            await MainActor.run {
                self.isAuthorized = granted
            }
            return granted
        } catch {
            print("Error requesting notification permission: \(error)")
            return false
        }
    }

    // MARK: - Assign delegate to show banners in foreground
    // نادِ هذا مثلاً من plantoApp.init():
    // UNUserNotificationCenter.current().delegate = NotificationManager.shared
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }

    // MARK: - Check Authorization Status
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    // MARK: - Schedule Notification for Plant (time-interval for testing)
    // يقرأ من Plant.room و Plant.wateringDays (الموجودة في مشروعك)
    func scheduleNotification(for plant: Plant) {
        // Remove existing notification for this plant
        cancelNotification(for: plant)

        let content = UNMutableNotificationContent()
        content.title = "Time to water your plant! 💧"
        content.body = "\(plant.name) in \(plant.room) needs watering"
        content.sound = .default
        content.badge = 1

        // Convert wateringDays string to short test interval (seconds)
        let interval = getTimeInterval(from: plant.wateringDays)

        // For development: schedule after few seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

        let request = UNNotificationRequest(
            identifier: plant.id.uuidString, // ثابت لكل نبتة
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(plant.name) in \(interval)s")
            }
        }
    }

    // MARK: - Cancel Notification for specific plant
    func cancelNotification(for plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }

    // MARK: - Cancel All Notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Get Scheduled Notifications
    func getScheduledNotifications() async -> [UNNotificationRequest] {
        await UNUserNotificationCenter.current().pendingNotificationRequests()
    }

    // MARK: - Map wateringDays to short test intervals (seconds)
    // طوّليها للقيم الحقيقية لاحقاً (أيام) إذا خلصتِ الاختبار
    private func getTimeInterval(from wateringDays: String) -> TimeInterval {
        switch wateringDays {
        case "Every day":
            return 10 // 10 ثواني (المفترض 86400 ثانية)
        case "Every 2 days":
            return 20 // 20 ثانية (المفترض 172800 ثانية)
        case "Every 3 days":
            return 30 // 30 ثانية (المفترض 259200 ثانية)
        case "Once a week":
            return 60 // دقيقة (المفترض 604800 ثانية)
        case "Every 10 days":
            return 120 // دقيقتان (المفترض 864000 ثانية)
        case "Every 2 weeks":
            return 180 // 3 دقائق (المفترض 1209600 ثانية)
        default:
            return 10
        }
    }

    // MARK: - Reset Badge Count
    func resetBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
