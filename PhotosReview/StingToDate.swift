//
//  stingToDate.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/08.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import Foundation

class StringToDate {
    
    func stringToDateRemovedWeekday(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let removeIndex = string.startIndex.advancedBy(string.characters.count-4)
        let stringAfterRemoved = string.substringToIndex(removeIndex)
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        return dateFormatter.dateFromString(stringAfterRemoved)!
    }
    
    
}