//
//  TimeCheck.swift
//  RestaurantReviews
//
//  Created by Admin on 14.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct TimeCheck {
    private enum TimeUnits {
        static let second: TimeInterval = 1
        static let minute: TimeInterval = 60 * second
        static let hour:   TimeInterval = 60 * minute
        static let day:    TimeInterval = 60 * hour
    }
    
    var updateInterval: TimeInterval
    
    private var updateTime: Date
    
    init() {
        updateInterval = 0
        updateTime = Date()
    }

    init(second: TimeInterval, minute: TimeInterval, hour: TimeInterval, day: TimeInterval) {
        //set(second: second, minute: minute, hour: hour, day: day)
        updateInterval = second * TimeUnits.second + minute * TimeUnits.minute + hour * TimeUnits.hour + day * TimeUnits.day
        updateTime = Date(timeIntervalSinceNow: updateInterval)
    }
    
    func isUp() -> Bool {
        return updateTime <= Date()
    }
    
    mutating func set(second: TimeInterval, minute: TimeInterval, hour: TimeInterval, day: TimeInterval) {
        updateInterval = second * TimeUnits.second + minute * TimeUnits.minute + hour * TimeUnits.hour + day * TimeUnits.day
        updateTime = Date(timeIntervalSinceNow: updateInterval)
    }
    mutating func reset() {
        updateTime = Date(timeIntervalSinceNow: updateInterval)
    }
}
