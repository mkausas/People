//
//  QuizViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/30/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import AASquaresLoading

class QuizViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameCoverView: UIView!
    @IBOutlet weak var loaderView: UIView!
    
    var people = [Attendee]()
    var loader: AASquaresLoading!

    
    // state used to denote when in show/shown/next
    var state: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader = AASquaresLoading(target: self.loaderView, size: 50)
        loader.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        loader.color = UIColor.whiteColor()
        
        nameLabel.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        loader.start()
        reloadData()
    }
    
    var prevIndex = 0
    func reset() {
        
        if people.count < 1 {
            return
        }
        
        // get random index different from the previous
        var index = 0
        repeat {
            if people.count == 0 {
                break
            }
            
            index = Int(arc4random_uniform(UInt32(people.count)))
            print("index = \(index)")
            
        } while index == prevIndex
        
        let person = people[index]
        nameLabel.text = person.name
        profileImageView.image = person.profileImage
        print(person.profileImageURL)
        
        prevIndex = index
    }
    
    func reloadData() {
        CloudKitClient.getPeople { (people, error) in
            if error == nil {
                self.people = people!
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loader.stop()
                    self.reset()
                })
            } else {
                print("error grabbing event attendees")
                self.loader.stop()
            }
        }
    }
    
    
    
    @IBAction func onBottomViewClick(sender: AnyObject) {
        
        switch state {
        case 0:
            
            UIView.animateWithDuration(0.7, animations: {
                
                self.nameLabel.alpha = 1
            })
            bottomLabel.text = "next"
            break
            
        case 1:
            nameLabel.alpha = 0
            bottomLabel.text = "show"
            
        default:
            break
        }
        
        
        // reset
        if state == 1 {
            state = 0
            reset()
        } else {
            state += 1
        }
        
        
    }

    
}
