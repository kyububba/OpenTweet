//
//  ThreadViewController.swift
//  OpenTweet
//
//  Created by Kai Yu on 10/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class ThreadViewController: UITableViewController {

    // MARK: properties

    var tweet: Tweet? {
        didSet {
            self.tweetOrdered = []
            if let t = self.tweet {
                self.tweetOrdered.append(t)
                if ((t.replies?.count ?? 0) > 0) {
                    self.tweetOrdered.append(contentsOf: t.replies!)
                }
            
                var inReplyTo = t.inReplyToTweet
                while (inReplyTo != nil) {
                    self.tweetOrdered.insert(inReplyTo!, at: 0)
                    inReplyTo = inReplyTo?.inReplyToTweet
                }
            }
            
        }
    }
    
    var tweetOrdered: [Tweet]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.allowsSelection = false
        //get rid of separators lines for empty cells
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetOrdered?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell

        // Configure the cell...
        cell.tweet = self.tweetOrdered[indexPath.row]
        
        return cell
    }

    // Mark: nil navigation

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}
