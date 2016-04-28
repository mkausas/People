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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personCollectionView.personCollectionViewDelegate = self
        personCollectionView.setupData()
                
        if let attendees = event?.attendees {
            personCollectionView.setPeople(attendees)
            print("set attendees")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EventDetailViewController: PersonCollectionViewDelegate {
    func personCollectionViewPresent(url: NSURL) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        self.presentViewController(vc, animated: true, completion: nil)
        vc.url = url

    }
}
