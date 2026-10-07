//
//  CitySearchView.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import SwiftUI
import Combine

struct CitySearchView: View {

    @StateObject private var viewModel: CitySearchViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    init(networkMonitor: NetworkMonitor, repository: WeatherRepository) {
        _viewModel = StateObject(
            wrappedValue: CitySearchViewModel(networkMonitor: networkMonitor,
                repository: repository
            )
        )
    }

    var body: some View {

        NavigationStack {

            VStack {
                
                HStack {
                    
                    TextField(
                        "Search city",
                        text: $viewModel.query
                    )
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: viewModel.query) { _, _ in
                        viewModel.search()
                    }
                    
                    Button("Search") {
                        viewModel.search()
                    }
                }
                .padding()
                
                if let errorMessage = viewModel.networkErrorMessage {
                    ContentUnavailableView(
                        "Network Error",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                } else if viewModel.cities.isEmpty && !viewModel.query.isEmpty {
                    ContentUnavailableView(
                        "No Cities Found",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching for another city.")
                    )
                } else {
                    
                    List(viewModel.cities) { city in
                        
                        NavigationLink {
                            ActivityRankingView(
                                city: city,
                                repository: repository,
                                networkMonitor: networkMonitor,
                                calculator: ActivityScoreCalculator()
                            )
                        } label: {
                            
                            VStack(alignment: .leading) {
                                
                                Text(city.name)
                                    .font(.headline)
                                
                                Text(
                                    [city.admin1, city.country]
                                        .compactMap { $0 }
                                        .joined(separator: ", ")
                                )
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Weather Activities")
        }
    }

    private var repository: WeatherRepository {
        viewModel.repository
    }
}
