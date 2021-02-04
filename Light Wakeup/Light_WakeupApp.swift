//
//  Light_WakeupApp.swift
//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI
import BackgroundTasks

@main
struct Light_WakeupApp: App {
    @Environment(\.scenePhase) var ScenePhase
    @AppStorage("selection") var selection = 2
    
    init() {
        
        // Seperates first and later launches
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            
            // sets default for wakeuptime
            defaults.set(Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!, forKey: "WakeupTime")
            
            // asks for notification permission, if it has not already
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted == true && error == nil { print("Notifications permitted") }
              
            // sets section that the user opens the app on, first the setup, then main
            }
            selection = 0
        }
        else {
            selection = 1
        }
    }
        
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                SetupView().tag(0)
                ContentView().tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .onChange(of: ScenePhase) { phase in
            
            // make sure all code is executed
            let PhaseChangeBGTask = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            
            //NOTIFICATION WAKEUP
            
            // if the app is turned off or on, remove old requests
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            
            // if the app is turned off, make requests with possibly new data 
            if phase == .background {
                
                // and set alarm if needed
                if ContentView().NotificationToggle == true {
                    Notification_schedule()
                }
            }
            // signal that code has run
            UIApplication.shared.endBackgroundTask(PhaseChangeBGTask)
        }
    }
}

func Notification_schedule() {
    
    //define notification
    let content = UNMutableNotificationContent()
    content.title = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
    content.body = NSString.localizedUserNotificationString(forKey: "Click on this notification to stop more", arguments: nil)
    content.sound = UNNotificationSound.default
    
    // create loop to schedule sequential notifications
    // note that if more than 64 or 2^6 notifications are created, old the latest scheduled will be shown
    var NotificationTime = Date(timeInterval: 5, since: ContentView().WakeupTime)
    for _ in 1...64 {
        
        // define time for each notification
        let dateMatching = Calendar.current.dateComponents([.hour, .minute, .second], from: NotificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        // create time seperation between notifications
        NotificationTime = Date(timeInterval: 10, since: NotificationTime)
   
    }
}
