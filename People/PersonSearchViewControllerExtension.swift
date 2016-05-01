//
//  PersonSearchViewControllerExtension.swift
//  People
//
//  Created by Martynas Kausas on 4/30/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: PersonCollectionViewDelegate {
    
    func personCollectionViewPresent(url: String, attendee: Attendee) {
        self.webViewUrl = url
        self.webViewAttendee = attendee
    }
}

extension SearchViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as? WebViewController else { return nil }
        
        if let url = webViewUrl {
            viewController.url = NSURL(string: url)!
            viewController.attendee = self.webViewAttendee
            viewController.preferredContentSize = CGSize(width: 0, height: 0)
            return viewController
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.presentViewController(viewControllerToCommit, animated: true, completion: nil)
        
    }
}