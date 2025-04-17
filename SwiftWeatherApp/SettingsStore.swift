//
//  SettingsStore.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá on 17/4/25.
//

import SwiftUI
import CoreData

@MainActor
final class SettingsStore: ObservableObject {

    @Published var temperatureUnit: TemperatureUnit
    @Published var windSpeedUnit:   WindSpeedUnit
    @Published var isDarkMode:      Bool

    private let ctx: NSManagedObjectContext
    private let model: UserSettings

    init(context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext) {
        self.ctx = context

        CoreDataStack.shared.ensureUserSettings()
        self.model = CoreDataStack.shared.fetchUserSettings()

        self.temperatureUnit = TemperatureUnit(rawValue: model.temperatureUnit ?? "C") ?? .c
        self.windSpeedUnit   = WindSpeedUnit(rawValue:   model.windSpeedUnit   ?? "km/h") ?? .kmh
        self.isDarkMode      = model.isDarkMode
    }
    
    func temp(_ celsius: Double) -> String {
        switch temperatureUnit {
        case .c:  return "\(celsius.rounded())°C"
        case .f:  return "\(((celsius * 9/5) + 32).rounded())°F"
        }
    }
    func wind(_ kmh: Double) -> String {
        switch windSpeedUnit {
        case .kmh: return "\(kmh.rounded()) km/h"
        case .mph: return "\((kmh / 1.60934).rounded()) mph"
        }
    }
    func persist() {
        model.temperatureUnit = temperatureUnit.rawValue
        model.windSpeedUnit   = windSpeedUnit.rawValue
        model.isDarkMode      = isDarkMode
        CoreDataStack.shared.save()
    }
}
