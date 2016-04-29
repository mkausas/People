//
//  PersonCollectionView.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

protocol PersonCollectionViewDelegate {
    func personCollectionViewPresent(url: String)
}

class PersonCollectionView: UICollectionView {
    
    var people = [Attendee]()
    var personCollectionViewDelegate: PersonCollectionViewDelegate?
    
    
    
    func setupData() {
        
        // grab custom person cell
        let cellNib = UINib(nibName: PersonCollectionViewCell.cellIdentifier, bundle: NSBundle.mainBundle())
        registerNib(cellNib, forCellWithReuseIdentifier: PersonCollectionViewCell.cellIdentifier)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.frame.width/3, height: 1.366 * (self.frame.width / 3) )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionViewLayout = layout
        
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
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("highlighted")
        
        let url = "https://www.facebook.com/\(people[indexPath.row].id!)"
        personCollectionViewDelegate?.personCollectionViewPresent(url)
        
        return false
    }
    
//    minimumInteritemSpacingForSectionAtIndex
    
}
