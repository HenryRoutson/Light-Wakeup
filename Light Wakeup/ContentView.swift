//
//  ContentView.swift
//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            Text("Make sure to have a backup alarm set")
                .foregroundColor(.gray)
            Spacer()
            DatePicker("Select a wakeup time:", selection: .constant(Date()), displayedComponents: [.hourAndMinute])
                .padding(.all, 30.0)
            Toggle(isOn: .constant(true)) {
                Text("On / Off")
            }
            .padding(.horizontal, 90.0)
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
