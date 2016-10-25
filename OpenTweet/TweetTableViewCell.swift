//
//  TweetTableViewCell.swift
//  OpenTweet
//
//  Created by Kai Yu on 10/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var replyToLabel: UILabel!
    @IBOutlet weak var authorTopConstraint: NSLayoutConstraint!
    
    var tweet: Tweet? {
        didSet {
            self.updateReplyToLabel()
            self.authorLabel.text = tweet?.author
            self.updateAvatarImage()
            self.updateDateLabel()

            self.updateContentLabel()
        }
    }
    
    func updateReplyToLabel() {
        //only trick here is to adjust the top constraint for the author label when reply to isn't there, in order for auto layout to size the cell correctly
        if (self.tweet?.inReplyTo==nil) {
            self.replyToLabel.text = nil;
            self.replyToLabel.isHidden = true
            self.authorTopConstraint.constant = 0
        }
        else {
            self.replyToLabel.text = "In Reply To \( (self.tweet?.inReplyToTweet?.author)! )"
            self.replyToLabel.isHidden = false
            self.authorTopConstraint.constant = 4
        }
    }
    
    func updateAvatarImage() {
        self.avatarView.setImage(fromURL: tweet?.avatarUrl,
                                 placeholder: UIImage.image(withColor: UIColor.lightGray,
                                                            opaque: true,
                                                            size: CGSize(width:1, height: 1)))
        
        //this just adds a circular mask to the image, and a thin border, assuming image size is defined as 48x48
        self.avatarView.layer.cornerRadius = 24.0 //self.avatarView.bounds.width/2.0
        self.avatarView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        self.avatarView.layer.borderWidth = 1.0
        self.avatarView.layer.masksToBounds = true
    }
    
    func updateDateLabel() {
        if let date = tweet?.date {
            self.dateTimeLabel.text = DateFormatter.localizedString(from: date,
                                                                    dateStyle: DateFormatter.Style.medium,
                                                                    timeStyle: DateFormatter.Style.medium)
        }
        else {
            self.dateTimeLabel.text = nil
        }
    }
    
    func updateContentLabel() {
        if let contentString = tweet?.content {
            //search for hyperlinks using a data detector.  to make this clickable we'll need to override UILabel or use an UITextView, which is a little heavy
            let linkDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue )
            let attrString : NSMutableAttributedString = NSMutableAttributedString(string: contentString)

            let urlMatches = linkDetector.matches(in: contentString, options: [], range: NSMakeRange(0, contentString.characters.count))
            for match in urlMatches {
                attrString.addAttributes([NSForegroundColorAttributeName: UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 1)],
                                        range: match.range)
            }

            //search for twitter @usernames using regex, twitter usernames are capped at 15 chars.
            let atMentionPattern = "(^|[^@\\w])@(\\w{1,15})\\b"
            let regEx = try! NSRegularExpression(pattern: atMentionPattern, options: [])
            let atMentionMatches = regEx.matches(in: contentString, options: [], range: NSMakeRange(0, contentString.characters.count))
            for match in atMentionMatches {
                attrString.addAttributes([NSForegroundColorAttributeName: UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 1)],
                                         range: match.range)
            }
            
            self.contentLabel.attributedText = attrString
        }
        else {
            self.contentLabel.text = nil
        }
    }
    
    // MARK: simple animations
    func animateDisplay() {
        self.replyToLabel.alpha = 0.1
        self.authorLabel.alpha = 0.1
        self.dateTimeLabel.alpha = 0.1
        self.avatarView.alpha = 0.1
        self.contentLabel.alpha = 0.1
        self.avatarView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25, animations: {
            self.replyToLabel.alpha = 1
            self.authorLabel.alpha = 1
            self.dateTimeLabel.alpha = 1
            self.avatarView.alpha = 1
            self.contentLabel.alpha = 1
            self.avatarView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
}
