//
//  APIClient.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import Foundation

protocol APIClient {
    func get<T: Decodable>(
        _ type: T.Type,
        url: URL
    ) async throws -> T
}

nonisolated class URLSessionAPIClient: APIClient {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<T: Decodable>(
        _ type: T.Type,
        url: URL
    ) async throws -> T {

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
