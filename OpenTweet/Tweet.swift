//
//  Tweet.swift
//  OpenTweet
//
//  Created by Kai Yu on 10/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation

class Tweet: Equatable {
    
    var id: String
    var date: Date
    var author: String
    var content: String
    var avatarUrl: String?
    var inReplyTo: String?
    var imageUrl: String?
    
    var inReplyToTweet: Tweet?
    
    var replies: [Tweet]?
    
    init?(json: [String: Any]) {
        // id, date, author, and content should be required fields.
        guard let id = json["id"] as? String,
            let dateString = json["date"] as? String,
            let author = json["author"] as? String,
            let content = json["content"] as? String else {
            return nil
        }
        
        self.id = id
        self.author = author
        self.content = content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
        if let date = dateFormatter.date(from: dateString) {
            self.date = date
        }
        else {
            self.date = Date(timeIntervalSince1970: 0)  //in case of parsing error, treat date as unix zero time
        }
        
        self.avatarUrl = json["avatar"] as? String
        self.inReplyTo = json["inReplyTo"] as? String
        
        //no images in sample data
//        self.imageUrl = json["image"] as? String
    }
    
    private func addReply(_ tweet: Tweet) {
        if (self.replies==nil) {
            self.replies = []
        }
        self.replies?.append(tweet)
    }
    
    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id==rhs.id
    }
    
    //returns tweets from the bundle json file, sorted ascending by time
    static func timeline() -> [Tweet] {
        var tweets: [Tweet] = []
        var tweetMap : [String: Tweet] = Dictionary()
        if let url = Bundle.main.url(forResource: "timeline", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            for case let item in json?["timeline"] as! [[String: Any]] {
                if let tweet = Tweet(json: item) {
                    tweets.append(tweet)
                    tweetMap[tweet.id] = tweet
                }
            }
        }
        
        tweets.sort(by: { return $0.date < $1.date })
        
        //attach the in-reply-to tweets and add replies to parent
        for tweet in tweets {
            if let replyId = tweet.inReplyTo {
                let parentTweet = tweetMap[replyId]
                tweet.inReplyToTweet = parentTweet
                parentTweet?.addReply(tweet)
            }
        }
        
        return tweets
    }
}
