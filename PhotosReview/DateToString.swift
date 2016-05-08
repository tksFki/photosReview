//
//  dateToString.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/08.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import Foundation

class DateToString {
    
    func dateToStringWithWeekday(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let comps: NSDateComponents = calender.components([.Year, .Month, .Day, .Hour, .Minute, .Weekday], fromDate:date)
        
        let date_formatter: NSDateFormatter = NSDateFormatter()
        var weekdays: Array  = ["日", "月", "火", "水", "木", "金", "土"]
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm（\(weekdays[comps.weekday-1])） "
        
        return date_formatter.stringFromDate(date)
    }
    
    
}