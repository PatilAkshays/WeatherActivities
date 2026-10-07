//
//  CitySearchViewModelTests.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 07/10/26.
//

import XCTest
@testable import WeatherActivities

@MainActor
final class CitySearchViewModelTests: XCTestCase {

    func testSearchFailureShowsError() async {

        let repository = MockWeatherRepository()
        repository.shouldFail = true
       
        let networkMonitor = MockNetworkMonitor()
        
        let viewModel = CitySearchViewModel(
            networkMonitor: networkMonitor, repository: repository
        )

        viewModel.query = "Pune"

        await viewModel.performSearch()

        XCTAssertNotNil(
            viewModel.errorMessage
        )
    }
    
    func testSearchWhenOfflineShowsError() async {

           let networkMonitor = MockNetworkMonitor()
           networkMonitor.isConnected = false

           let repository = MockWeatherRepository()

           let viewModel = CitySearchViewModel(
               networkMonitor: networkMonitor,
               repository: repository
           )

           viewModel.query = "Pune"

        await viewModel.performSearch()

           XCTAssertEqual(
               viewModel.networkErrorMessage,
               "No internet connection."
           )
       }
    
    func testPerformSearch_WhenOffline_ShowsNetworkError() async {
        let repository = MockWeatherRepository()
        let networkMonitor = MockNetworkMonitor()
        networkMonitor.isConnected = false

        let viewModel = CitySearchViewModel(
            networkMonitor: networkMonitor,
            repository: repository
        )

        viewModel.query = "Pune"

        await viewModel.performSearch()

        XCTAssertEqual(
            viewModel.networkErrorMessage,
            "No internet connection."
        )
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testPerformSearch_WithValidQuery_LoadsCitiesSuccessfully() async {
        let repository = MockWeatherRepository()
        repository.cities = [
            City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil)
        ]

        let networkMonitor = MockNetworkMonitor()
        networkMonitor.isConnected = true

        let viewModel = CitySearchViewModel(
            networkMonitor: networkMonitor,
            repository: repository
        )

        viewModel.query = "Pune"

        await viewModel.performSearch()

        XCTAssertEqual(viewModel.cities.count, 1)
        XCTAssertEqual(viewModel.cities.first?.name, "Pune")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.networkErrorMessage)
    }
    
    func testPerformSearch_WithEmptyQuery_DoesNothing() async {
        let repository = MockWeatherRepository()
        let networkMonitor = MockNetworkMonitor()

        let viewModel = CitySearchViewModel(
            networkMonitor: networkMonitor,
            repository: repository
        )

        viewModel.query = ""

        await viewModel.performSearch()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testPerformSearch_WithWhitespaceOnlyQuery_DoesNothing() async {
        let repository = MockWeatherRepository()
        let networkMonitor = MockNetworkMonitor()

        let viewModel = CitySearchViewModel(
            networkMonitor: networkMonitor,
            repository: repository
        )

        viewModel.query = "   \n\t  "

        await viewModel.performSearch()

        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testPerformSearch_WhenRepositoryFails_ShowsError() async {
        let repository = MockWeatherRepository()
        repository.shouldFail = true

        let networkMonitor = MockNetworkMonitor()

        let viewModel = CitySearchViewModel(
            networkMonitor: networkMonitor,
            repository: repository
        )

        viewModel.query = "Pune"

        await viewModel.performSearch()

        XCTAssertTrue(viewModel.cities.isEmpty)
        XCTAssertEqual(
            viewModel.errorMessage,
            "Unable to search for this city."
        )
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.networkErrorMessage)
    }
    
    func testPerformSearch_ClearsPreviousErrorOnNewSearch() async {
        let repository = MockWeatherRepository()
        let networkMonitor = MockNetworkMonitor()

        let viewModel = CitySearchViewModel(
            networkMonitor: networkMonitor,
            repository: repository
        )

        viewModel.errorMessage = "Previous error"
        viewModel.query = "Pune"

        await viewModel.performSearch()

        XCTAssertNil(viewModel.errorMessage)
    }

}
