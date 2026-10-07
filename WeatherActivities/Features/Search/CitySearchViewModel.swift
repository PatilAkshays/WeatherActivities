//
//  CitySearchViewModel.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import Foundation
import Combine

@MainActor
final class CitySearchViewModel: ObservableObject {

    @Published var query = ""
    @Published private(set) var cities: [City] = []

    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var networkErrorMessage: String?

    let repository: WeatherRepository
    private let networkMonitor: NetworkMonitoring

    private var searchTask: Task<Void, Never>?
    
    init(networkMonitor: NetworkMonitoring, repository: WeatherRepository) {
        self.networkMonitor = networkMonitor
        self.repository = repository
    }

    func search() {

        searchTask?.cancel()

        searchTask = Task {
            
            await performSearch()
        }
    }
    
    func performSearch() async {
        
        networkErrorMessage = nil
        guard networkMonitor.isConnected else {
            networkErrorMessage = "No internet connection."
            return
        }
        
        let trimmedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedQuery.isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            cities = try await repository.searchCities(
                query: trimmedQuery
            )
        } catch {
            cities.removeAll()
            errorMessage = "Unable to search for this city."
        }
    }
}
