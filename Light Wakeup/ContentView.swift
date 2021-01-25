//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

struct ContentView: View {
    
    // Universal
    @State var WakeupTime = Date()
    @State private var useAlertShowing = false
    
    // Notification flash values
    @State var NotificationToggle = true
    
    // Notification flash functions
        
    // send requests to send notifications that wake up the user
    func SetWakeupNotifications(time: Date) {
        
        // remove old notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        //define notification
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake Up!", arguments: nil)
        content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 0.0)
        //content.body = NSString.localizedUserNotificationString(forKey: "Click on this notification to stop more", arguments: nil)
        
        // create loop to schedule sequential notifications
        // Note that at max 64 or 2^6 can be created and if more are only the latest are fired
        var NotificationTime = Date(timeInterval: 5, since: time) // rather than wakeuptime as time is controlled by BGTask scheduler
        for n in 1...60 {
            
            //send notification
            content.body = NSString.localizedUserNotificationString(forKey: "set \(Date()) for \(NotificationTime) number \(n) ", arguments: nil) // For testing
            let dateMatching = Calendar.current.dateComponents([.hour, .minute, .second], from: NotificationTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            
            // add to time for next notification
            // Note that shorter time intervals can stop vibration
            NotificationTime = Date(timeInterval: 0.5, since: NotificationTime)
            }
    }
    
    
    // Define background code to stop and set Notififcations and then reschedule itself
    func BackgroundNotificationProcessing(task: BGProcessingTask) {
        
        // set notifications
        SetWakeupNotifications(time: Date())
        
        // reschedule the function, to re-set notificiations
        let request = BGProcessingTaskRequest(identifier: "HenryRoutson_identifier")
        request.earliestBeginDate = Date().addingTimeInterval(TimeInterval(30.0))
        do {
            try BGTaskScheduler.shared.submit(request)
        }
        catch {
            print("FILTER error: \(error) function: \(#function)")
        }
        
        // set current request as complete
        task.setTaskCompleted(success: true)
    }
    
    func BackgroundNotificationAppRefresh(task: BGAppRefreshTask) {
        print("FILTER", #function)
        
        // set notifications
        SetWakeupNotifications(time: Date())
        
        // reschedule the function, to re-set notificiations
        let request = BGProcessingTaskRequest(identifier: "HenryRoutson_identifier2")
        request.earliestBeginDate = Date().addingTimeInterval(TimeInterval(30.0))
        do {
            try BGTaskScheduler.shared.submit(request)
        }
        catch {
            print("FILTER error: \(error) function: \(#function)")
        }
        
        // set current request as complete
        task.setTaskCompleted(success: true)
        
    }
    
    // function called to request background processing that will set notifications at the right time
    func scheduleProcessingAtWakeup() {

        // cancel any old task requests
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        // reschedule the function to be in the background
        let request = BGProcessingTaskRequest(identifier: "HenryRoutson_identifier")
        request.earliestBeginDate = WakeupTime.addingTimeInterval(TimeInterval(30.0)) // might not activate on time
        do {
            try BGTaskScheduler.shared.submit(request)
        }
        catch {
            print("FILTER error: \(error) function: \(#function)")
        }
    }
    
    func scheduleAppRefreshAtWakeup() {
        
        // cancel any old task requests
        BGTaskScheduler.shared.cancelAllTaskRequests()
        
        // reschedule the function to be in the background
        let request = BGAppRefreshTaskRequest(identifier: "HenryRoutson_identifier2")
        request.earliestBeginDate = WakeupTime.addingTimeInterval(TimeInterval(30.0)) // might not activate on time
        do {
            try BGTaskScheduler.shared.submit(request)
        }
        catch {
            print("FILTER error: \(error) function: \(#function)")
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
            
            Toggle("On/Off", isOn: $NotificationToggle)
                .padding(.horizontal, 80.0)
                .padding(.bottom, 100.0)
            
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
