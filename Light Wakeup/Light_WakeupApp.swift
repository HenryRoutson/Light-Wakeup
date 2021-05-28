//
//  Light_WakeupApp.swift
//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI
import BackgroundTasks
import Firebase //https://github.com/firebase/firebase-ios-sdk.git

// Firebase process
//https://stackoverflow.com/questions/49588864/firebase-scheduled-notification-in-android

// AppDelegate file equivalent
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-appdelegate-to-a-swiftui-app
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // https://firebase.google.com/docs/ios/setup
    //https://console.firebase.google.com/project/light-wakeup-e73b3/settings/general/ios:HenryRoutson.Light-Wakeup
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions")
        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        Notification_schedule()
    }
}

@main
struct Light_WakeupApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var ScenePhase
    @AppStorage("ViewSelection") var ViewSelection = "Nill"
    
    init() {
        
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)

        if !hasLaunched {
        
            // Set default UI element values
            defaults.set(true, forKey: hasLaunchedKey)
            defaults.set(Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!, forKey: "WakeupTime")

            // select SetupView on first open
            ViewSelection = "SetupView"
        }
        else {
            // select InputView if the app has been seen SetupView before
            ViewSelection = "InputView"
        }
    }
        
    var body: some Scene {
        WindowGroup {
            TabView(selection: $ViewSelection) {
                SetupView().tag("SetupView")
                InputView().tag("InputView")
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .accessibilityIdentifier("ViewSelections")
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
                
                // set alarm if needed
                if InputView().NotificationToggleBool == true {
                    // use background task to refresh notifications
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
    var NotificationTime = Date(timeInterval: 5, since: InputView().WakeupTime)
    for _ in 1...64 {
        
        let dateMatching = Calendar.current.dateComponents([.hour, .minute, .second], from: NotificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        // create time seperation between notifications
        NotificationTime = Date(timeInterval: 10, since: NotificationTime)
   
    }
}
