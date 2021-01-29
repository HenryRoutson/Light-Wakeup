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
    @State var NotificationToggle = UserDefaults.standard.bool(forKey: "WakeupToggle")
    @State var NotificationBGTask = UIBackgroundTaskIdentifier(rawValue: 0)
    
    // Notification flash functions
        
    func Notifications_Send() {
        
        // remove old notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        //define notification
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 0.0)
        content.body = NSString.localizedUserNotificationString(forKey: "Click on this notification to stop more", arguments: nil)
        
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
            NotificationTime = Date(timeInterval: 0.5, since: NotificationTime)
            }
    }
    
    func Notifications_StartBGTask_ToCallSend() {
        
        let NotificationBGTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            print("FILTER expired")
            UIApplication.shared.endBackgroundTask(self.NotificationBGTask)
        })

        // if date is before
        if Date() < WakeupTime {
            print("FILTER before")
            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                UIApplication.shared.endBackgroundTask(NotificationBGTask)
                Notifications_StartBGTask_ToCallSend()
            }
        }
        
        // if date is inside
        else if WakeupTime < Date() && Date() < WakeupTime.addingTimeInterval(TimeInterval(WakeupDuration*60)) {
            print("FILTER inside")
            Notifications_Send()
            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                UIApplication.shared.endBackgroundTask(NotificationBGTask)
                Notifications_StartBGTask_ToCallSend()
            }
        }
        
        // if date is after
        else if WakeupTime.addingTimeInterval(TimeInterval(WakeupDuration*60)) < Date() {
            print("FILTER after")
            UIApplication.shared.endBackgroundTask(NotificationBGTask)
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
                .onChange(of: NotificationToggle) { _ in
                    UserDefaults.standard.set(NotificationToggle, forKey: "WakeupToggle")
                }
            
            Link("     Feedback     ",
                 destination: URL(string: "mailto:yry1f6aq@anonaddy.me")!)
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.black)
                .cornerRadius(30)
                .padding(.vertical)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
