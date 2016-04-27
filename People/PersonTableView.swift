//
//  PersonTableView.swift
//  People
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

class PersonTableView: UITableView {

    var people = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initTestData()
        setupTableView()
    }
    
    func setData(data: [String]) {
        people = data
    }
    
    func setupTableView() {
        // grab custom cell
        let cellNib = UINib(nibName: PersonTableViewCell.cellIdentifier, bundle: NSBundle.mainBundle())
        registerNib(cellNib, forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        
        
        // set tableview data
        self.delegate = self
        self.dataSource = self
    }
    
    func initTestData() {
        people.append("Marty")
        people.append("Dung")
    }

}

extension PersonTableView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PersonTableViewCell.cellIdentifier, forIndexPath: indexPath) as! PersonTableViewCell
        
        cell.nameLabel.text = people[indexPath.row]
        
        return cell
    }
}

extension PersonTableView: UITableViewDelegate {
    
}
