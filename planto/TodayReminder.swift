import SwiftUI

struct TodayReminder: View {

    @EnvironmentObject private var store: PlantStore
    @StateObject private var viewModel: TodayReminderViewModel

    // حقن صريح للـ store (يفضّل تمريره عند الاستدعاء)
    init(store: PlantStore) {
        _viewModel = StateObject(wrappedValue: TodayReminderViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 10) {
                    header
                    subtitleAndProgress
                    contentList
                }
                .overlay(alignment: .bottomTrailing) { addButton }
            }
            .sheet(item: $viewModel.editingPlant) { plant in
                NavigationStack {
                    EditPlantView(store: store, plant: plant)
                }
            }
            .sheet(isPresented: $viewModel.isWellDonePresented) {
                WellDone().environmentObject(store)
            }
            .toolbar(.hidden)
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - Subviews
    private var header: some View {
        HStack(spacing: 6) {
            Text("My Plants")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
            Text("🌱").font(.system(size: 36))
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var subtitleAndProgress: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.selectedPlantIDs.isEmpty
                 ? (viewModel.plants.isEmpty ? "No plants yet. Tap + to add your first plant 🌱" : "Your plants are waiting for a sip 💦")
                 : "\(viewModel.selectedPlantIDs.count) of your plants feel loved today ✨")
                .font(.callout)
                .foregroundStyle(.secondary)

            ProgressView(value: Double(viewModel.selectedPlantIDs.count), total: Double(max(viewModel.plants.count, 1)))
                .tint(Color("lightGreen"))
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedPlantIDs.count)
        }
        .padding(.horizontal)
    }

    private var contentList: some View {
        Group {
            if viewModel.plants.isEmpty {
                EmptyStateView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.plants) { p in
                        PlantRow(
                            plant: p,
                            selected: viewModel.selectedPlantIDs.contains(p.id),
                            onToggle: { viewModel.toggleSelection(for: p.id) }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.openEdit(for: p) }
                    }
                    .onDelete(perform: viewModel.delete(at:))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }

    private var addButton: some View {
        Button { viewModel.openAddSheet() } label: {
            Image(systemName: "plus")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(Circle().fill(Color("lightGreen").opacity(0.65)))
                .shadow(radius: 6, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 24)
        .sheet(isPresented: $viewModel.isAdding) {
            RontentView(store: store)
                .environmentObject(store)
        }
    }
}

// MARK: - Small subviews
private struct EmptyStateView: View {
    var body: some View {
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
    }
}

private struct PlantRow: View {
    let plant: Plant
    let selected: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 12 ) {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(selected ? Color("lightGreen") : .white)
                    .onTapGesture { onToggle() }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "paperplane")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("in \(plant.room)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text(plant.name)
                        .font(.system(size: 30, weight: .bold, design: .rounded))

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

private struct Badge: View {
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
    // للمعاينة فقط: Store مؤقت
    TodayReminder(store: PlantStore())
        .environmentObject(PlantStore())
}
