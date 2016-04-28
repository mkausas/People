//
//  PersonCollectionViewCell.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import Haneke

class PersonCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static var cellIdentifier = "PersonCollectionViewCell"
    
    var attendeeIndex: Int?
    var attendee: Attendee? {
        didSet {
            nameLabel.text = attendee?.name

            if let img = attendee?.profileImage {
                profileImageView.image = img
            }
        }
    }
    
    override func prepareForReuse() {
        profileImageView.image = UIImage()
        nameLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
    }
}
