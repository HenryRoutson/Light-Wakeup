//
//  ContentView.swift
//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @State private var WakeupTime = Date()
    @State private var TimeMinDuration = 5
    
    @State private var NotificationToggle = true
    @State private var NotificationsSet = false // would be more efficient not to have to use this if you could set notification trigger conditions
    private let NotificationSecTimeInterval = 0.5

    init() {
        print("FILTER ",#function)
        
        // ask for notification permission, if not already
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted == true && error == nil { print("FILTER Notifications permitted") }}
    }

    func SetWakeupNotifications() {
        print("FILTER ",#function)
        
        // make sure notifications aren't double set
        if NotificationsSet == false && NotificationToggle == true {
        
            //define notification
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "", arguments: nil)
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 0.01) // makes silent without importing new sounds, while still activating flash
            
            // create loop to schedule sequential notifications
            var NotificationTime = WakeupTime
            for _ in 0...Int(TimeMinDuration*60) {
                
                //send notification
                let dateMatching = Calendar.current.dateComponents([.hour, .minute, .second], from: NotificationTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
                
                // add to time for next notification
                NotificationTime = Date(timeInterval: NotificationSecTimeInterval, since: NotificationTime) // shorter time intervals can stop vibration
                }
            NotificationsSet = true
            }
    }
    
    func StopWakeupNotifications() {
        print("FILTER ",#function)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        NotificationsSet = false
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            DatePicker("Select a wakeup time:",
                       selection: $WakeupTime,
                       displayedComponents: [.hourAndMinute])
                .padding([.top, .leading, .trailing], 40.0)
                .padding(.bottom, 0.0)
                .onChange(of: WakeupTime) { x in
                    print("FILTER datepicker")
                    StopWakeupNotifications()
                    SetWakeupNotifications()
                }
                
            
            Toggle("Notification flash\n (if screen is off)", isOn: $NotificationToggle)
                .padding(.horizontal, 80.0)
                .padding(.bottom, 100.0)
                .onChange(of: NotificationToggle) { x in
                    print("FILTER toggle")
                    if NotificationToggle {
                        SetWakeupNotifications()
                    }
                    else {
                        StopWakeupNotifications()
                    }
                }
            
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
