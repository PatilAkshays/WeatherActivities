//
//  ActivityRankingViewModelTests.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 07/10/26.
//
import XCTest
@testable import WeatherActivities

@MainActor
final class ActivityRankingViewModelTests: XCTestCase {
    
    func testLoad_WhenOffline_ShowsNetworkError() async {
        let repository = MockWeatherRepository()
        let calculator = MockActivityScoreCalculator()
        let networkMonitor = MockNetworkMonitor()
        networkMonitor.isConnected = false
        
        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )
        
        await viewModel.load()
        
        XCTAssertEqual(
            viewModel.networkErrorMessage,
            "No internet connection."
        )
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoad_WhenForecastSucceeds_LoadsRankings() async {
        let repository = MockWeatherRepository()
        repository.forecastResponse = makeForecast()
        let calculator = MockActivityScoreCalculator()
        let networkMonitor = MockNetworkMonitor()

        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        XCTAssertFalse(viewModel.rankings.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.networkErrorMessage)
    }
    
    func testLoad_PassesCityCoordinatesToRepository() async {
        let repository = MockWeatherRepository()
        repository.forecastResponse = makeForecast()
        
        let calculator = MockActivityScoreCalculator()
        let networkMonitor = MockNetworkMonitor()

        let city = City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil)

        let viewModel = ActivityRankingViewModel(
            city: city,
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        XCTAssertEqual(repository.receivedLatitude, 18.52)
        XCTAssertEqual(repository.receivedLongitude, 73.85)
    }
    
    func testLoad_WhenRepositoryFails_ShowsError() async {
        let repository = MockWeatherRepository()
        repository.shouldFail = true
        
        let calculator = MockActivityScoreCalculator()
        let networkMonitor = MockNetworkMonitor()

        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        XCTAssertEqual(
            viewModel.errorMessage,
            "Unable to load the weather forecast."
        )

        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoad_AfterSuccess_SetsLoadingToFalse() async {
        let repository = MockWeatherRepository()
        repository.forecastResponse = makeForecast()

        let networkMonitor = MockNetworkMonitor()
        let calculator = MockActivityScoreCalculator()

        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoad_AfterFailure_SetsLoadingToFalse() async {
        let repository = MockWeatherRepository()
        repository.shouldFail = true

        let networkMonitor = MockNetworkMonitor()
        let calculator = MockActivityScoreCalculator()

        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoad_CreatesRankingForEveryActivity() async {
        let repository = MockWeatherRepository()
        repository.forecastResponse = makeForecast()

        let networkMonitor = MockNetworkMonitor()
        let calculator = MockActivityScoreCalculator()

        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        XCTAssertEqual(
            viewModel.rankings.count,
            Activity.allCases.count
        )

        XCTAssertEqual(
            Set(viewModel.rankings.map(\.activity)),
            Set(Activity.allCases)
        )
    }
    
    func testLoad_CreatesDailyScoreForEachForecastDay() async {
        let repository = MockWeatherRepository()
        repository.forecastResponse = makeForecast(days: 7)

        let networkMonitor = MockNetworkMonitor()
        let calculator = MockActivityScoreCalculator()

        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        for ranking in viewModel.rankings {
            XCTAssertEqual(ranking.dailyScores.count, 7)
        }
    }
    
    func testLoad_SortsRankingsByOverallScoreDescending() async {
        let repository = MockWeatherRepository()
        repository.forecastResponse = makeForecast()

        let calculator = MockActivityScoreCalculator()

        calculator.scores = [
            .skiing: 20,
            .surfing: 80,
            .outdoorSightseeing: 60,
            .indoorSightseeing: 40
        ]

        let networkMonitor = MockNetworkMonitor()

        let viewModel = ActivityRankingViewModel(
            city: City(id: 0, name: "Pune", latitude: 18.52, longitude: 73.85, country: "India", admin1: nil),
            repository: repository,
            networkMonitor: networkMonitor,
            calculator: calculator
        )

        await viewModel.load()

        for index in 0..<(viewModel.rankings.count - 1) {
            XCTAssertGreaterThanOrEqual(
                viewModel.rankings[index].overallScore,
                viewModel.rankings[index + 1].overallScore
            )
        }
    }
    
    // MARK: - Helper
    private func makeForecast(
        days: Int = 7,
        precipitationProbability: [Double]? = nil,
        precipitation: [Double]? = nil,
        windSpeed: [Double]? = nil,
        snowfall: [Double]? = nil,
        weatherCode: [Int]? = nil
    ) -> ForecastResponse {

        let defaultDates = (0..<days).map {
            "2026-10-\(String(format: "%02d", $0 + 1))"
        }

        return ForecastResponse(
            daily: DailyForecast(
                time: defaultDates,
                temperature2mMax: Array(repeating: 25, count: days),
                temperature2mMin: Array(repeating: 18, count: days),
                precipitationProbabilityMax: precipitationProbability,
                precipitationSum: precipitation,
                windSpeed10mMax: windSpeed,
                snowfallSum: snowfall,
                weatherCode: weatherCode
            )
        )
    }
}
