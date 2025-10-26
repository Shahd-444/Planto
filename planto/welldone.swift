//
//  welldone.swift
//  planto
//
//  Created by Shahd Muharrq on 04/05/1447 AH.
//

import SwiftUI

struct WellDone: View {
    @EnvironmentObject var store: PlantStore
    @State private var isAdding: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 20) {
                        Divider()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.30))
                        Spacer()
                            .frame(height: 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                    Image("well")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)

                    Text("Well Done! 🎉")
                        .font(.largeTitle.bold())

                    Text("All Reminder Completed")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()
                        .frame(height: 200)
                }
                .padding(.horizontal)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        isAdding = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(Color("lightGreen").opacity(0.65))
                            )
                            .shadow(radius: 6, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 56)
                    .sheet(isPresented: $isAdding) {
                        RontentView()
                            .environmentObject(store)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("My Plants 🌱")
        }
    }
}

#Preview {
    WellDone()
        .environmentObject(PlantStore())
}
