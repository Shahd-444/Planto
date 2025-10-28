//
//  welldone.swift
//  planto
//
//  Created by Shahd Muharrq on 04/05/1447 AH.
//

import SwiftUI
import Combine

// MARK: - ViewModel
final class WellDoneViewModel: ObservableObject {
    @Published var isAdding: Bool = false
    func openAddSheet() { isAdding = true }
    func closeAddSheet() { isAdding = false }
}

// MARK: - View
struct WellDone: View {
    @EnvironmentObject private var store: PlantStore
    @StateObject private var viewModel = WellDoneViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 6) {
                        Text("My Plants")
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                        Text("🌱").font(.system(size: 36))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Divider منزول شوي تحت
                    Divider()
                        .frame(height: 1)
                        .background(Color.gray.opacity(0.30))
                        .padding(.horizontal)
                        .padding(.top, 12) // نزّلناه 12 نقطة تحت العنوان

                    Spacer().frame(height: 92)

                    // صورة كبيرة مع ظل دائري خلفها مثل اللقطة
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 260, height: 260)
                            .blur(radius: 0)
                        Image("well") // استبدلها بصورة النبات المطلوبة إن رغبت
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 220)
                    }
                    .padding(.top, 8)

                    Spacer().frame(height: 24)

                    Text("All Done! 🎉")
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Spacer().frame(height: 8)

                    Text("All Reminders Completed")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer() // يدفع المحتوى ليترك مساحة للزر السفلي
                }
                .padding(.bottom, 0)

                // زر + دائري أسفل يمين مع Glass Effect وتفاعل
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        GlassEffectContainer {
                            Button {
                                viewModel.openAddSheet()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(
                                        Circle()
                                            .fill(Color("lightGreen").opacity(0.65))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        .glassEffect(.regular.tint(Color("lightGreen").opacity(0.65)).interactive())
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .padding(.trailing, 20)
                        .padding(.bottom, 28)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isAdding, onDismiss: {
                viewModel.closeAddSheet()
            }) {
                RontentView(store: store)
                    .environmentObject(store)
            }
            .preferredColorScheme(.dark)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    WellDone()
        .environmentObject(PlantStore())
}
