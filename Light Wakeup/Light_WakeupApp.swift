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

        // Register function to be a background task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "HenryRoutson_identifier", using: nil) { (BGTask) in
            ContentView().BackgroundNotificationRefresh(task: BGTask as! BGProcessingTask)
        }
        print("FILTER BGTask registered")
        
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
            print("FILTER phase is \(phase)")
            if  phase == .active {
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                BGTaskScheduler.shared.cancelAllTaskRequests()
            }
            if phase != .active && ContentView().NotificationToggle == true {
                var Essential = UIBackgroundTaskIdentifier(rawValue: 1)
                Essential = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                ContentView().SetWakeupNotifications(time: ContentView().WakeupTime)
                ContentView().scheduleAtWakeup()
                UIApplication.shared.endBackgroundTask(Essential)
            }
        }
    }
}
