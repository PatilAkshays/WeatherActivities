//
//  GeocodingResponse.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//

import Foundation

struct GeocodingResponse: Codable {
    let results: [GeocodingResult]?
}

struct GeocodingResult: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let admin1: String?
}
