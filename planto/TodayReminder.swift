//
//
import SwiftUI

struct TodayReminder: View {

    @EnvironmentObject var store: PlantStore
    @State private var selectedPlantIDs: Set<UUID> = []
    @State private var isAdding: Bool = false

    // لفتح شاشة التعديل بدون سهم
    @State private var editingPlant: Plant?

    // الانتقال لصفحة WellDone عند اكتمال التشييك
    @State private var goToWellDone: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 10) {
                    // العنوان
                    HStack(spacing: 6) {
                        Text("My Plants")
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                        Text("🌱").font(.system(size: 36))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // السطر الرمادي + شريط التقدم
                    Text(selectedPlantIDs.isEmpty
                         ? (store.plants.isEmpty ? "No plants yet. Tap + to add your first plant 🌱" : "Your plants are waiting for a sip 💦")
                         : "\(selectedPlantIDs.count) of your plants feel loved today ✨")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    ProgressView(value: Double(selectedPlantIDs.count), total: Double(max(store.plants.count, 1)))
                        .tint(Color("lightGreen"))
                        .padding(.horizontal)
                        .animation(.easeInOut(duration: 0.2), value: selectedPlantIDs.count)

                    // اللستة
                    if store.plants.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "leaf")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            Text("No plants yet")
                                .font(.headline)
                            Text("Tap the + button to add your first plant.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(store.plants) { p in
                                PlantRow(plant: p, selectedPlantIDs: $selectedPlantIDs)
                                    // حتى يصبح الصف كله قابل للضغط بدون سهم
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        editingPlant = p
                                    }
                            }
                            .onDelete(perform: deletePlants)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
                // زر + عائم
                .overlay(alignment: .bottomTrailing) {
                    Button { isAdding = true } label: {
                        Image(systemName: "plus")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color("lightGreen").opacity(0.65)))
                            .shadow(radius: 6, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 24)
                    .sheet(isPresented: $isAdding) {
                        RontentView()
                            .environmentObject(store)
                    }
                }
            }
            // شاشة التعديل
            .sheet(item: $editingPlant, onDismiss: {
                // تحديث بسيط في حال تم حذف العنصر أثناء التعديل
                if let current = editingPlant,
                   store.plants.first(where: { $0.id == current.id }) == nil {
                    editingPlant = nil
                }
            }) { plant in
                NavigationStack {
                    EditPlantView(plant: plant)
                        .environmentObject(store)
                }
            }
            // مراقبة الاكتمال: إذا تم اختيار جميع النباتات، انتقل لصفحة WellDone
            .onChange(of: selectedPlantIDs) { newValue in
                let allChecked = !store.plants.isEmpty && newValue.count == store.plants.count
                goToWellDone = allChecked
            }
            .onChange(of: store.plants) { _ in
                // في حال تغيرت القائمة، أعِد تقييم الاكتمال
                let allChecked = !store.plants.isEmpty && selectedPlantIDs.count == store.plants.count
                goToWellDone = allChecked
            }
            // التنقل لصفحة WellDone
            .navigationDestination(isPresented: $goToWellDone) {
                WellDone()
                    .environmentObject(store)
                    .navigationBarBackButtonHidden(true)
            }
            .toolbar(.hidden)
            .preferredColorScheme(.dark)
        }
    }

    private func deletePlants(at offsets: IndexSet) {
        for index in offsets {
            let id = store.plants[index].id
            store.delete(id: id)
            selectedPlantIDs.remove(id)
        }
    }
}

// صف النبات
struct PlantRow: View {
    let plant: Plant
    @Binding var selectedPlantIDs: Set<UUID>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12 ) {
                // ✅ دائرة فيها صح إذا محددة
                Image(systemName: selectedPlantIDs.contains(plant.id) ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(selectedPlantIDs.contains(plant.id) ? Color("lightGreen") : .white)
                    .onTapGesture {
                        if selectedPlantIDs.contains(plant.id) {
                            selectedPlantIDs.remove(plant.id)
                        } else {
                            selectedPlantIDs.insert(plant.id)
                        }
                    }

                VStack(alignment: .leading, spacing: 6) {
                    // الموقع
                    HStack(spacing: 6) {
                        Image(systemName: "paperplane")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("in \(plant.room)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // الاسم
                    Text(plant.name)
                        .font(.system(size: 30, weight: .bold, design: .rounded))

                    // البادجات
                    HStack(spacing: 8) {
                        Badge(icon: "sun.max", text: plant.sun)
                        Badge(icon: "drop", text: plant.water)
                    }
                }
            }
            Divider().padding(.top, 6)
        }
        .listRowBackground(Color.clear)
        .padding(.vertical, 4)
    }
}

// كبسولة بسيطة
struct Badge: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.footnote)
            Text(text)
                .font(.footnote.weight(.semibold))
                .foregroundColor(text == "Full sun" ? .yellow.opacity(0.60) : .white)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Capsule().fill(Color.white.opacity(0.12)))
    }
}

#Preview {
    TodayReminder()
        .environmentObject(PlantStore())
}
