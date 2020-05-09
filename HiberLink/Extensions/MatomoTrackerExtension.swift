//
//  MatomoTrackerExtension.swift
//  HiberLink
//
//  Created by Nathan FALLET on 09/05/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation
import MatomoTracker

extension MatomoTracker {
    
    static let shared = MatomoTracker(siteId: "2", baseURL: URL(string: "https://hiberfile.com/matomo/matomo.php")!)
    
}
