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
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                      
                  })
    return true
  }
    private func requestTrackingAuthorization() {
      if #available(iOS 14, *) {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        }
      }
    }
}
@main
struct GoStopApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
