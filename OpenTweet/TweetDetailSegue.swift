//
//  TweetDetailSegue.swift
//  OpenTweet
//
//  Created by Kai Yu on 10/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

//custim segue for the transition between timeline and thread.  the animation is to highlight and raise the tapped on tweet, then move it to it's proper location in the thread, on top of standard push transition
class TweetDetailSegue: UIStoryboardSegue {
    
    var tweet: Tweet?
    
    override func perform() {
        let timelineVC = self.source as! TimelineViewController
        let threadVC = self.destination as! ThreadViewController
        
        let sourceIndex = timelineVC.tweets.index(of: self.tweet!)!
        let destIndex = threadVC.tweetOrdered.index(of: self.tweet!)!
        
        let parentView = (timelineVC.navigationController?.view)!
        
        let sourceFrame = parentView.convert(
            timelineVC.tableView.rectForRow(at: IndexPath(row:sourceIndex, section:0)),
            from:timelineVC.tableView)
        
        //grab the cell that was just selected for transition, then make an overlay image for the transition
        let cell = timelineVC.tableView.cellForRow(at: IndexPath(row:sourceIndex, section:0))!
        let transitionImageView = UIImageView(image: UIImage.image(fromView: cell))
        
        transitionImageView.frame = sourceFrame
        parentView.addSubview(transitionImageView)
        
        
        UIView.animate(withDuration: 0.2, animations: {
            //step 1 in the animation is to make the overlay image bigger
            transitionImageView.layer.transform = CATransform3DMakeScale(1.15, 1.15, 1)
            }, completion: {
                (finished) in
                
                //grab the toplayout guide length before transition.  the guide won't be properly set on the pushed controller until after the transition, this affects transluscent navbars as in this case
                let topLayoutGuideLength = timelineVC.topLayoutGuide.length
                
                CATransaction.begin()
                //push the view controller, use regular push animation
                timelineVC.navigationController?.pushViewController(threadVC, animated: true)
                
                //these next 2 are required to force the tableview to layout and auto size all cells
                threadVC.tableView.reloadData()
                threadVC.tableView.layoutIfNeeded()
                
                //WORKAROUND: the new tableView doesn't yet have topLayoutGuide set yet, so the rectForRow returned is not properly offset.  adding topLayoutGuideLength retrieved prior to pushing
                let destFrame = parentView.convert(
                    threadVC.tableView.rectForRow(at: IndexPath(row:destIndex, section:0)),
                    from:threadVC.tableView)
                let destCenter = CGPoint(x: destFrame.midX, y: destFrame.midY + topLayoutGuideLength)
                
                UIView.animate(withDuration: 0.35, animations: {
                    //move the overlay image to go over the new location for this tweet in the threadViewController
                    transitionImageView.center = destCenter
                })
                
                //this completion block happens when the regular push transition completes
                CATransaction.setCompletionBlock({
                    UIView.animate(withDuration: 0.2, animations: {
                        //scale the overlay image back down
                        transitionImageView.layer.transform = CATransform3DMakeScale(1, 1, 1)
                        }, completion: {
                            (finished) in
                            //clean up, first fade out the overlay image, then remove it when done
                            UIView.animate(withDuration: 0.2, animations: {
                                transitionImageView.alpha = 0
                                }, completion: {
                                    (finished) in
                                    transitionImageView.removeFromSuperview()
                            })
                    })
                })
                CATransaction.commit()
                
        })
        
    }
    
}
