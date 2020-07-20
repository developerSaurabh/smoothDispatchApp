//
//  NetworkManager.swift
//  App411
//
//  Created by Mandeep Singh on 31/07/18.
//  Copyright © 2018 osvinuser. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    
    var reachability: Reachability!
    
    // Create a singleton instance
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    override init() {
        super.init()
        
        // Initialise reachability
        reachability = Reachability()
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    func isReachable(completed: @escaping (Reachability) -> ()) {
        NetworkManager.sharedInstance.reachability.whenReachable = { (object) in
            completed(object)
        }
    }
    
    // Network is unreachable
    func isUnreachable(completed: @escaping (Reachability) -> Void) {
        NetworkManager.sharedInstance.reachability.whenUnreachable = { (object) in
            completed(object)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
}
