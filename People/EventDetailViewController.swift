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
    
    var event: Event? {
        didSet {
            personCollectionView.setPeople(event!.attendees!)
            self.title = event!.title!

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .Available {
            
            self.registerForPreviewingWithDelegate(self, sourceView: personCollectionView)
        }
        
        personCollectionView.personCollectionViewDelegate = self
        personCollectionView.setupData()
        
        if let attendees = event?.attendees {
            personCollectionView.setPeople(attendees)
            print("set attendees")
        }
        
        // check for force touch
//        if( traitCollection.forceTouchCapability == .Available) {
//            registerForPreviewingWithDelegate(self, sourceView: view)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var webViewUrl: String?
}

extension EventDetailViewController: PersonCollectionViewDelegate {
    
    func personCollectionViewPresent(url: String) {
        self.webViewUrl = url
    }
}

extension EventDetailViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as? WebViewController else { return nil }
        
        viewController.url = NSURL(string: webViewUrl!)!
        viewController.preferredContentSize = CGSize(width: 0, height: 0)
        
        return viewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.presentViewController(viewControllerToCommit, animated: true, completion: nil)
        
    }
    
    
}
