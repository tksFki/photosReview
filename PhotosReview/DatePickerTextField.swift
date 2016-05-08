//
//  DatePickerTextField.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/08.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class DatePickerTextField: UITextField {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    let dts = DateToString()
    
    let datePickerView = UIDatePicker()
    let dateFormatter = NSDateFormatter()
    
    let toolBar = UIToolbar()
    
    var selectedDate:NSDate?
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleFocused(_:)), name: UITextFieldTextDidBeginEditingNotification, object: nil)
    }
    
    func handleFocused(notification: NSNotification!) {
        
        datePickerView.datePickerMode = .DateAndTime
        datePickerView.addTarget(self, action: #selector(self.changedDateEvent), forControlEvents: UIControlEvents.ValueChanged)
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        //UITextField の inputView のプロパティに UIDatePicker を設定
        self.inputView = datePickerView
        
        // UIToolbar の設定
        toolBar.frame = CGRectMake(0, self.frame.size.height/6, self.frame.size.width, 40.0)
        toolBar.layer.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: #selector(self.tappedToolBarBtn(_:)))
        let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .Plain, target: self, action: #selector(self.tappedToolBarBtnToday(_:)))
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn, toolBarBtnToday]
        
        // UITextField の inputAccessoryView のプロパティに UIToolbar を設定
        self.inputAccessoryView = toolBar
    }
        
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        if selectedDate != nil{
            self.text = dts.dateToStringWithWeekday(selectedDate!)
        }
        super.resignFirstResponder()
    }
    
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        datePickerView.date = NSDate()
        setTempDate(NSDate())
    }
    
    func changedDateEvent(sender:AnyObject?){
        self.setTempDate(datePickerView.date)
    }
    
    func setTempDate(date:NSDate) {
        selectedDate = date
    }
    
    
    
}
