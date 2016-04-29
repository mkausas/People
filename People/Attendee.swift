//
//  Attendee.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Attendee {
    
    var name: String?
    var id: String?
    var rsvpStatus: String?
    
    var profileImage: UIImage?
    var profileImageURL: NSURL?
    
    init(attendeeDetails: NSDictionary) {
        name = attendeeDetails["name"] as? String
        id = attendeeDetails["id"] as? String
        rsvpStatus = attendeeDetails["rsvp_status"] as? String
        
        if let id = id {
            ApiClient.getUserPhoto(id) { (profileURL, error) in
                if error == nil {
                    self.profileImageURL = NSURL(string: profileURL!)
                    self.getDataFromUrl(NSURL(string: profileURL!)!, completion: { (data, response, error) in
                        if error == nil {
                            self.profileImage = UIImage(data: data!)
                        }
                    })
                }
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    class func groupFromJSON(attendeeArray: NSArray) -> [Attendee] {
        var attendees = [Attendee]()
        
        for attendee in attendeeArray {
            attendees.append(Attendee(attendeeDetails: attendee as! NSDictionary))
        }
        
        return attendees
    }
    
    class func attendeeFromCK(attendeeArray: [CKRecord]) -> [Attendee] {
        var attendees = [Attendee]()
        
        for attendeeRecord in attendeeArray {
            let attendee = Attendee(attendeeDetails: NSDictionary())
            
            let profileImageAsset = attendeeRecord.valueForKey("profileImage") as! CKAsset
            let profileImage = UIImage(contentsOfFile: profileImageAsset.fileURL.path!)
            
            attendee.name = attendeeRecord.valueForKey("name") as? String
            attendee.profileImage = profileImage
            
            attendees.append(attendee)
        }
        
        return attendees
    }
}