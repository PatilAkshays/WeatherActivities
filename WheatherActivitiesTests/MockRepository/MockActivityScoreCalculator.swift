//
//  MockActivityScoreCalculator.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 07/10/26.
//
import XCTest
@testable import WeatherActivities

final class MockActivityScoreCalculator: ActivityScoreCalculating {

    var scores: [Activity: Double] = [:]

    func score(
        activity: Activity,
        weather: DailyWeather
    ) -> Int {
        Int(scores[activity] ?? 0)
    }
}
