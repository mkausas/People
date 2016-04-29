//
//  CloudKitClient.swift
//  People
//
//  Created by Martynas Kausas on 4/29/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloudKitClient {
    
    class func savePerson(person: Attendee) {
        let noteID = CKRecordID(recordName: person.id!)
        
        // CKRecord denotes a row in the table
        let personRecord = CKRecord(recordType: "People", recordID: noteID)
        personRecord.setObject(person.name, forKey: "name")
//        personRecord.setObject(person.eventName, forKey: "eventName")
//        personRecord.setObject(person.eventID, forKey: "eventID")
//        personRecord.setObject(person.eventDate, forKey: "eventDate")
        
//        personRecord.setObject(NSDate(), forKey: "noteEditedDate")
        
        let imageURL = saveImageLocally(person.profileImage, path: "temp_image_\(person.id!).jpg")
        
        // set profile image to object
        if let url = imageURL {
            let imageAsset = CKAsset(fileURL: url)
            personRecord.setObject(imageAsset, forKey: "profileImage")
        }
        
        saveRecord(personRecord)
        deleteLocalPhoto(imageURL)
    }
    
    // save image locally for passing url to CloudKit
    class func saveImageLocally(image: UIImage?, path: String) -> NSURL? {
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let tempImageName = path
        
        // grab profile image and save locally
        let imageData: NSData = UIImageJPEGRepresentation(image!, 0.8)!
        let path = documentsDirectoryPath.stringByAppendingPathComponent(tempImageName)
        let imageURL: NSURL? = NSURL(fileURLWithPath: path)
        imageData.writeToURL(imageURL!, atomically: true)
        
        return imageURL
    }
    
    
    // save row to Cloudkit
    class func saveRecord(record: CKRecord) {
        // grab private private db
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        
        // save the record to the user's private database
        privateDatabase.saveRecord(record, completionHandler: { (record, error) -> Void in
            if error == nil {
                print("success pushing to CloudKit!")
            } else {
                print(error)
            }
        })
    }
    
    // delete a photo locally from url
    class func deleteLocalPhoto(imageURL: NSURL?) {
        // delete the temp photo we saved
        if let url = imageURL {
            let fileManager = NSFileManager()
            if fileManager.fileExistsAtPath(url.absoluteString) {
                do {
                    try fileManager.removeItemAtURL(url)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    
    
    // --- Retrieval of Data --- //
    
    static var peopleRecords = [CKRecord]()
    class func getPeople(completion: (people: [Attendee]?, error: NSError?) -> ()) {
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "People", predicate: predicate)
        
        privateDatabase.performQuery(query, inZoneWithID: nil) { (results, error) -> Void in
            if error == nil {
                print(results)
                
                let people = Attendee.attendeeFromCK(results!)
                completion(people: people, error: nil)
            
            } else {
                completion(people: nil, error: error)
            }
        }
    }
    
    
    
}

