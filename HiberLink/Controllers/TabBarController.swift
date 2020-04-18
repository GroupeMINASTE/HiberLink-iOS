//
//  TabBarController.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init upload
        let upload = UINavigationController(rootViewController: UploadViewController())
        upload.tabBarItem = UITabBarItem(title: "upload_title".localized(), image: UIImage(named: "Upload"), tag: 0)

        // Add everything to tab bar
        viewControllers = [upload]
        
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
