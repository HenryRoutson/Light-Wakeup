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
            // make sure all code is executed
            var Essential = UIBackgroundTaskIdentifier(rawValue: 1)
            Essential = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            
            // if the app is turned off or on, remove old requests
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            BGTaskScheduler.shared.cancelAllTaskRequests()
            
            // if the app is turned off, make requests with possibly new data 
            if phase != .active {
                
                if ContentView().NotificationToggle == true {
                    
                    // schedule notifications
                    ContentView().SetWakeupNotifications(time: ContentView().WakeupTime)
                    
                    // schedule background task to refresh notifications
                    let request = BGAppRefreshTaskRequest(identifier: "HenryRoutson_identifier")
                    request.earliestBeginDate = ContentView().WakeupTime.addingTimeInterval(TimeInterval(30.0)) // might not activate on time
                    do {
                        try BGTaskScheduler.shared.submit(request)
                    }
                    catch {
                        print("FILTER error: \(error) function: \(#function)")
                    }
                    print("FILTER wakeuptime set \(ContentView().WakeupTime)")
                    }
                
            UIApplication.shared.endBackgroundTask(Essential)
            }
        }
    }
}
