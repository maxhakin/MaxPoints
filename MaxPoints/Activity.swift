//
//  Activity.swift
//  MaxPoints
//
//  Created by Max Hakin on 28/07/2024.
//

import Foundation
import UIKit

struct Activity: Identifiable, Codable {
    var id = UUID()
    var name: String
    var symbolName: String
    var incrementDates: [Date] = []
}

struct DailyIncrement: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
