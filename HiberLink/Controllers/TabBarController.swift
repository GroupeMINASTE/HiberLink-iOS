//
//  TabBarController.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let upload = UploadViewController()
    let history = HistoryTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give delegates
        upload.delegate = history
        
        // Init upload
        let uploadNav = UINavigationController(rootViewController: upload)
        uploadNav.tabBarItem = UITabBarItem(title: "upload_title".localized(), image: UIImage(named: "Upload"), tag: 0)
        
        // Init history
        let historyNav = UINavigationController(rootViewController: history)
        historyNav.tabBarItem = UITabBarItem(title: "history_title".localized(), image: UIImage(named: "History"), tag: 0)

        // Add everything to tab bar
        viewControllers = [uploadNav, historyNav]
        
        // Load views
        for viewController in viewControllers ?? [] {
            if let navigationController = viewController as? UINavigationController, let rootVC = navigationController.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
    }

}
