//
//  Database.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation
import SQLite
import StoreKit

class Database {
    
    // Static instance
    static let current = Database()
    
    // Properties
    private var db: Connection?
    let links = Table("links")
    let short = Expression<String>("short")
    let full = Expression<String>("full")
    let generated = Expression<Date>("generated")
    
    // Initialize
    init() {
        do {
            // Get database path
            if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                // Connect to database
                db = try Connection("\(path)/hiberlink.sqlite3")
                
                // Initialize tables
                try db?.run(links.create(ifNotExists: true) { table in
                    table.column(short, unique: true)
                    table.column(full)
                    table.column(generated)
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Get links
    func getLinks() -> [(String, String)] {
        // Initialize an array
        var list = [(String, String)]()
        
        do {
            // Get algorithms data
            if let result = try db?.prepare(links.order(generated.desc)) {
                // Iterate data
                for line in result {
                    // Create algorithm in list
                    list.append((try line.get(short), try line.get(full)))
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Return found algorithms
        return list
    }
    
    // Add a link
    func addLink(_ link: (String, String)) {
        do {
            // Insert data
            let _ = try db?.run(links.insert(short <- link.0, full <- link.1, generated <- Date()))
        } catch {
            print(error.localizedDescription)
        }
        
        // Check number of saves to ask for a review
        checkForReview()
    }
    
    // Delete an algorithm
    func clearHistory()  {
        do {
            // Delete data
            try db?.run(links.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Check for review
    func checkForReview() {
        // Check number of saves to ask for a review
        let datas = UserDefaults.standard
        let savesCount = datas.integer(forKey: "savesCount") + 1
        datas.set(savesCount, forKey: "savesCount")
        datas.synchronize()
        
        if savesCount == 10 || savesCount == 50 || savesCount % 100 == 0 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
}
