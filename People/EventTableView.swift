//
//  EventTableView.swift
//  events
//
//  Created by Martynas Kausas on 4/27/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit

protocol EventTableViewDelegate {
    func eventTableViewShowDetail(event: Event)
}

class EventTableView: UITableView {
    
    var events = [Event]()
    var eventTableViewDelegate: EventTableViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupTableView()
    }
    
    func setData(data: [Event]) {
        events = data
    }
    
    func setupTableView() {
        // grab custom cell
        let cellNib = UINib(nibName: EventTableViewCell.cellIdentifier, bundle: NSBundle.mainBundle())
        registerNib(cellNib, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        
        // set tableview data
        self.delegate = self
        self.dataSource = self
    }
    

}

extension EventTableView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCell.cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        
        cell.event = events[indexPath.row]
        
        return cell
    }
}

extension EventTableView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        eventTableViewDelegate?.eventTableViewShowDetail(events[indexPath.row])
    }
}
