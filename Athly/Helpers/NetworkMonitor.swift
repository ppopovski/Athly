//
//  NetworkMonitor.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation
import Network

@Observable class NetworkMonitor {
    static let shared = NetworkMonitor()

    var isConnected: Bool?
    var connectionType: NWInterface.InterfaceType?

    private var queue = DispatchQueue(label: "Monitor")
    private var monitor = NWPathMonitor()

    init() {
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied

                let types: [NWInterface.InterfaceType] = [.wifi, .cellular, .wiredEthernet, .loopback]
                if let type = types.first(where: { path.usesInterfaceType($0) }) {
                    self.connectionType = type
                } else {
                    self.connectionType = nil
                }
            }
        }
        monitor.start(queue: queue)
    }
}

