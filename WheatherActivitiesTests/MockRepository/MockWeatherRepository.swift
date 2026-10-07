//
//  MockWeatherRepository.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 07/10/26.
//
import XCTest
@testable import WeatherActivities

final class MockWeatherRepository:
    WeatherRepository {

    var cities: [City] = []

    var forecastResponse: ForecastResponse?

    var shouldFail = false

    var forecastCalled = false
    var receivedLatitude: Double?
    var receivedLongitude: Double?

    
    func searchCities(
        query: String
    ) async throws -> [City] {

        if shouldFail {
            throw APIError.noResults
        }

        return cities
    }

    func forecast(
        latitude: Double,
        longitude: Double,
        forecastDays: Int
    ) async throws -> ForecastResponse {
        
        forecastCalled = true
        
        receivedLatitude = latitude
        receivedLongitude = longitude
        
        if shouldFail {
            throw APIError.invalidResponse
        }
        
        return forecastResponse!
    }
    
    func addCities(cities: [City]) {
        self.cities = cities
    }
    
    func removaeAllCities() {
        self.cities.removeAll()
    }
}
