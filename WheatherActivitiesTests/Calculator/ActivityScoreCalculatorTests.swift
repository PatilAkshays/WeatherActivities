//
//  ActivityScoreCalculatorTests.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 07/10/26.
//
import XCTest
@testable import WeatherActivities

final class ActivityScoreCalculatorTests: XCTestCase {

    private let sut = ActivityScoreCalculator()

    // MARK: - Skiing

    func testSkiingScoreWithHeavySnowColdWeatherAndLowWind() {
        let weather = makeWeather(
            temperatureMax: 0,
            temperatureMin: -1,
            precipitationProbability: 10,
            windSpeed: 20,
            snowfall: 10
        )

        let score = sut.score(
            activity: .skiing,
            weather: weather
        )

        // 30 cold + 40 snow + 15 low precipitation + 15 wind
        XCTAssertEqual(score, 100)
    }

    func testSkiingScoreWithModerateColdAndLightSnow() {
        let weather = makeWeather(
            temperatureMax: 5,
            temperatureMin: 3,
            precipitationProbability: 50,
            windSpeed: 35,
            snowfall: 2
        )

        let score = sut.score(
            activity: .skiing,
            weather: weather
        )

        // 15 cold + 25 snow
        XCTAssertEqual(score, 40)
    }

    func testSkiingScoreWithWarmWeatherNoSnow() {
        let weather = makeWeather(
            temperatureMax: 15,
            temperatureMin: 10,
            precipitationProbability: 50,
            windSpeed: 40,
            snowfall: 0,
        )

        let score = sut.score(
            activity: .skiing,
            weather: weather
        )

        XCTAssertEqual(score, 0)
    }

    // MARK: - Surfing

    func testSurfingScoreWithIdealWeather() {
        let weather = makeWeather(
            temperatureMax: 25,
            precipitationProbability: 10,
            windSpeed: 20
        )

        let score = sut.score(
            activity: .surfing,
            weather: weather
        )

        // 30 temperature + 30 wind + 25 low rain
        XCTAssertEqual(score, 85)
    }

    func testSurfingScoreWithModerateWeather() {
        let weather = makeWeather(
            temperatureMax: 12,
            precipitationProbability: 50,
            windSpeed: 35
        )

        let score = sut.score(
            activity: .surfing,
            weather: weather
        )

        // 20 temperature + 15 wind + 10 rain
        XCTAssertEqual(score, 45)
    }

    func testSurfingScoreWithExtremeWind() {
        let weather = makeWeather(
            temperatureMax: 25,
            precipitationProbability: 10,
            windSpeed: 60
        )

        let score = sut.score(
            activity: .surfing,
            weather: weather
        )

        // 30 temperature + 0 wind + 25 rain - 30 penalty
        XCTAssertEqual(score, 25)
    }

    func testSurfingScoreNeverGoesBelowZero() {
        let weather = makeWeather(
            temperatureMax: 5,
            precipitationProbability: 100,
            windSpeed: 100
        )

        let score = sut.score(
            activity: .surfing,
            weather: weather
        )

        XCTAssertEqual(score, 0)
    }

    // MARK: - Outdoor Sightseeing

    func testOutdoorSightseeingWithPerfectWeather() {
        let weather = makeWeather(
            temperatureMax: 25,
            precipitationProbability: 10,
            windSpeed: 10
        )

        let score = sut.score(
            activity: .outdoorSightseeing,
            weather: weather
        )

        XCTAssertEqual(score, 100)
    }

    func testOutdoorSightseeingWithHighRain() {
        let weather = makeWeather(
            temperatureMax: 25,
            precipitationProbability: 80,
            windSpeed: 10
        )

        let score = sut.score(
            activity: .outdoorSightseeing,
            weather: weather
        )

        XCTAssertEqual(score, 60)
    }

    func testOutdoorSightseeingWithHighRainAndStrongWind() {
        let weather = makeWeather(
            temperatureMax: 25,
            precipitationProbability: 80,
            windSpeed: 50
        )

        let score = sut.score(
            activity: .outdoorSightseeing,
            weather: weather
        )

        // 100 - 40 rain - 30 wind
        XCTAssertEqual(score, 30)
    }

    func testOutdoorSightseeingWithExtremeTemperature() {
        let weather = makeWeather(
            temperatureMax: 40,
            precipitationProbability: 10,
            windSpeed: 10
        )

        let score = sut.score(
            activity: .outdoorSightseeing,
            weather: weather
        )

        XCTAssertEqual(score, 80)
    }

    // MARK: - Indoor Sightseeing

    func testIndoorSightseeingWithBadWeather() {
        let weather = makeWeather(
            temperatureMax: 2,
            precipitationProbability: 80,
            windSpeed: 50
        )

        let score = sut.score(
            activity: .indoorSightseeing,
            weather: weather
        )

        // 50 base + 30 rain + 15 temperature + 10 wind
        XCTAssertEqual(score, 100)
    }

    func testIndoorSightseeingWithNormalWeather() {
        let weather = makeWeather(
            temperatureMax: 25,
            precipitationProbability: 20,
            windSpeed: 10
        )

        let score = sut.score(
            activity: .indoorSightseeing,
            weather: weather
        )

        XCTAssertEqual(score, 50)
    }

    // MARK: - Boundary Tests

    func testSkiingAtTemperatureBoundary() {
        let weather = makeWeather(
            temperatureMax: 2,
            precipitationProbability: 50,
            windSpeed: 40,
            snowfall: 0,
           
        )

        let score = sut.score(
            activity: .skiing,
            weather: weather
        )

        XCTAssertEqual(score, 30)
    }

    func testSkiingAtSevenDegrees() {
        let weather = makeWeather(
            temperatureMax: 7,
            precipitationProbability: 50,
            windSpeed: 40,
            snowfall: 0,
           
        )

        let score = sut.score(
            activity: .skiing,
            weather: weather
        )

        XCTAssertEqual(score, 15)
    }

    func testOutdoorScoreIsNeverNegative() {
        let weather = makeWeather(
            temperatureMax: 0,
            precipitationProbability: 100,
            windSpeed: 100
        )

        let score = sut.score(
            activity: .outdoorSightseeing,
            weather: weather
        )

        XCTAssertEqual(score, 10)
    }

    // MARK: - Helper

    private func makeWeather(
        temperatureMax: Double = 20,
        temperatureMin: Double = 20,
        precipitationProbability: Double = 20,
        precipitation: Double = 0,
        windSpeed: Double = 10,
        snowfall: Double = 0
    ) -> DailyWeather {
        DailyWeather(
            temperatureMax: temperatureMax,
            temperatureMin: temperatureMin,
            precipitationProbability: precipitationProbability,
            precipitation: precipitation,
            windSpeed: windSpeed,
            snowfall: snowfall
        )
    }
}
