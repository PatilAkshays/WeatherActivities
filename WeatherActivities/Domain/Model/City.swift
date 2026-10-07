//
//  City.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//

struct City: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let admin1: String?
}
