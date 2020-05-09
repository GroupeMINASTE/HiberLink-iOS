//
//  AppDelegate.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit
import APIRequest

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize API
        APIConfiguration.current = APIConfiguration(host: "hiber.link", headers: { ["User-Agent": "curl"] }).with(decoder: StringAPIDecoder())
        
        // Create view
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Check that there is an url with correct host
        if let url = userActivity.webpageURL, url.host == "hiber.link" {
            // Check if there are get parameters
            if let query = url.query {
                // Fetch target link
                APIRequest("GET", path: "/index.php").with(name: query).execute(String.self) { string, status in
                    // Check the response
                    if let string = string, let full = URL(string: string) {
                        // Add url to history
                        Database.current.addLink((url.absoluteString, full.absoluteString))
                        
                        // Open url
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(full)
                        } else {
                            UIApplication.shared.openURL(full)
                        }
                    }
                }
            }
            
            // Return
            return true
        }
        return false
    }

}

