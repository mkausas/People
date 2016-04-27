//
//  ApiClient.swift
//  People
//
//  Created by Martynas Kausas on 4/26/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class ApiClient {
    
    static var USER_ID: String?
    
    
    /** 
        Get User information about self
    */
    class func getSelf(completion: (userID: String?, error: ErrorType?) -> ()) {
        let params = ["fields": ""]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed request!")
            print("result = \(result)")
            
            if error == nil {
                self.USER_ID = (result as! NSDictionary)["id"] as? String
                completion(userID: self.USER_ID, error: error)
            } else {
                print("error retrieving self: \(error)")
                completion(userID: nil, error: error)
            }
        }
    }
    
    /**
        Get User information
     */
    class func getUser(userID: String) {
        let params = ["fields": "id, name, picture"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "\(userID)", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed request!")
            print("result = \(result)")
            
            if error == nil {
                self.USER_ID = (result as! NSDictionary)["id"] as? String
//                getUserEvents(self.USER_ID!)
                getUserEvents(self.USER_ID!, completion: { (events, error) in
                })
            } else {
                print("error retrieving user: \(error)")
            }
        }
    }
    
    
    
    /**
        Get events related to a User
     */
    class func getUserEvents(userID: String, completion: (events: [String]?, error: ErrorType?) -> ()) {
        
        
        if FBSDKAccessToken.currentAccessToken().hasGranted("user_events") == false {
            print("lacking access to events")
            return
        }
        
        
        let params = ["fields": "id, name, cover, description, guest_list_enabled, owner"]
        let graphRequest = FBSDKGraphRequest(graphPath: "\(userID)/events", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed grabbing events request!")
            print("result = \(result)")
            
            if error == nil {
                getEventAttendees("1561543284172468")
                
                var eventTitles = [String]()
                for event in (result["data"] as! NSArray) {
                    eventTitles.append(event["name"] as! String)
                }
                
                completion(events: eventTitles, error: nil)
            } else {
                print("error retrieving events: \(error)")
                completion(events: nil, error: error)
            }
        }
    }
    
    
    /**
        Get the attendees list of a given event
     */
    class func getEventAttendees(eventID: String) {
        let params = ["fields": "id, name, rsvp_status"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "\(eventID)/attending", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed grabbing event attendee list!")
            print("result = \(result)")
            
            if error == nil {
                searchPerson("Annie")
                
            } else {
                print("error retrieving event attendees: \(error)")
            }
        }
    }
    
    
    /**
        Search for a user based on name
     */
    class func searchPerson(searchText: String) {
        
        let params = ["fields": "id, name"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "search?q=\(searchText)&type=user", parameters: params, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            print("completed searching for person!")
            print("result = \(result)")
            
            if error == nil {
                
            } else {
                print("error retrieving events: \(error)")
            }
        }
    }
}