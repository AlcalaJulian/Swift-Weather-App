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
    @State private var isShowSplash = true
    @State var path = NavigationPath()
    
    var isSearching: Bool {
        !searchQuery.isEmpty
    }
    
    var listContent: some View {
        Group {
            if isSearching {
                ForEach(viewModel.filteredCities) { city in
                    NavigationLink(value: city) {
                        CityRow(city: city)
                    }
                }
            } else {
                ForEach(viewModel.cities) { city in
                    NavigationLink(value: city) {
                        CityRow(city: city)
                    }
                }
            }
        }
    }
    
    var navigationView: some View {
        NavigationStack(path: $path) {
            List {
                listContent
            }
            .onAppear {
                viewModel.loadCities()
            }
            .navigationTitle("Time")
            .navigationDestination(for: CityDto.self) { city in
                CityDetailView(city: city)
            }
            .scrollContentBackground(.hidden)
            .searchable(
                text: $searchQuery,
                placement: .automatic,
                prompt: "Search City"
            )
            .textInputAutocapitalization(.never)
            .onChange(of: searchQuery) { _, newValue in
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
    
    var body: some View {
        if isShowSplash {
            SplashScreen()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isShowSplash = false
                    }
                }
        } else {
            navigationView
        }
    }
}

#Preview {
    CitiesListView()
}
