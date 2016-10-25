//
//  NSRangeExtensions.swift
//  OpenTweet
//
//  Created by Kai Yu on 10/24/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation

extension NSRange {
    
    //just for converting NSRange to string range
    func range(forString str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}
