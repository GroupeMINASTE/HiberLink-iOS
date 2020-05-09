//
//  HistoryTableViewController.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, HistoryDelegate {
    
    var links = [(String, String)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        navigationItem.title = "history_title".localized()
        
        // Register cells
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "subtitleCell")
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: "labelCell")
        
        // Auto resizing cells
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        // Clear button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "history_clear".localized(), style: .plain, target: self, action: #selector(clear(_:)))
        
        // Load content
        loadContent()
    }
    
    func loadContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Load from database
            self.links = Database.current.getLinks()
            
            DispatchQueue.main.async {
                // Refresh tableView
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func clear(_ sender: UIBarButtonItem) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Load from database
            Database.current.clearHistory()
            
            DispatchQueue.main.async {
                // Refresh tableView
                self.links.removeAll()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? links.count : 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "history_title".localized() : "more_title".localized()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
            let link = links[indexPath.row]
            
            cell.textLabel?.text = link.0
            cell.detailTextLabel?.text = link.1

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "HiberFile"
            case 1:
                cell.textLabel?.text = "Groupe MINASTE"
            case 2:
                cell.textLabel?.text = "more_translate".localized()
            case 3:
                cell.textLabel?.text = "more_source_code".localized()
            default:
                fatalError()
            }

            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Copy link
            let link = links[indexPath.row]
            UIPasteboard.general.string = link.0
            
            // Show confirmation
            let alert = UIAlertController(title: "copied_title".localized(), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "copied_close".localized(), style: .default) { action in })
            present(alert, animated: true, completion: nil)
        } else {
            switch indexPath.row {
            case 0:
                if let url = URL(string: "https://hiberfile.com") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            case 1:
                if let url = URL(string: "https://www.groupe-minaste.org") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            case 2:
                if let url = URL(string: "https://weblate.groupe-minaste.org/projects/hiberlink/") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            case 3:
                if let url = URL(string: "https://github.com/GroupeMINASTE/HiberLink-iOS") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            default:
                fatalError()
            }
        }
    }

}
