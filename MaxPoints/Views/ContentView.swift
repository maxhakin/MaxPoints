//
//  ContentView.swift
//  MaxPoints
//
//  Created by Max Hakin on 24/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var activities: [Activity] = []
    @State private var isAddActivityPresented: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach($activities) { $activity in
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: activity.symbolName)
                                .resizable()
                                .frame(width: 50, height: 50)

                            Text(activity.name)
                                .font(.headline)

                            Spacer()

                            Button(action: {
                                activity.incrementDates.append(Date())
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        // Simple line graph showing increments over the last 7 days
                        SimpleLineGraphView(dataPoints: activity.incrementDates)
                            .padding(.top, 5)

                        let todayIncrementCount = activity.incrementDates.filter { isSameDay(date1: $0, date2: Date()) }.count
                        Text("Today's Increments: \(todayIncrementCount)")
                            .font(.subheadline)
                            .padding(.top, 5)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationBarTitle("Activities")
            .navigationBarItems(trailing: Button(action: {
                isAddActivityPresented = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isAddActivityPresented) {
                AddActivityView { newActivity in
                    activities.append(newActivity)
                }
            }
        }
    }

    // Helper function to check if two dates are the same day
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}
