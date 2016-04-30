//
//  SearchViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import AASquaresLoading

class SearchViewController: UIViewController {

    @IBOutlet weak var personTableView: EventTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loaderView: UIView!
    
    
    var loader: AASquaresLoading!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader = AASquaresLoading(target: self.loaderView, size: 50)
        loader.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        loader.color = UIColor.whiteColor()
        loader.start()
        
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.tabBarController!.tabBar.barTintColor = UIColor.blackColor()
        self.tabBarController!.tabBar.tintColor = UIColor.whiteColor()


        searchBar.delegate = self
        personTableView.eventTableViewDelegate = self
        
        // pull down to refresh
        refreshControl.addTarget(self, action: #selector(SearchViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        personTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
//        self.view.squareLoading.start(0.0)
        reloadData()
        
    }

    func reloadData() {
        if ApiClient.USER_ID == nil {
            print("cannot grab data because we lack an id, getting self")
            
            ApiClient.getSelf({ (userID, error) in
                if error == nil {
                    self.getUserEvents()
                }
                
                else {
                    if ApiClient.checkLoggedIn(error) == false {
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
                        
                        self.presentViewController(vc!, animated: true, completion: {
                            print("presented")
                        })
                    }
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
                self.loader.stop()
                self.personTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if let vc = destinationViewController as? EventDetailViewController {
            
            let event = personTableView.filteredEvents[personTableView.indexPathForSelectedRow!.row]
            ApiClient.getEventAttendees(event) { (attendees, error) in
                if error == nil {
                    let selectedRow = self.personTableView.selectedRowIndex!
                    print("self.personTableView.indexPathForSelectedRow!.row = \(self.personTableView.selectedRowIndex)")
                    self.personTableView.filteredEvents[selectedRow].attendees = attendees
                    vc.event = event
                    
                } else {
                    print("Error: \(error)")
                }
            }
        }
    }
}

extension SearchViewController: EventTableViewDelegate {
    func eventTableViewShowDetail(event: Event) {
        self.performSegueWithIdentifier("showEventDetail", sender: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let events = personTableView.events
        
        personTableView.filteredEvents = searchText.isEmpty ? events : events.filter({(event: Event) -> Bool in
            
            let containsEventTitle = event.title!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            let containsEventAuthor = event.owner!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            
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

