//
//  AddActivityView.swift
//  MaxPoints
//
//  Created by Max Hakin on 28/07/2024.
//

import SwiftUI

struct AddActivityView: View {
    @State private var activityName: String = ""
    @State private var selectedSymbolName: String = "star"  // Default symbol
    @State private var isSymbolPickerPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var addActivity: (Activity) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Activity Name", text: $activityName)

                HStack {
                    Image(systemName: selectedSymbolName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding()

                    Spacer()

                    Button(action: {
                        isSymbolPickerPresented = true
                    }) {
                        Text("Select Icon")
                    }
                }
            }
            .navigationBarTitle("Add Activity", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                if !activityName.isEmpty {
                    let activity = Activity(name: activityName, symbolName: selectedSymbolName)
                    addActivity(activity)
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .sheet(isPresented: $isSymbolPickerPresented) {
                SFSymbolPicker(selectedSymbolName: $selectedSymbolName)
            }
        }
    }
}
