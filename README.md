# Planto 🌱

A SwiftUI app to track your plants and get reminded when it’s time to water them. Built with MVVM, a simple in-memory store, and local notifications for reminders.

---

## ✨ Features

- **Add plants with details**
  - Name
  - Room (Bedroom, Living Room, Balcony, Kitchen)
  - Light requirement (Full sun, Partial shade, Low light)
  - Watering cadence (Every day, Every 2 days, Every 3 days, Once a week, Every 10 days, Every 2 weeks)
  - Water amount (20–50 ml, 50–100 ml, 100–200 ml, 200–300 ml)

- **Today screen**
  - List of plants with quick selection
  - Progress indicator of watered plants
  - Tap to edit plant details
  - Delete reminders

- **Local notifications**
  - Per-plant scheduling using `UNUserNotificationCenter`
  - Foreground banner/list presentation
  - Development-friendly short intervals for testing (e.g., “Every day” = 10 seconds)

- **Modern SwiftUI app patterns**
  - MVVM with `@StateObject` and `@EnvironmentObject`
  - `NavigationStack` and `navigationDestination`
  - `Form`, `Picker`, `List`, and sheets for add/edit flows
  - Centralized `NotificationManager` with async/await permission request

- **Lightweight data model**
  - In-memory `PlantStore` with add/update/delete
  - Identifiable `Plant` model for SwiftUI Lists

---

## 🖥 Screens and Flow

- **TodayReminder**
  - Default landing screen
  - Shows header, subtitle, progress, and a list of plants
    - Button opens the Add Reminder sheet

- **Add Reminder (`RontentView`)**
  - Form to enter new plant info
  - Validates name input
  - On save: Adds plant, schedules notification, navigates back to TodayReminder

- **Edit Reminder**
  - Form to update existing plant
  - Delete reminder option with confirmation alert

---

## 🧠 Architecture

- **MVVM**
  - `ReminderViewModel`: manages add flow and scheduling
  - `EditPlantViewModel`: manages editing and deletion
  - `TodayReminderViewModel`: manages list, selection, and sheets (referenced; assumed present in project)

- **Data Layer**
  - `PlantStore`: `ObservableObject` holding `[Plant]` in memory
  - `Plant`: `Identifiable`, `Equatable` struct with plant details

- **Notifications**
  - `NotificationManager`: Singleton handling authorization, scheduling, cancelation, and foreground presentation
  - Uses `UNTimeIntervalNotificationTrigger` for development intervals

---

## 📦 Requirements

- Xcode 15 or later
- iOS 17 or later (SwiftUI `NavigationStack` and modern APIs)
- Swift Concurrency (`async/await`) enabled
- User Notifications capability (Local notifications)

---

## 🚀 Setup

1. Open the project in Xcode.
2. Ensure the “Push Notifications” and “Background Modes” capabilities are configured if needed for your testing scenario. For local notifications, enable “User Notifications.”
3. On first launch, the app should request notification permission. You can also proactively call:

```swift
UNUserNotificationCenter.current().delegate = NotificationManager.shared
await NotificationManager.shared.requestAuthorization()
