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
    @State private var useAlertShowing = false
    
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
        NotificationBGTask = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

        print("FITER \(#function) \(Date())")
        print("FILTER wakeupTime is \(WakeupTime)")
        // order dates in chronological left to right
        if WakeupTime < Date() && Date() < WakeupTime.addingTimeInterval(TimeInterval(WakeupDuration*60)) {
            print("FILTER sending wakeup notifications")
            Notifications_Send()
        }
        else {
            UIApplication.shared.endBackgroundTask(NotificationBGTask)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            UIApplication.shared.endBackgroundTask(NotificationBGTask)
            print("FILTER Background task ended")
            Notifications_StartBGTask_ToCallSend()
            
        }
    }

    var body: some View {
        
        VStack {
            
            Text("Setup")
                .multilineTextAlignment(.center)
                .padding([.top, .leading, .trailing])
                .padding(.bottom, 3)
        
            Text("'With search, enable 'LED flash for alerts',\n turn off 'low power mode', and 'Do not disturb' before the set alarm time")
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding([.leading, .bottom, .trailing])
            
            // button to open settings
            // settings URL is ideal but currently not working, IE prefs:root=
            // https://www.macstories.net/ios/a-comprehensive-guide-to-all-120-settings-urls-supported-by-ios-and-ipados-13-1/
            Button("Open settings") {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.black)
                .cornerRadius(30)
            
            Spacer()
            
            DatePicker("Select a wakeup time:",
                       selection: $WakeupTime,
                       displayedComponents: [.hourAndMinute])
                .padding([.top, .leading, .trailing], 40.0)
                .padding(.bottom, 10.0)
                .onChange(of: WakeupTime) { _ in
                    print("FILTER wakeupTime state saved")
                    UserDefaults.standard.set(WakeupTime, forKey: "WakeupTime")
                }
            
            Toggle("On/Off", isOn: $NotificationToggle)
                .padding(.horizontal, 80.0)
                .padding(.bottom, 100.0)
                .onChange(of: WakeupTime) { _ in
                    print("FILTER wakeupToggle state saved")
                    UserDefaults.standard.set(NotificationToggle, forKey: "WakeupToggle")
                }
            
            Button("How to use") {
                self.useAlertShowing = true
            }
            .alert(isPresented: $useAlertShowing) {
                Alert(title: Text("How to use"), message: Text("After settings have been setup, make sure you have a sound alarm as backup and turn your screen off and facedown"), dismissButton: .default(Text("Okay")))
            }
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.black)
                .cornerRadius(30)
            
            Link("Feedback",
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
