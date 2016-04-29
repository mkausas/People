//
//  DirectoryViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/28/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController {

    @IBOutlet weak var personTableView: PersonTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiClient.getEventAttendees("1561543284172468") { (attendees, error) in
            if error == nil {
                self.personTableView.people = attendees!
                self.personTableView.reloadData()
            } else {
                print("error grabbing event attendees")
            }
        }
        
        // pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(DirectoryViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        personTableView.insertSubview(refreshControl, atIndex: 0)
        
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadData()
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        // TODO: Add reload data here
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
