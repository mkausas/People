//
//  EventDetailViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit



class EventDetailViewController: UIViewController {

    @IBOutlet weak var personCollectionView: PersonCollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var event: Event? {
        didSet {
            if let attendees = event?.attendees {
                personCollectionView.setPeople(attendees)
            }
            
            self.title = event?.title!
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: personCollectionView)
        }
        
        personCollectionView.personCollectionViewDelegate = self
        personCollectionView.setupData()
        
        searchBar.delegate = self
        
        if let attendees = event?.attendees {
            personCollectionView.setPeople(attendees)
            print("set attendees")
        }
        
        // pull down to refresh
        refreshControl.addTarget(self, action: #selector(SearchViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        personCollectionView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
//        refreshControl.endRefreshing()
        reloadData()
    }
    
    func reloadData() {
        
        if let event = event {
            ApiClient.getEventAttendees(event) { (attendees, error) in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.personCollectionView.setPeople(attendees!)
                        self.refreshControl.endRefreshing()
                    })
                }
            }
        }
    }
    
    var webViewUrl: String?
    var webViewAttendee: Attendee?
}

extension EventDetailViewController: PersonCollectionViewDelegate {
    
    func personCollectionViewPresent(url: String, attendee: Attendee) {
        self.webViewUrl = url
        self.webViewAttendee = attendee
    }
}

extension EventDetailViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as? WebViewController else { return nil }
        
        if let url = webViewUrl {
            viewController.url = NSURL(string: url)!
            viewController.attendee = self.webViewAttendee
            viewController.preferredContentSize = CGSize(width: 0, height: 0)
            return viewController
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.presentViewController(viewControllerToCommit, animated: true, completion: nil)
        
    }
}

extension EventDetailViewController: UISearchBarDelegate {
    
    // Updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let people = personCollectionView.people
        
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            personCollectionView.filteredData = people
        } else {
            
            // search through names and keep only matches
            personCollectionView.filteredData = searchText.isEmpty ? people : people.filter({(attendee: Attendee) -> Bool in
                return attendee.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
        }
        personCollectionView.reloadData()
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