//
//  SimpleLineGraphView.swift
//  MaxPoints
//
//  Created by Max Hakin on 29/07/2024.
//

import SwiftUI
import Charts

struct SimpleLineGraphView: View {
    var dataPoints: [Date]

    var body: some View {
        let dailyData = computeDailyIncrements(for: dataPoints)

        Chart {
            ForEach(dailyData) { dailyIncrement in
                LineMark(
                    x: .value("Date", dailyIncrement.date, unit: .day),
                    y: .value("Count", dailyIncrement.count)
                )
            }
        }
        .chartXAxis(.hidden)  // Hide X axis
        .chartYAxis(.hidden)  // Hide Y axis
        .frame(height: 50)
    }

    // Compute the count of increments for each of the last 7 days
    private func computeDailyIncrements(for dates: [Date]) -> [DailyIncrement] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var dailyCounts: [Date: Int] = [:]

        // Initialize the dictionary with 0 counts for the last 7 days
        for offset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -offset, to: today) {
                dailyCounts[date] = 0
            }
        }

        // Count the occurrences of each day in the past 7 days
        for date in dates {
            let startOfDay = calendar.startOfDay(for: date)
            if dailyCounts.keys.contains(startOfDay) {
                dailyCounts[startOfDay, default: 0] += 1
            }
        }

        // Convert dictionary to sorted array of DailyIncrement objects
        let sortedData = dailyCounts
            .map { DailyIncrement(date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }

        return sortedData
    }
}
