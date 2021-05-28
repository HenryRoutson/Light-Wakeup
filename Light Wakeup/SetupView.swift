//
//  SwiftUIView.swift
//  Light Wakeup
//
//  Created by Henry on 30/1/21.
//

import SwiftUI

struct SetupView: View {
    @AppStorage("OnboardingViewShown") var OnboardingViewShown = false
    
    var body: some View {
        ScrollView {
        
            VStack {
                
                HStack {
                    Text("Setup")
                        .font(.title)
                        .fontWeight(.black)
                        .padding([.top, .leading, .trailing])
                    Spacer()
                }
                
                Text("\n\nThis app uses 'LED flash' alerts. Search for this in settings and turn it on.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                List {
                    Toggle(isOn: .constant(true) ) {Text("LED Flash for Alerts")}
                        Toggle(isOn: .constant(true) )  {Text("Flash on silent")}
                }
                .listStyle(GroupedListStyle())
                .frame(minHeight: 160, maxHeight: 250)
                .cornerRadius(30)
                
                
                Text("\nOPTIONAL \nTo turn LED alerts off for a specific app, go into the app's permissions in settings and turn off notification sound.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                List {
                    Toggle(isOn: .constant(false) ) {Text("Sounds")}
                    Toggle(isOn: .constant(true) )  {Text("Badges")}
                }
                .listStyle(GroupedListStyle())
                .frame(minHeight: 160, maxHeight: 160)
                .cornerRadius(30)
                
                
                Text("\n'Do Not Disturb' stops LED alerts, so set it to turn off before when they are set. In this case the alarm should be after 7:30 am.")
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                
                List {
                    Toggle(isOn: .constant(true) ) {Text("Scheduled")}
                    DatePicker("From",
                               selection: .constant(Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!),
                               displayedComponents: [.hourAndMinute])
                    DatePicker("To",
                               selection: .constant(Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!),
                               displayedComponents: [.hourAndMinute])
                    Toggle(isOn: .constant(true) )  {Text("Dim Lock screen")}
                }
                .listStyle(GroupedListStyle())
                .frame(minHeight: 300, maxHeight: .infinity)
                .cornerRadius(30)
                
                Text("\nThis app works wakes you up most gradually in silent mode with the ringer off, so flip the switch to turn it off.")
                    .padding()
                
                Text("\nLastly, this alarm may not fully wake you up, so make sure to have another backup alarm that can.\n\n\n\n\n")
                    .padding()
            }
            .allowsHitTesting(false)
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
