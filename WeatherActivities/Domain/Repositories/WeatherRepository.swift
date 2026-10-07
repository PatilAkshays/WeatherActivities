//
//  WeatherRepository.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import Foundation

protocol WeatherRepository {

    func searchCities(
        query: String
    ) async throws -> [City]

    func forecast(
        latitude: Double,
        longitude: Double,
        forecastDays: Int
    ) async throws -> ForecastResponse
}


