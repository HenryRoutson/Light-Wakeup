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
    
    init() {
        // ask for notification permission, if not already
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted == true && error == nil { print("FILTER Notifications permitted") }
        }
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: ScenePhase) { phase in
            // make sure all code is executed
            var PhaseChangeBGTask = UIBackgroundTaskIdentifier(rawValue: 1)
            PhaseChangeBGTask = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            
            //NOTIFICATION WAKEUP
            
            print("FILTER phase is \(ScenePhase)")
            
            // if the app is turned off or on, remove old requests
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.endBackgroundTask(ContentView().NotificationBGTask)
            
            // if the app is turned off, make requests with possibly new data 
            if phase != .active {
                
                if ContentView().NotificationToggle == true {
                    // use background task to refresh notifications
                    ContentView().Notifications_StartBGTask_ToCallSend()
            }
                
            // signal that code has run
            UIApplication.shared.endBackgroundTask(PhaseChangeBGTask)
            }
        }
    }
}
