//
//  ForecastResponse.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//

import Foundation

struct ForecastResponse: Codable {
    let daily: DailyForecast
}

struct DailyForecast: Codable {
    let time: [String]

    let temperature2mMax: [Double]
    let temperature2mMin: [Double]

    let precipitationProbabilityMax: [Double]?
    let precipitationSum: [Double]?
    let windSpeed10mMax: [Double]?
    let snowfallSum: [Double]?
    let weatherCode: [Int]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case precipitationSum = "precipitation_sum"
        case windSpeed10mMax = "wind_speed_10m_max"
        case snowfallSum = "snowfall_sum"
        case weatherCode = "weather_code"
    }
}


