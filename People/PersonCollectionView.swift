//
//  PersonCollectionView.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class PersonCollectionView: UICollectionView {
    
    var people = [Attendee]()
    
    func setupData() {
        
        // grab custom person cell
        let cellNib = UINib(nibName: PersonCollectionViewCell.cellIdentifier, bundle: NSBundle.mainBundle())
        registerNib(cellNib, forCellWithReuseIdentifier: PersonCollectionViewCell.cellIdentifier)
        
        self.delegate = self
        self.dataSource = self
    }
    
    func setPeople(attendees: [Attendee]) {
        people = attendees
        reloadData()
    }
    

    
    func setPersonImage(index: Int, image: UIImage) {
        people[index].profileImage = image
    }
}

extension PersonCollectionView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PersonCollectionViewCell.cellIdentifier, forIndexPath: indexPath) as! PersonCollectionViewCell
        
        let currAttendee = people[indexPath.row]
        cell.attendee = currAttendee
        
        return cell
    }
    
    
}

extension PersonCollectionView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
}
