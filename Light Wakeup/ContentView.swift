//  Light Wakeup
//
//  Created by Henry on 5/1/21.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

struct ContentView: View {

    @State var WakeupTime = UserDefaults.standard.object(forKey: "WakeupTime")! as! Date
    @AppStorage("NotificationToggleStored") var NotificationToggle = true

    var body: some View {
        
        VStack {
            
            Spacer()
            
            DatePicker("Select a wakeup time:",
                       selection: $WakeupTime,
                       displayedComponents: [.hourAndMinute])
                .padding([.top, .leading, .trailing], 40.0)
                .padding(.bottom, 10.0)
                .onChange(of: WakeupTime) { (_) in
                    UserDefaults.standard.set(WakeupTime, forKey: "WakeupTime")
                }
            
            Toggle("On/Off", isOn: $NotificationToggle)
                .padding(.horizontal, 80.0)
                .padding(.bottom, 100.0)
            
            Link(destination: URL(string: "mailto:yry1f6aq@anonaddy.me")!) {
                Text("     Feedback     ")
            }
                .foregroundColor(.white)
                .padding(.all)
                .background(Color.black)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: 2)
                        )
                .padding(.bottom, 70)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
