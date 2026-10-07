//
//  APIError.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case noResults
}
