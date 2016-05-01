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
    
    @IBOutlet weak var personCollectionView: PersonCollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var loader: AASquaresLoading!
    let refreshControl = UIRefreshControl()
    
    // person search
    var webViewUrl: String?
    var webViewAttendee: Attendee?
    
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
        
        personCollectionView.setupData()
        
        // pull down to refresh
        refreshControl.addTarget(self, action: #selector(SearchViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        personTableView.insertSubview(refreshControl, atIndex: 0)
        
        setupPersonSearch()
    }
    
    func setupPersonSearch() {
        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: personCollectionView)
        }
        
        personCollectionView.personCollectionViewDelegate = self
        personCollectionView.insertSubview(refreshControl, atIndex: 0)
    }
    

    @IBAction func onModeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        
        // Search Event
        case 0:
            getUserEvents()
            personTableView.hidden = false
            personCollectionView.hidden = true
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            break
            
    
        // Search Person
        case 1:
            getSearchedUser()
            personTableView.hidden = true
            personCollectionView.hidden = false
            searchBar.becomeFirstResponder()
            break
            
        default: break
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        reloadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadData()
    }
    
    func reloadData() {
        if segmentedControl.selectedSegmentIndex == 0 {
            reloadEventData()
        } else {
            getSearchedUser()
        }
    }

    func reloadEventData() {
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
            if error == nil && events != nil {
                self.personTableView.setData(events!)
                self.personTableView.reloadData()
            }
            self.loader.stop()
            self.refreshControl.endRefreshing()
        }
    }
    
    func getSearchedUser() {
        ApiClient.searchPerson(searchBar.text!) { (people, error) in
            if error == nil { 
                self.personCollectionView.setPeople(people!)
            }
            self.refreshControl.endRefreshing()

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
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let events = personTableView.events
            
            personTableView.filteredEvents = searchText.isEmpty ? events : events.filter({(event: Event) -> Bool in
                
                let containsEventTitle = event.title!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                let containsEventAuthor = event.owner!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                
                return containsEventTitle || containsEventAuthor
            })
            
            personTableView.reloadData()
        }
        else {
            getSearchedUser()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        getSearchedUser()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}



