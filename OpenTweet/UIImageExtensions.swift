//
//  UIImageExtensions.swift
//  OpenTweet
//
//  Created by Kai Yu on 10/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit


public extension UIImage {

    // MARK: static singleton cache for remote images
    private static var _cache: NSCache<AnyObject, AnyObject>! {
        struct StaticCache {
            static var singleton: NSCache<AnyObject, AnyObject>? = NSCache()
        }
        
        return StaticCache.singleton!
    }
    
    // MARK: Image From URL
    class func image(fromURL url: String, placeholder: UIImage, closure: @escaping (_ image: UIImage?, _ url: String) -> ()) -> UIImage? {
        //Check the cache first
        if let cachedImage = _cache.object(forKey: url as AnyObject) as? UIImage {
            closure(nil, url)
            return cachedImage
        }
        
        // Fetch Image
        let session = URLSession(configuration: URLSessionConfiguration.default)
        if let urlObject = URL(string: url) {
            session.dataTask(with: urlObject, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    DispatchQueue.main.async {
                        closure(nil, url)
                    }
                }
                if let data = data, let image = UIImage(data: data) {
                    _cache.setObject(image, forKey: url as AnyObject)
                    DispatchQueue.main.async {
                        closure(image, url)
                    }
                }
                session.finishTasksAndInvalidate()
            }).resume()
        }
        return placeholder
    }
    
    class func image(fromView view: UIView) -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIImage(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
        return image
    }
    
    class func image(withColor color: UIColor, opaque: Bool, size: CGSize) -> UIImage! {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.isOpaque = opaque
        view.backgroundColor = color
        
        return self.image(fromView: view)
    }
    
}

var urlHandle: Int = 0

public extension UIImageView {
    
    func setImage(fromURL url: String?, placeholder: UIImage) {
        objc_setAssociatedObject(self, &urlHandle, url, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if (url==nil) {
            self.image = placeholder
        }
        else {
            self.image = UIImage.image(fromURL: url!, placeholder: placeholder, closure: { (remoteImage, forUrl) -> Void in
                if (remoteImage != nil && url==(objc_getAssociatedObject(self, &urlHandle) as? String)) {
                    self.image = remoteImage
                }
            })
        }
    }
    
}

