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
            // ask for notification permission, if not already
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted == true && error == nil { print("Notifications permitted") }}}

    func WakeupNotifications() {
        print("WakeupNotifications")
        
        // temp
        if OnOff {
        
            //define notification
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Clear to stop", arguments: nil)
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 0.01) // makes silent without importing new sounds, while still activating flash
            
            // create loop to schedule sequential notifications
            var NotificationTime = WakeupTime
            for _ in 0...120 {
                
                //send notification
                let dateMatching = Calendar.current.dateComponents([.hour, .minute, .second], from: NotificationTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
                
                // add to time for next notification
                NotificationTime = Date(timeInterval: 0.5, since: NotificationTime) // shorter time intervals can stop vibration
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
