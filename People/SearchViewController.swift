//
//  SearchViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var personTableView: PersonTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func getData() {
        if ApiClient.USER_ID == nil {
            print("cannot grab data because we lack an id")
            ApiClient.getSelf({ (userID, error) in
                if error == nil {
                    ApiClient.getUserEvents(userID!) { (events, error) in
                        if error == nil {
                            self.personTableView.setData(events!)
                            self.personTableView.reloadData()
                        }
                    }
                }
            })
        }
    }
}

