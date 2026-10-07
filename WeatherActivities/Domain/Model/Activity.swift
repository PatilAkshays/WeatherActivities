//
//  Activity.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//

enum Activity: String, CaseIterable, Identifiable {
    case skiing
    case surfing
    case outdoorSightseeing
    case indoorSightseeing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .skiing:
            return "Skiing"
        case .surfing:
            return "Surfing"
        case .outdoorSightseeing:
            return "Outdoor Sightseeing"
        case .indoorSightseeing:
            return "Indoor Sightseeing"
        }
    }

    var emoji: String {
        switch self {
        case .skiing:
            return "🏂"
        case .surfing:
            return "🏄"
        case .outdoorSightseeing:
            return "🥾"
        case .indoorSightseeing:
            return "🏛️"
        }
    }
}
