//
//  PersonTableView.swift
//  People
//
//  Created by Martynas Kausas on 4/28/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import CloudKit

protocol PersonTableViewDelegate {
    func personTableViewDelegateReloadData()
}

class PersonTableView: UITableView {

    var people = [Attendee]()
    var filteredData = [Attendee]()
    var personTableViewDelegate: PersonTableViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupTableView()
    }
    
    func setupTableView() {
        // grab custom cell
        let cellNib = UINib(nibName: PersonTableViewCell.cellIdentifier, bundle: NSBundle.mainBundle())
        registerNib(cellNib, forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        
        self.rowHeight = 114
        
        self.allowsSelectionDuringEditing = true
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // set tableview data
        self.delegate = self
        self.dataSource = self
    }
}

extension PersonTableView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PersonTableViewCell.cellIdentifier, forIndexPath: indexPath) as! PersonTableViewCell
        
        cell.attendee = filteredData[indexPath.row]
        
        return cell
    }
}


extension PersonTableView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print("delete")
            let recordID = filteredData[indexPath.row].id
            self.filteredData.removeAtIndex(indexPath.row)
//            reloadData()
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            let container = CKContainer.defaultContainer()
            let privateDatabase = container.privateCloudDatabase
            privateDatabase.deleteRecordWithID(CKRecordID(recordName: recordID!), completionHandler: { (recordID, error) in

                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.personTableViewDelegate?.personTableViewDelegateReloadData()
                    })
                }
            })
            
        }
    }
    
}
