//
//  SearchViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var personTableView: EventTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SearchViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        personTableView.insertSubview(refreshControl, atIndex: 0)
        
        reloadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadData()
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        if ApiClient.USER_ID == nil {
            print("cannot grab data because we lack an id, getting self")
            
            ApiClient.getSelf({ (userID, error) in
                if error == nil {
                    self.getUserEvents()
                }
            })
        }
        
        else {
            getUserEvents()
        }
    }
    
    func getUserEvents() {
        ApiClient.getUserEvents(ApiClient.USER_ID!) { (events, error) in
            if error == nil {
                self.personTableView.setData(events!)
                self.personTableView.reloadData()
            }
        }
    }
}

