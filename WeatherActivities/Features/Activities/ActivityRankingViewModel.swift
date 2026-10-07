//
//  ActivityRankingViewModel.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import Foundation
import Combine

@MainActor
final class ActivityRankingViewModel: ObservableObject {

    @Published private(set) var rankings: [ActivityRanking] = []

    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var networkErrorMessage: String?

    private let city: City
    private let repository: WeatherRepository
    private let calculator: ActivityScoreCalculating
    private let networkMonitor: NetworkMonitoring

    init(
        city: City,
        repository: WeatherRepository,
        networkMonitor: NetworkMonitoring,
        calculator: ActivityScoreCalculating
    ) {
        self.city = city
        self.repository = repository
        self.networkMonitor = networkMonitor
        self.calculator = calculator
    }

    func load() async {
        
        networkErrorMessage = nil
        guard networkMonitor.isConnected else {
            networkErrorMessage = "No internet connection."
            return
        }
        
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            let forecast = try await repository.forecast(
                latitude: city.latitude,
                longitude: city.longitude,
                forecastDays: 7
            )

            let dailyWeather = buildDailyWeather(
                forecast
            )

            rankings = Activity.allCases
                .map { activity in

                    let scores = dailyWeather.map {
                        calculator.score(
                            activity: activity,
                            weather: $0
                        )
                    }

                    return ActivityRanking(
                        activity: activity,
                        dailyScores: scores
                    )
                }
                .sorted {
                    $0.overallScore >
                    $1.overallScore
                }

        } catch {

            errorMessage =
                "Unable to load the weather forecast."
        }
    }

    private func buildDailyWeather(
        _ forecast: ForecastResponse
    ) -> [DailyWeather] {

        let daily = forecast.daily

        return daily.time.indices.map { index in

            DailyWeather(
                temperatureMax:
                    daily.temperature2mMax[index],

                temperatureMin:
                    daily.temperature2mMin[index],

                precipitationProbability:
                    daily.precipitationProbabilityMax?[index] ?? 0,

                precipitation:
                    daily.precipitationSum?[index] ?? 0,

                windSpeed:
                    daily.windSpeed10mMax?[index] ?? 0,

                snowfall:
                    daily.snowfallSum?[index] ?? 0
            )
        }
    }
}
