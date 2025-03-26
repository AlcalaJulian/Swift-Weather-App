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
    
    var body: some Scene {
        WindowGroup {
            CitiesListView()
                .environment(\.managedObjectContext,
                              coreDataStack.container.viewContext)
        }
    }
}
