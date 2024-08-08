//
//  ContentView.swift
//  MaxPoints
//
//  Created by Max Hakin on 24/07/2024.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var activityStore: ActivityStore
    @State private var isAddActivityPresented: Bool = false

    var body: some View {
        
        NavigationView {
            List {
                ForEach($activityStore.activities) { $activity in
                    VStack(alignment: .leading) {
                        ZStack {
                            // Repeating pattern background
                            RepeatingPatternView(symbolName: activity.symbolName, size: 30, spacing: 15)
                                .foregroundColor(.gray.opacity(0.2)) // Adjust the color and opacity as needed
                            HStack {
                                //Try moving this before the VStack? do i need to set to fill the containing view? For the tile to repeat?
                                Image(systemName: activity.symbolName)
                                    .resizable(resizingMode: .tile)
                                    .frame(width: 50, height: 50)
                                
                                
                                Text(activity.name)
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button(action: {
                                    activity.incrementDates.append(Date())
                                    Task {
                                        try? await activityStore.save(activities: activityStore.activities)
                                    }
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
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
                .onDelete(perform: deleteActivity)
            }
            .navigationBarTitle("Activities")
            .navigationBarItems(trailing: Button(action: {
                isAddActivityPresented = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isAddActivityPresented) {
                AddActivityView { newActivity in
                    activityStore.activities.append(newActivity)
                    Task {
                        try? await activityStore.save(activities: activityStore.activities)
                    }
                }
            }
        }
        .onAppear {
            Task {
                try? await activityStore.load()
            }
        }
    }

    // Helper function to check if two dates are the same day
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    // Function to delete an activity
    private func deleteActivity(at offsets: IndexSet) {
        activityStore.activities.remove(atOffsets: offsets)
        Task {
            try? await activityStore.save(activities: activityStore.activities)
        }
    }
}
