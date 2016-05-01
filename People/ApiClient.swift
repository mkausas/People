//
//  ApiClient.swift
//  People
//
//  Created by Martynas Kausas on 4/26/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import UIKit

class ApiClient {
    
    static var USER_ID: String?
    
    
    /** 
        Get User information about self
    */
    class func getSelf(completion: (userID: String?, error: NSError?) -> ()) {
        let params = ["fields": ""]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed request!")
            print("result = \(result)")
            
            
            if error == nil {
                self.USER_ID = (result as! NSDictionary)["id"] as? String
                completion(userID: self.USER_ID, error: error)
            } else {
                print("error retrieving self: \(error.userInfo)")
                completion(userID: nil, error: error)
            }
        }
    }
    
    /**
        Get User information
     */
    class func getUser(userID: String) {
        getUserData(userID, params: ["fields": "id, name, picture"]) { (result, error) in
            if error == nil {
                
                
            } else {
                
            }
        }
    }
    
    class func getUserData(userID: String, params: [String: AnyObject], completion: (result: AnyObject?, error: ErrorType?) -> ()) {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "\(userID)", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed request!")
            print("result = \(result)")
            
            completion(result: result, error: error)
        }
    }
    
    
    /**
        Grab a user photo url
     */
    class func getUserPhoto(userID: String, completion: (profileURL: String?, error: ErrorType?) -> ()) {
        let params = ["fields": "picture.type(large)"]//, "width": 500, "height": 500]
        let graphRequest = FBSDKGraphRequest(graphPath: "\(userID)", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed request!")
            print("result = \(result)")
            print("error = \(error)")
            
            if error == nil {
                
                let picture = result!["picture"] as! NSDictionary
                let photoURL = picture["data"]!["url"] as? String
                completion(profileURL: photoURL, error: nil) // finish this method
            }
            
            else {
                completion(profileURL: nil, error: error)
            }
        }
    }
    
    
    /**
        Get events related to a User
     */
    class func getUserEvents(userID: String, completion: (events: [Event]?, error: NSError?) -> ()) {
        
        if FBSDKAccessToken.currentAccessToken().hasGranted("user_events") == false {
            print("lacking access to events")
            
            // Fake Data for Demo
//            getEventsFromIDs(BackupEvents.eventIDs, completion: { (events, error) in
//                if error == nil {
//                    completion(events: events, error: nil)
//                } else {
//                    completion(events: nil, error: error)
//                }
//                
//            })
            
            return
        }
        
        
        let params = ["fields": "id, name, cover, description, guest_list_enabled, owner, start_time", "limit": "50"]
        let path = "\(userID)/events"
        
        let graphRequest = FBSDKGraphRequest(graphPath: path, parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed grabbing events request!")
            print("result = \(result)")
            
            if error == nil {
                var events = [Event]()
                for event in (result["data"] as! NSArray) {
                    events.append(Event(eventDetails: event as! NSDictionary))
                }
                
                completion(events: events, error: nil)
            } else {
                print("error retrieving events: \(error)")
                completion(events: nil, error: error)
            }
        }
    }
    
    /**
        Get the attendees list of a given event
     */
    class func getEventAttendees(event: Event, completion: (attendees: [Attendee]?, error: ErrorType?) -> ()) {
        let params = ["fields": "", "limit": "1000"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "\(event.id!)/attending", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed grabbing event attendee list!")
            print("result = \(result)")
            
            if error == nil {
                let data = result["data"] as? NSArray
                let people = Attendee.groupFromJSON(data! as! [NSDictionary], event: event)
        
                completion(attendees: people, error: nil)
            } else {
                print("error retrieving event attendees: \(error)")
                completion(attendees: nil, error: error)
            }
        }
    }
    
    /**
        Get set of events from list of event IDs
    */
    class func getEventsFromIDs(eventIDs: [String], completion: (events: [Event]?, error: NSError?) -> ()) {
        
        var allEvents = [Event]()
        
        if eventIDs.count > 0 {
            print("grabbing event: \(eventIDs[0])")
            getEvent(eventIDs[0]) { (event, error) in
                if error == nil {
                    if event != nil {
                        allEvents.append(event!)
                    }
                        
                    let neededEventIDs = Array(eventIDs.dropFirst())
                    getEventsFromIDs(neededEventIDs) { (events, error) in
                        if error == nil  {
                            if let events = events {
                                allEvents += events
                            }
                            completion(events: allEvents, error: nil)
                        }
                    }
                } else {
                    completion(events: nil, error: nil)
                }
            }
        }
    }
    
    
    
    /**
        Grab an event using it's event ID
     */
    class func getEvent(eventID: String, completion: (event: Event?, error: ErrorType?) -> ()) {
        let params = ["fields": ""]
        
        let graphRequest = FBSDKGraphRequest(graphPath: eventID, parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed grabbing event!")
            print("result = \(result)")
            
            if error == nil {
                let data = result as? NSDictionary
                let event = Event(eventDetails: data!)

                completion(event: event, error: nil)
            } else {
                print("error retrieving event: \(error)")
                completion(event: nil, error: error)
            }
        }
    }
    
    
    /**
        Search for a user based on name
     */
    class func searchPerson(searchText: String, completion: (people: [Attendee]?, error: NSError?) -> ()) {
        
        let params = ["fields": "id, name, picture", "limit": 50]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "search?q=\(searchText)&type=user", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed searching for person!")
            print("result = \(result)")
            
            if error == nil {
                let data = result["data"] as? NSArray
                let people = Attendee.groupFromJSON(data! as! [NSDictionary], event: nil)
                
                completion(people: people, error: nil)
            } else {
                print("error retrieving events: \(error)")
                
                completion(people: nil, error: error)
            }
        }
    }
    
    /**
        Check if the user is logged in
    */
    class func checkLoggedIn(error: NSError?) -> Bool {
        
        if let err = error {
            if err.userInfo["com.facebook.sdk:FBSDKErrorDeveloperMessageKey"] != nil {
                return false
            }
        }
        
        return true
    }
}