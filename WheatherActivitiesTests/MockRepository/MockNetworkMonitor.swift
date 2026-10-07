//
//  MockNetworkMonitor.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 07/10/26.
//
import XCTest
@testable import WeatherActivities

final class MockNetworkMonitor: NetworkMonitoring {
    var isConnected: Bool = true
}
