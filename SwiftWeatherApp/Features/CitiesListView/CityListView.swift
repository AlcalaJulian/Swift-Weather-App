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
    @State private var path = NavigationPath()

    private var isSearching: Bool { !searchQuery.isEmpty }

    var body: some View {
        Group {
            if isShowSplash {
                splash
            } else {
                content
            }
        }
    }

    private var splash: some View {
        SplashScreen()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isShowSplash = false
                }
            }
    }

    private var content: some View {
        NavigationStack(path: $path) {
            List {
                recentSearchSection
                citiesSection
            }
            .navigationTitle("Time")
            .scrollContentBackground(.hidden)
            .searchable(text: $searchQuery, prompt: "Search City")
            .onSubmit(of: .search, submitSearch)
            .onChange(of: searchQuery) { _, newValue in
                viewModel.filterCities(for: newValue)
            }
            .navigationDestination(for: CityDto.self) { city in
                CityDetailView(city: city)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .onAppear {
                searchQuery = ""
                viewModel.loadCities()
                viewModel.loadHistory()
            }
        }
    }


    @ViewBuilder
    private var recentSearchSection: some View {
        if searchQuery.isEmpty {
            Section("Latest searches") {
                ForEach(viewModel.searchHistory, id: \.id) { item in
                    Button(item.query ?? "") {
                        applyHistory(item)
                    }
                }
                .onDelete(perform: viewModel.deleteHistoryItems)
            }
        }
    }

    private var citiesSection: some View {
        Section {
            let list = isSearching
                ? viewModel.filteredCities
                : viewModel.cities

            ForEach(list) { city in
                NavigationLink(value: city) {
                    CityRow(city: city, weather: city.weather)
                }
            }
            if isSearching && viewModel.filteredCities.isEmpty {
                ContentUnavailableView(
                    "City not available",
                    systemImage: "magnifyingglass",
                    description: Text("No results for **\(searchQuery)**")
                )
            }
        }
    }

    private func submitSearch() {
        let q = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return }
        viewModel.saveSearch(query: q)
    }

    private func applyHistory(_ item: SearchHistoryItem) {
        searchQuery = item.query ?? ""
        viewModel.filterCities(for: item.query ?? "")
    }
}

//#Preview {
//    CitiesListView()
//}
