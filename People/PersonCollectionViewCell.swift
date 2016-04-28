//
//  PersonCollectionViewCell.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static var cellIdentifier = "PersonCollectionViewCell"

    var attendee: Attendee? {
        didSet {
//            profileImageView.image = 
            nameLabel.text = attendee?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
    }
}
