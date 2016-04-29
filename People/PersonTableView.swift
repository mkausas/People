//
//  PersonTableView.swift
//  People
//
//  Created by Martynas Kausas on 4/28/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class PersonTableView: UITableView {

    var people = [Attendee]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupTableView()
    }
    
    func setupTableView() {
        // grab custom cell
        let cellNib = UINib(nibName: PersonTableViewCell.cellIdentifier, bundle: NSBundle.mainBundle())
        registerNib(cellNib, forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        
        self.rowHeight = 114
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // set tableview data
        self.delegate = self
        self.dataSource = self
    }
}

extension PersonTableView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PersonTableViewCell.cellIdentifier, forIndexPath: indexPath) as! PersonTableViewCell
        
        cell.attendee = people[indexPath.row]
        
        return cell
    }
}


extension PersonTableView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        CloudKitClient.savePerson(people[indexPath.row])
    }
    
}
