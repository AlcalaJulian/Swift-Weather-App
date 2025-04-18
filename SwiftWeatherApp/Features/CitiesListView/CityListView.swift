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
   @State private var saveTask: DispatchWorkItem?

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
           .onChange(of: searchQuery) { _, newValue in
               viewModel.filterCities(for: newValue)
               saveTask?.cancel()
               let task = DispatchWorkItem {
                   let q = newValue.trimmingCharacters(in: .whitespaces)
                   if !q.isEmpty {
                       viewModel.saveSearch(query: q)
                   }
               }
               saveTask = task
               DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: task)
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
       if isSearching {
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

struct CitiesListView_Previews: PreviewProvider {
   static var previews: some View {
       CitiesListView()
   }
}
