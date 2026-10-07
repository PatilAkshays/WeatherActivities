//
//  WeatherActivitiesApp.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//

import SwiftUI
import Combine

@main
struct WeatherActivitiesApp: App {

    private let repository: WeatherRepository
    @StateObject private var networkMonitor = NetworkMonitor()

    init() {

        let client = URLSessionAPIClient()

        repository = WeatherRepositoryImpl(
            client: client
        )
    }

    var body: some Scene {

        WindowGroup {

            CitySearchView(
                networkMonitor: networkMonitor,
                repository: repository
            )
            .environmentObject(networkMonitor)
        }
    }
}
