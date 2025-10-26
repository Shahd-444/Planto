//
//  plantoApp.swift
//  planto
//
//  Created by Shahd Muharrq on 26/04/1447 AH.
//

import SwiftUI

@main
struct plantoApp: App {
    @StateObject private var store = PlantStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
