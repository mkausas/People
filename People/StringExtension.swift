//
//  StringExtension.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation

extension String {
    
    static func dateFromString(dateString: String) -> NSDate? {        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'-'SSSS"
        return dateFormatter.dateFromString(dateString)
    }
}