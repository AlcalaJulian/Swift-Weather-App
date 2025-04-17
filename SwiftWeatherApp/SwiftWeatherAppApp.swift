//
//  SwiftWeatherAppApp.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 22/12/24.
//

import SwiftUI

@main
struct SwiftWeatherAppApp: App {
    @State private var coreDataStack = CoreDataStack.shared
    @StateObject private var settings = SettingsStore()

    var body: some Scene {
        WindowGroup {
            CitiesListView()
                .environment(\.managedObjectContext,
                              coreDataStack.container.viewContext)
                .environmentObject(settings)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)  
        }
    }
}
