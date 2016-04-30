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
    @IBOutlet weak var searchBar: UISearchBar!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        
        searchBar.delegate = self
        
        // pull down to refresh
        refreshControl.addTarget(self, action: #selector(DirectoryViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        personTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadData()
    }
    
    func reloadData() {
        CloudKitClient.getPeople { (people, error) in
            if error == nil {
                self.personTableView.people = people!
                self.personTableView.filteredData = people!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.personTableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            } else {
                print("error grabbing event attendees")
            }
        }
    }
}

extension DirectoryViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let people = personTableView.people
        
        personTableView.filteredData = searchText.isEmpty ? people : people.filter({(attendee: Attendee) -> Bool in
            
            let containsEventTitle = attendee.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            let containsEventAuthor = attendee.eventName!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            
            return containsEventTitle || containsEventAuthor
        })
        
        personTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
