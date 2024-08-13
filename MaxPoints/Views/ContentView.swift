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
                    HStack() {
                        
                        //Activity name
                        Text(activity.name)
                            .font(.headline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: 50)
                        
                        // Simple line graph showing increments over the last 7 days
                        SimpleLineGraphView(dataPoints: activity.incrementDates)
                            .padding(.top, 5)
                                
                        Spacer()
                                
                        // Today's increment count
                        let todayIncrementCount = activity.incrementDates.filter { isSameDay(date1: $0, date2: Date()) }.count
                        Text("\(todayIncrementCount)")
                            .font(.subheadline)
                            .padding(5)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
 
                            
                            
                            
                        
                        // Increment button
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
                    .background(
                        RepeatingPatternView(symbolName: activity.symbolName, size: 30, spacing: 15)
                            .foregroundColor(.gray.opacity(0.2)) // Adjust the color and opacity as needed
                    )
                    .cornerRadius(10)  // Optional: Rounds the corners of each activity card
                    .padding(.vertical, 5)  // Padding between each activity card
                    
                }
                .onDelete(perform: deleteActivity)
            }
            .listRowSpacing(10.0)
            
            //Navigation bar
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
