//  
import SwiftUI

// MARK: - Set Reminder (View)
struct RontentView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PlantStore

    // ViewModel يمسك كل حالة الشاشة ومنطقها
    @StateObject private var viewModel: ReminderViewModel

    // حقن الـ Store داخل الـ ViewModel (MVVM حقيقي)
    init(store: PlantStore) {
        _viewModel = StateObject(wrappedValue: ReminderViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            Form {
                // الاسم
                Section {
                    TextField("Plant Name", text: $viewModel.plantName)
                        .textInputAutocapitalization(.words)
                }

                // الغرفة والإضاءة
                Section(header: Text("Room & Light")) {
                    Picker("Room", selection: $viewModel.room) {
                        ForEach(viewModel.roomOptions, id: \.self) { Text($0) }
                    }
                    Picker("Light", selection: $viewModel.light) {
                        ForEach(viewModel.lightOptions, id: \.self) { Text($0) }
                    }
                }

                // السقي
                Section(header: Text("Watering")) {
                    Picker("Watering Days", selection: $viewModel.wateringDays) {
                        ForEach(viewModel.daysOptions, id: \.self) { Text($0) }
                    }
                    Picker("Water Amount", selection: $viewModel.waterAmount) {
                        ForEach(viewModel.waterOptions, id: \.self) { Text($0) }
                    }
                }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button { viewModel.saveReminder() } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("lightGreen").opacity(0.65))
                    .disabled(viewModel.isSaveDisabled)
                }
            }
            // التنقل بعد الحفظ يدار من الـ ViewModel عبر isActive
            .navigationDestination(isPresented: $viewModel.isActive) {
                // مرّر الـ store هنا
                TodayReminder(store: store)
                    .environmentObject(store)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    RontentView(store: PlantStore())
        .environmentObject(PlantStore())
}
