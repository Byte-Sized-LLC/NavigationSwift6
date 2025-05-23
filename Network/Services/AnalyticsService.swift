//
//  AnalyticsService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

actor AnalyticsService: AnalyticsServiceProtocol {
    private var eventQueue: [AnalyticsEvent] = []
    private let maxQueueSize = 100
    
    func track(_ event: AnalyticsEvent) async {
        eventQueue.append(event)
        
        if eventQueue.count >= maxQueueSize {
            await flushEvents()
        }
        
        // Log for debug
        #if DEBUG
        print("Analytics: \(event)")
        #endif
    }
    
    private func flushEvents() async {
        // Send events to analytics service
        eventQueue.removeAll()
    }
}
