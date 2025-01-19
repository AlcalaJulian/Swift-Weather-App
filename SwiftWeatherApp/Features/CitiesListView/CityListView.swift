//
//  ContentView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 22/12/24.
//

import SwiftUI


struct CitiesListView: View {
    @State private var viewModel = CitiesListViewModel()
    
    @State private var searchQuery: String = ""
    
    var isSearching: Bool {
        !searchQuery.isEmpty
    }

    var body: some View {
        NavigationStack {
            List {
                ScrollView {
                    if isSearching {
                        ForEach(viewModel.filteredCities) { city in
                            NavigationLink(value: city) {
                                CityRow(city: city, weather: city.weather)
                            }
                        }
                    } else {
                        ForEach(viewModel.cities) { city in
                            NavigationLink(value: city) {
                                CityRow(city: city, weather: city.weather)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Time")
            .navigationDestination(for: City.self) { city in
                CityDetailView(city: city)
            }
            .scrollContentBackground(.hidden)
            .searchable(
                text: $searchQuery,
                placement: .automatic,
                prompt: "Search City"
            )
            .textInputAutocapitalization(.never)
            .onChange(of: searchQuery) { oldValue, newValue in
                viewModel.filterCities(for: newValue)
            }
            .overlay {
                if isSearching && viewModel.filteredCities.isEmpty {
                    ContentUnavailableView(
                        "City not available",
                        systemImage: "magnifyingglass",
                        description: Text("No results found for **\(searchQuery)**")
                    )
                }
            }
        }
    }
}


#Preview {
    CitiesListView()
}
