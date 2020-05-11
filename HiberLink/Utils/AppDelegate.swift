//
//  AppDelegate.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit
import APIRequest
import MatomoTracker

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
                // Tracking
                MatomoTracker.shared.track(view: ["UIApplicationDelegate", "OpenLink", query])
                
                // Fetch target link
                APIRequest("GET", path: "/index.php").with(name: query).execute(String.self) { string, status in
                    // Check the response
                    if let string = string, let full = URL(string: string) {
                        // Open an alert
                        let alert = UIAlertController(title: "open_title".localized(), message: "open_description".localized().format(full.host ?? full.absoluteString), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "open_open".localized(), style: .default) { _ in
                            // Add url to history
                            Database.current.addLink((url.absoluteString, full.absoluteString))
                            
                            // Notify delegate
                            if let rootVC = self.window?.rootViewController as? TabBarController {
                                rootVC.history.loadContent()
                            }
                            
                            // Open url
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(full)
                            } else {
                                UIApplication.shared.openURL(full)
                            }
                        })
                        alert.addAction(UIAlertAction(title: "open_cancel".localized(), style: .cancel, handler: nil))
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    } else {
                        // URL not found or offline
                        let alert = UIAlertController(title: "open_title".localized(), message: "open_error".localized(), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "open_cancel".localized(), style: .cancel, handler: nil))
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            // Return
            return true
        }
        return false
    }

}

