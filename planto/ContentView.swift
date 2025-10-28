//
//  ContentView.swift
//  planto
//
//  Created by Shahd Muharrq on 26/04/1447 AH.
//

import SwiftUI
import Combine

// MARK: - ViewModel
final class ContentViewModel: ObservableObject {
    // Presentation state
    @Published var isSheetPresented: Bool = false

    // Business/presentation logic hooks (expand later if needed)
    func openSetReminderSheet() {
        isSheetPresented = true
    }

    func closeSetReminderSheet() {
        isSheetPresented = false
    }

    // Example: decide if we should skip welcome and go to TodayReminder directly
    // (Not used now, but ready if you want)
    func shouldSkipWelcome(plantsCount: Int) -> Bool {
        plantsCount > 0
    }
}

// MARK: - View
struct ContentView: View {

    @EnvironmentObject var store: PlantStore
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // Divider أسفل العنوان
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.30))
                    .padding(.horizontal)
                    .padding(.top, 12)

                // المحتوى الرئيسي متمركز رأسياً
                MainContent(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .preferredColorScheme(.dark)
            .navigationTitle("My Plants 🌱")
        }
    }

    // MARK: - Subview
    struct MainContent: View {
        @EnvironmentObject var store: PlantStore
        @ObservedObject var viewModel: ContentViewModel

        var body: some View {
            VStack(spacing: 20) {
                // الصورة في المنتصف
                Image("planto")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .padding(.horizontal, 24)

                Text("Start your planto journey!")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Text("Now all your plants will be in one place and we will help you to take care of them :) 🪴")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // زر بأسفل الكتلة مع Glass effect
                GlassEffectContainer {
                    Button("Set Plant Reminders") {
                        viewModel.openSetReminderSheet()
                    }
                    .font(.headline)
                    .bold()
                    .frame(width: 280, height: 44)
                    .shadow(radius: 6, y: 3)
                    .foregroundColor(.white)
                    .cornerRadius(60)
                }
                .glassEffect(.regular.tint(Color.lightGreen.opacity(0.65)).interactive())
                .padding(.bottom, 24) // إنزال الزر شوي تحت
                .sheet(isPresented: $viewModel.isSheetPresented) {
                    RontentView(store: store)
                        .environmentObject(store)
                }
            }
            // لإبقاء الكتلة كلها في المنتصف عمودياً
            .padding(.top, 40) // عدّلها أو احذفها حسب تموضع الكتلة
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PlantStore())
}
