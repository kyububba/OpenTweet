//
//  TimelineViewController.swift
//  OpenTweet
//
//  Created by Kai Yu on 10/24/2016.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {
    
    // MARK: properties

    var tweets: [Tweet]! = []
        
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tweets = Tweet.timeline()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        //get rid of separators lines for empty cells
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell

        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    
    // MARK: - Simple cell animation
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tweetCell = cell as! TweetTableViewCell
        tweetCell.animateDisplay()
    }
    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "tweetDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="tweetDetailSegue",
            let tweetDetailVC = segue.destination as? ThreadViewController,
            self.tableView.indexPathForSelectedRow != nil,
            let tweetIndex = self.tableView.indexPathForSelectedRow?.row {
            
            tweetDetailVC.tweet = self.tweets[tweetIndex]
            
            (segue as! TweetDetailSegue).tweet = self.tweets[tweetIndex]
        }
    }

}
