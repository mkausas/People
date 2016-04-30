//
//  DirectoryViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/28/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import AASquaresLoading

class DirectoryViewController: UIViewController {

    @IBOutlet weak var personTableView: PersonTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loaderView: UIView!
    
    let refreshControl = UIRefreshControl()
    var loader: AASquaresLoading!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader = AASquaresLoading(target: self.loaderView, size: 50)
        loader.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        loader.color = UIColor.whiteColor()
        loader.start()
        
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
                    self.loader.stop()
                    self.personTableView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            } else {
                print("error grabbing event attendees")
                self.loader.stop()
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


extension DirectoryViewController: PersonTableViewDelegate {
    func personTableViewDelegateReloadData() {
        reloadData()
    }
}