//
//  WeatherRepositoryImpl.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import Foundation

final class WeatherRepositoryImpl: WeatherRepository {

    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func searchCities(
        query: String
    ) async throws -> [City] {

        var components = URLComponents(
            string: "https://geocoding-api.open-meteo.com/v1/search"
        )!

        components.queryItems = [
            URLQueryItem(name: "name", value: query),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let response = try await client.get(
            GeocodingResponse.self,
            url: url
        )

        guard let results = response.results else {
            throw APIError.noResults
        }

        return results.map {
            City(
                id: $0.id,
                name: $0.name,
                latitude: $0.latitude,
                longitude: $0.longitude,
                country: $0.country,
                admin1: $0.admin1
            )
        }
    }

    func forecast(
        latitude: Double,
        longitude: Double,
        forecastDays: Int = 7
    ) async throws -> ForecastResponse {

        var components = URLComponents(
            string: "https://api.open-meteo.com/v1/forecast"
        )!

        components.queryItems = [
            URLQueryItem(
                name: "latitude",
                value: String(latitude)
            ),
            URLQueryItem(
                name: "longitude",
                value: String(longitude)
            ),
            URLQueryItem(
                name: "daily",
                value: """
                temperature_2m_max,temperature_2m_min,\
                precipitation_probability_max,precipitation_sum,\
                wind_speed_10m_max,snowfall_sum,weather_code
                """
            ),
            URLQueryItem(name: "forecast_days", value: "\(forecastDays)"),
            URLQueryItem(name: "timezone", value: "auto")
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        return try await client.get(
            ForecastResponse.self,
            url: url
        )
    }
}
