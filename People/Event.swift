//
//  Event.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation


class Event {
    
    var title: String?
    var owner: String?
    var date: String?
    var count: Int?
    var id: String?
    
    var attendees: [Attendee]?
    
    var coverURL: String?
    
    init(eventDetails: NSDictionary) {
        title = eventDetails["name"] as? String ?? "NO TITLE"
        title = title?.uppercaseString
        
        if let ownerDetails = eventDetails["owner"]  {
            owner = ownerDetails["name"] as? String
        }
        
        let eventDate = eventDetails["start_time"] as? String
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        date = dateFormatter.stringFromDate(String.dateFromString(eventDate!)!) 
        
        id = eventDetails["id"] as? String
        
        if let cover = eventDetails["cover"] {
            coverURL = cover["source"] as? String
        }
    }
}