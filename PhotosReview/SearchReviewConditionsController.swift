//
//  SearchReviewConditionsControllerViewController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/06.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class SearchReviewConditionsController: UIViewController,UITextFieldDelegate, PopUpPickerViewDelegate {
    
    var categoryPickerOption = [ICategory]()
    var categoryComponentsNumber:Int = 0
    var selectedCategoryId:NSNumber?
    var selectedCategoryName:String?
    var selectedCreateDate:NSDate?
    var toolBar:UIToolbar!
    var myDatePickerFrom: UIDatePicker!
    var myDatePickerTo: UIDatePicker!
    
    let std = StringToDate()
    let dts = DateToString()
    
    // 受け渡し用検索条件パラメータ
    var searchedReviewName: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("searchedReviewName")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: "searchedReviewName")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    var isContainsReviewComment: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("isContainsReviewComment")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: "isContainsReviewComment")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    var searchedCategoryId: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("searchedCategoryId")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: "searchedCategoryId")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    var searchedCreateDateFrom: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("searchedCreateDateFrom")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: "searchedCreateDateFrom")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    var searchedCreateDateTo: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("searchedCreateDateTo")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: "searchedCreateDateTo")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    @IBOutlet weak var reviewName: UITextField!
    @IBOutlet weak var containsReviewComment: UISwitch!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var reviewCreateDateFrom: UITextField!
    @IBOutlet weak var reviewCreateDateTo: UITextField!
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func decide(sender: UIBarButtonItem) {

        // 検索条件セット
        if self.reviewName.text != "" {
            self.searchedReviewName = self.reviewName.text
        }
        
        self.isContainsReviewComment = self.containsReviewComment.on
        
        if let nsn = self.selectedCategoryId {
            self.searchedCategoryId = nsn
        }
        if self.reviewCreateDateFrom.text != "" {
            self.searchedCreateDateFrom = std.stringToDateRemovedWeekday(self.reviewCreateDateFrom.text!)
        }
        if self.reviewCreateDateTo.text != "" {
            self.searchedCreateDateFrom = std.stringToDateRemovedWeekday(self.reviewCreateDateTo.text!)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let str = self.searchedReviewName{
            self.reviewName.text = str as? String
        }
        
        // textField の情報を受け取るための delegate を設定
        self.reviewName.delegate = self
        // 「改行」を「完了」に変更
        self.reviewName.returnKeyType = UIReturnKeyType.Done
        
        /********* ピッカーコントロール *********/
        let photosReview = PhotosReviewAdaptor()
        
        /*** カテゴリに値をセット ***/
        let categories = photosReview.loadCategory()
        for category in categories {
            // カテゴリピッカー作成
            categoryPickerOption.append(category)
            if let num = self.searchedCategoryId{
                if category.categoryId == num as? NSNumber {
                    self.categoryName.text = category.categoryName!
                }
            }
        }
        let categoryPickerView = PopUpPickerView()
        categoryPickerView.delegate = self
        categoryPickerView.tag = PickerIdentifier.CategoryName.hashValue
        categoryName.inputView = categoryPickerView
        
        /*** 作成日付に値をセット ***/
        if let nsd = self.searchedCreateDateFrom {
            self.reviewCreateDateFrom.text = dts.dateToStringWithWeekday(nsd as! NSDate)
        }
        if let nsd = self.searchedCreateDateTo {
            self.reviewCreateDateTo.text = dts.dateToStringWithWeekday(nsd as! NSDate)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // キーボードをリターンで閉じた時の動作
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    // 完了ボタンを押すとキーボードが下がるメソッド
    func onTapCompleteButton (sender: UIButton) {
        self.view.endEditing(true)
    }
    
    /********* ピッカー用関数 *********/
    // ピッカー列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        //ピッカーの列数
        var componentsNumber:Int = 1
        componentsNumber = 1
        return componentsNumber
    }
    // ピッカーの要素数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // ピッカーの行数
        var rowsNumber:Int = 1
        rowsNumber = categoryPickerOption.count
        return rowsNumber
    }
    // ピッカーに値をセット
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        // ピッカー表示値
        var picValue:String = "データなし"
        picValue = categoryPickerOption[row].categoryName!
        
        return picValue
    }
    // ピッカーで選択した時の挙動
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategoryName = categoryPickerOption[row].categoryName!
        selectedCategoryId = categoryPickerOption[row].categoryId!
    }
    
    // ピッカーで完了を押した時の挙動
    func pickerViewComplete(pickerView: UIPickerView, didSelect numbers: [Int]) {
        if let scn = selectedCategoryName {
            categoryName.text = scn
        }
        self.categoryName.resignFirstResponder()
        
    }
    
    // ピッカーでキャンセルを押した時の挙動
    func pickerViewCancel(pickerView: UIPickerView){
        self.categoryName.resignFirstResponder()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
