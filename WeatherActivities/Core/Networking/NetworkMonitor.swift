//
//  NetworkMonitor.swift
//  WeatherActivities
//
//  Created by Akshay Patil on 06/10/26.
//

import Network
import Combine

protocol NetworkMonitoring {
    var isConnected: Bool { get }
}

final class NetworkMonitor: ObservableObject, NetworkMonitoring {

    @Published private(set) var isConnected = false

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
