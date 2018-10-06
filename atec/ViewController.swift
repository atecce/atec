//
//  ViewController.swift
//  atec
//
//  Created by Alex Tecce on 10/6/18.
//  Copyright © 2018 telos. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UITableViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var hits: [Hit] = []
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let hit = hits[indexPath.row]
        cell.textLabel?.text = hit.method + " " + hit.path + " " + hit.remoteAddr + " " + hit.host
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        delegate.database.delete(withRecordID: hits[indexPath.row].recordID) {
            
            record, error in
            
            if error != nil {
                print("error deleting record \(self.hits[indexPath.row].recordID): \(String(describing: error))")
                return
            }
            
            print("deleted record: \(String(describing: record))")
        }
        
        hits.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hits.count
    }

    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchHits(_:)), for: .valueChanged)
        fetch()
        super.viewDidLoad()
    }
    
    @objc private func fetchHits(_ sender: Any) {
        fetch()
    }
    
    private func fetch() {
        let hitNotFetched = NSPredicate(format: "NOT (recordID IN %@)", hits.map { $0.recordID })
        delegate.database.perform(CKQuery(recordType: "Hit", predicate: hitNotFetched), inZoneWith: nil) {
            
            records, error in
            
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let records = records else {
                return
            }
            
            print("hits: \(records)")
            _ = records.map { self.hits.append(Hit(record: $0)) }
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

