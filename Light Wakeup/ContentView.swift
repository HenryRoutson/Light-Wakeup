//
//  ContentView.swift
//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var OnOff = true
    @State private var WakeupTime = Date()
    
    var body: some View {
        
        VStack {
            Spacer()
            DatePicker("Select a wakeup time:",
                       selection: $WakeupTime,
                       displayedComponents: [.hourAndMinute])
                .padding(.all, 40.0)
            Toggle(isOn: $OnOff) {
                Text("On / Off")
            }
            .padding(.horizontal, 120.0)
            .padding(.vertical, 70.0)
            Link("Support the the developer",
                 destination: URL(string: "https://www.example.com/TOS.html")!)
                .padding(.bottom)
                .padding(.top)
            Link("Feedback",
                 destination: URL(string: "https://www.example.com/TOS.html")!)
                .padding(.bottom)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
