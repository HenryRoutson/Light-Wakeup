//
//  ContentView.swift
//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @State private var OnOff = false
    @State private var WakeupTime = Date()
    
    init() {
            // set notification permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted == true && error == nil {
                    print("Notifications permitted")
                } else {
                    print("Notifications not permitted")
                }}
        }
    
    func WakeupNotifications() {
        print("WakeupNotifications")
            
        if OnOff {
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Click on a notification to stop more", arguments: nil)
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 0.0) // make silent without importing new sounds
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: WakeupTime), repeats: true)
            let request = UNNotificationRequest(identifier: "Notif", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                 if let _ = error { print("error:") }
                }
        }
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            DatePicker("Select a wakeup time:",
                       selection: $WakeupTime,
                       displayedComponents: [.hourAndMinute])
                .padding([.top, .leading, .trailing], 40.0)
                .padding(.bottom, 0.0)
            
            Button("Confirm time", action: WakeupNotifications)
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.black)
                .cornerRadius(30)
                .padding(.bottom, 50)
                
            
            Toggle("Notification flash\n (if screen is off)", isOn: $OnOff)
                .padding(.horizontal, 80.0)
                .padding(.bottom, 100.0)
            
            // ADD apple pay to support developer

            Link("Feedback",
                 destination: URL(string: "mailto:yry1f6aq@anonaddy.me")!)
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.black)
                .cornerRadius(30)
                
        } .padding(.vertical)
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
