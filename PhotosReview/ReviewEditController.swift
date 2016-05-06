//
//  ReviewEditController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/04.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

enum PickerIdentifier {
    case CategoryName
    case CreateDate
}

class ReviewEditController: UIViewController, PopUpPickerViewDelegate,UITextFieldDelegate {

    var paraReviewNo:NSNumber?
    var paraReviewName:String?
    var paraCategoryId:NSNumber?
    var paraCategoryName:String?
    var paraEstimation:NSNumber?
    var paraCreateDate:NSDate?
    var paraComment:String?
    var paraPhotoImage:UIImage?
    
    var categoryPickerOption = [ICategory]()
    var categoryComponentsNumber:Int = 0
    var selectedCategoryId:NSNumber?
    var selectedCategoryName:String?
    
    var selectedCreateDate:NSDate?
    
    var toolBar:UIToolbar!
    var myDatePicker: UIDatePicker!

    @IBOutlet weak var reviewName: UITextField!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var createDate: UITextField!
    @IBOutlet weak var estimation: UITextField!
    @IBOutlet weak var comment: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.reviewName.text = paraReviewName!
        self.estimation.text = paraEstimation!.stringValue
        self.comment.text = paraComment!
        
        let photosReview = PhotosReviewAdaptor()
        /*** カテゴリに値をセット ***/
        self.selectedCategoryId = paraCategoryId!
        self.categoryName.text = paraCategoryName!

        var selectedRow:Int = 0
        let categories = photosReview.loadCategory()
        for category in categories {
            // カテゴリピッカー作成
            categoryPickerOption.append(category)
            if category.categoryName == categoryName.text{
                selectedRow = categories.indexOf({$0 === category})!
            }
        }
        let categoryPickerView = PopUpPickerView()
        categoryPickerView.delegate = self
        categoryPickerView.tag = PickerIdentifier.CategoryName.hashValue
        
        /*** 作成日付に値をセット ***/
        self.selectedCreateDate = paraCreateDate!
        self.createDate.text = dateToString(paraCreateDate!)
        // UIDatePickerの設定
        myDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: #selector(self.changedDateEvent), forControlEvents: UIControlEvents.ValueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.Date
        createDate.inputView = myDatePicker
        
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: #selector(self.tappedToolBarBtn))
        let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .Plain, target: self, action: #selector(self.tappedToolBarBtnToday))
        
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn, toolBarBtnToday]
        
        createDate.inputAccessoryView = toolBar
        
        categoryName.inputView = categoryPickerView
        categoryPickerView.setDefaultSelectRow(selectedRow, inComponent: categoryComponentsNumber)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ピッカー列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        //ピッカーの列数
        var componentsNumber:Int = 1
        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
            componentsNumber = 1
        }else if(categoryName.tag == PickerIdentifier.CreateDate.hashValue){
            componentsNumber = 1
        }
        return componentsNumber
    }
    // ピッカーの要素数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // ピッカーの行数
        var rowsNumber:Int = 1
        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
            rowsNumber = categoryPickerOption.count
        }else if(categoryName.tag == PickerIdentifier.CreateDate.hashValue){
            rowsNumber = 1
        }
        return rowsNumber
    }
    // ピッカーに値をセット
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        // ピッカー表示値
        var picValue:String = "データなし"
        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
            picValue = categoryPickerOption[row].categoryName!
        }else if(categoryName.tag == PickerIdentifier.CreateDate.hashValue){
            picValue = "うんこ"
        }
        return picValue
    }
    // ピッカーで選択した時の挙動
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
            selectedCategoryName = categoryPickerOption[row].categoryName!
            selectedCategoryId = categoryPickerOption[row].categoryId!
        }else if(categoryName.tag == PickerIdentifier.CreateDate.hashValue){
            
        }
        
    }
    // ピッカーで選択した値をテキストフィールドに表示
    func pickerViewComplete(pickerView: UIPickerView, didSelect numbers: [Int]) {
        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
            categoryName.text = selectedCategoryName!
            self.categoryName.resignFirstResponder()
        }else if(categoryName.tag == PickerIdentifier.CreateDate.hashValue){
            
        }
    }
    
    // ピッカーで完了を押した時の挙動
    func pickerViewCancel(pickerView: UIPickerView){
        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
            self.categoryName.resignFirstResponder()
        }else if(categoryName.tag == PickerIdentifier.CreateDate.hashValue){
            
        }
    }

    
    
    // 「完了」を押すと閉じる
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        createDate.text = self.dateToString(selectedCreateDate!)
        createDate.resignFirstResponder()
    }
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        myDatePicker.date = NSDate()
        changeLabelDate(NSDate())
    }
    func changedDateEvent(sender:AnyObject?){
//        let dateSelecter: UIDatePicker = sender as! UIDatePicker
        self.changeLabelDate(myDatePicker.date)
    }
    func changeLabelDate(date:NSDate) {
        selectedCreateDate = date
    }
    func dateToString(date:NSDate) ->String {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let comps: NSDateComponents = calender.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday], fromDate:date)
        
        let date_formatter: NSDateFormatter = NSDateFormatter()
        var weekdays: Array  = ["日", "月", "火", "水", "木", "金", "土"]
        
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm（\(weekdays[comps.weekday-1])） "
        
        return date_formatter.stringFromDate(date)
    }
    
}
