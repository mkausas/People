//
//  Attendee.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation

class Attendee {
    
    var name: String?
    var id: Int?
    var rsvpStatus: String?
    
    init(attendeeDetails: NSDictionary) {
        name = attendeeDetails["name"] as? String
        id = attendeeDetails["id"] as? Int
        rsvpStatus = attendeeDetails["rsvp_status"] as? String
    }
    
    
    class func groupFromJSON(attendeeArray: NSArray) -> [Attendee] {
        var attendees = [Attendee]()
        
        for attendee in attendeeArray {
            attendees.append(Attendee(attendeeDetails: attendee as! NSDictionary))
        }
        
        return attendees
    }
}