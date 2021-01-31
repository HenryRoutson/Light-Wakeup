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
        
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)

        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            print("FILTER", #function)
            
            // ask for notification permission, if not already
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted == true && error == nil { print("FILTER Notifications permitted") }
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
                OnboardingView().tag(0)
                ContentView().tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .onChange(of: ScenePhase) { phase in
            // make sure all code is executed
            let PhaseChangeBGTask = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            
            //NOTIFICATION WAKEUP
            
            print("FILTER phase is \(ScenePhase)")
            
            // if the app is turned off or on, remove old requests
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.endBackgroundTask(ContentView().NotificationBGTask) // not sure if this works
            
            // if the app is turned off, make requests with possibly new data 
            if phase == .background {
                
                // set alarm if needed
                if ContentView().NotificationToggle == true {
                    // use background task to refresh notifications
                    ContentView().UpdateWakeupTimeDay()
                    ContentView().Notifications_StartBGTask_ToCallSend()
                }
            }
            // signal that code has run
            UIApplication.shared.endBackgroundTask(PhaseChangeBGTask)
        }
    }
}

