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
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loading collectionview")
        
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
    
    func reloadData() {
        
    }
    
    
}