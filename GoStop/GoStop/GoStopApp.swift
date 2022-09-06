//
//  GoStopApp.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/12.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@main
struct GoStopApp: App {
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FirstScreen()
            }
        }
    }
}
