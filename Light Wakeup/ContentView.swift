//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

struct ContentView: View {
    
    // Universal
    @State var WakeupTime = UserDefaults.standard.object(forKey: "WakeupTime")! as! Date
    @State var WakeupDuration = 30 // in minutes
    
    // NOTIFICATION WAKEUP
    
    // Notification flash values
    @AppStorage("NotificationToggleStored") var NotificationToggle = true
    
    // Notification flash functions
        
    func Notification_schedule() {
        
        // remove old notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        //define notification
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Click on this notification to stop more", arguments: nil)
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 0.1)
        
        // create loop to schedule sequential notifications
        // note that if more than 64 or 2^6 notifications are created, old the latest scheduled will be shown
        var NotificationTime = Date(timeInterval: 5, since: Date())
        for _ in 1...64 {
            let dateMatching = Calendar.current.dateComponents([.hour, .minute, .second], from: NotificationTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
            // create time seperation between notifications
            // Note that shorter time intervals can stop vibration
            NotificationTime = Date(timeInterval: 3, since: NotificationTime)
            }
    }
    
    func UpdateWakeupTimeDay() {
        //update wakeupTime
        let hour = Calendar.current.component(.hour, from: WakeupTime)
        let min = Calendar.current.component(.minute, from: WakeupTime)
        let todaysWakeupTime = Calendar.current.date(bySettingHour: hour, minute: min, second: 0, of: Date())!
        // if the time has past for todays alarm, then the next alarm is tommorow
        if todaysWakeupTime < Date() {
            print(WakeupTime)
            // to get working
            print(WakeupTime)
        }
    }

    var body: some View {
        
        VStack {
            
            Spacer()
            
            DatePicker("Select a wakeup time:",
                       selection: $WakeupTime,
                       displayedComponents: [.hourAndMinute])
                .padding([.top, .leading, .trailing], 40.0)
                .padding(.bottom, 10.0)
                .onChange(of: WakeupTime) { _ in
                    UserDefaults.standard.set(WakeupTime, forKey: "WakeupTime")
                }
            
            Toggle("On/Off", isOn: $NotificationToggle)
                .padding(.horizontal, 80.0)
                .padding(.bottom, 100.0)
            
            Link(destination: URL(string: "mailto:yry1f6aq@anonaddy.me")!) {
                Text("     Feedback     ")
            }
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.black)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: 2)
                        )
                .padding(.bottom, 70)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
