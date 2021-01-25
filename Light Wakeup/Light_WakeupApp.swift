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
            ContentView().BackgroundNotificationProcessing(task: BGTask as! BGProcessingTask)
        }
        // Register function to be a background task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "HenryRoutson_identifier2", using: nil) { (BGTask) in
            ContentView().BackgroundNotificationAppRefresh(task: BGTask as! BGAppRefreshTask)
        }
        
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
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
            if phase != .active {
                var Essential = UIBackgroundTaskIdentifier(rawValue: 1)
                Essential = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                BGTaskScheduler.shared.cancelAllTaskRequests()
                
                if ContentView().NotificationToggle == true {
                    ContentView().SetWakeupNotifications(time: ContentView().WakeupTime)
                    for _ in 1...10 {
                        ContentView().scheduleProcessingAtWakeup()
                    }
                    ContentView().scheduleAppRefreshAtWakeup()
                }
                
                UIApplication.shared.endBackgroundTask(Essential)
            }
        }
    }
}
