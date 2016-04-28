//
//  EventTableViewCell.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import AFNetworking

class EventTableViewCell: UITableViewCell {
    
    static var cellIdentifier = "EventTableViewCell"
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var event: Event? {
        didSet {
            titleLabel.text = event?.title
            ownerLabel.text = event?.owner
            dateLabel.text = event?.date
            
            if let attendeeCount = event?.attendees?.count {
                countLabel.text = "\(attendeeCount)"
            }
            
            if let URL = event?.coverURL {
                bannerImageView.setImageWithURL(NSURL(string: URL)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerImageView.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
