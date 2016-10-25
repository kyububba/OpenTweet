//
//  OpenTweetTests.swift
//  OpenTweetTests
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

class OpenTweetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimelineLoading() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let tweets = Tweet.timeline()
        
        XCTAssertEqual(tweets.count, 7, "tweet count")
        XCTAssertEqual(tweets[0].id, "00001")
        XCTAssertEqual(tweets[0].author, "@doge")
        XCTAssertEqual(tweets[0].content, "Wow, much tweet, such app!")
        XCTAssertEqual(tweets[0].avatarUrl, "http://doge2048.com/meta/doge-600.png")
        XCTAssertNil(tweets[0].inReplyTo)
        
        //date for first tweet 2016-09-29T14:41:00-08:00
        var dc = DateComponents()
        dc.year = 2016
        dc.month = 9
        dc.day = 29
        dc.hour = 14
        dc.minute = 41
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: -8 * 60 * 60)
        
        XCTAssertEqual(tweets[0].date, Calendar.current.date(from: dc))  //test date parsing
        
        XCTAssertEqual(tweets[6].inReplyTo, "00004")   //test in reply to
        
        XCTAssertEqual(tweets[1].id, "00042")
        XCTAssertEqual(tweets[2].id, "00003")
        XCTAssertNotNil(tweets[2].inReplyToTweet)
        XCTAssertEqual(tweets[2].inReplyToTweet!, tweets[1])
        
        XCTAssertEqual(tweets[1].replies?.count, 3)
        XCTAssertEqual(tweets[1].replies?[0], tweets[2])
        XCTAssertEqual(tweets[1].replies?[1], tweets[3])
        XCTAssertEqual(tweets[1].replies?[2], tweets[4])
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
