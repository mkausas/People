//
//  WebViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/28/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            let requestObj = NSURLRequest(URL: url)
            webView.loadRequest(requestObj);
        }
        
//        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }

    @IBAction func onDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    
    // force touch option buttons
    override func previewActionItems() -> [UIPreviewActionItem] {
        let regularAction = UIPreviewAction(title: "Save", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in

        }
    
        return [regularAction]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        UIApplication.sharedApplication().statusBarHidden = false
    }
 

}
