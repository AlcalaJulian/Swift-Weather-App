//
//  SettingsView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 17/04/25.
//

import SwiftUI

private enum StorageKey {
    static let temperatureUnit = "temperatureUnit"
    static let windSpeedUnit   = "windSpeedUnit"
    static let darkMode        = "darkMode"
}


enum TemperatureUnit: String, CaseIterable, Identifiable {
    case c = "C"
    case f = "F"
    var id: Self { self }
    var label: String { self == .c ? "Celsius" : "Fahrenheit" }
}

enum WindSpeedUnit: String, CaseIterable, Identifiable {
    case kmh = "km/h"
    case mph = "mph"
    var id: Self { self }
    var label: String { rawValue }
}


struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        Form {
            Section("Tempature") {
                Picker("Unit", selection: $settings.temperatureUnit) {
                    ForEach(TemperatureUnit.allCases) { unit in
                        Text(unit.label).tag(unit)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Wind Speed") {
                Picker("Unit", selection: $settings.windSpeedUnit) {
                    ForEach(WindSpeedUnit.allCases) { unit in
                        Text(unit.label).tag(unit)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Appearance") {
                Toggle("Dark Mode", isOn: $settings.isDarkMode)
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        .onChange(of: settings.temperatureUnit) {
            settings.persist()
        }
        .onChange(of: settings.windSpeedUnit) {
            settings.persist()
        }
        .onChange(of: settings.isDarkMode) {
            settings.persist()
        }
    }
}



#Preview {
    NavigationStack {
        SettingsView()
            .environment(\.managedObjectContext,
                          CoreDataStack.shared.container.viewContext)
            .environmentObject(SettingsStore())
    }
}
