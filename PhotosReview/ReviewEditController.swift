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
    var paraComment:String?
    var paraPhotoImage:UIImage?
    
    var categoryPickerOption = [ICategory]()
    var pickerView: PopUpPickerView!
    var selectedCategoryId:NSNumber?
    var selectedCategoryName:String?

    @IBOutlet weak var reviewName: UITextField!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var estimation: UITextField!
    @IBOutlet weak var comment: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.reviewName.text = paraReviewName!
        self.estimation.text = paraEstimation!.stringValue
        self.comment.text = paraComment!
        
        // カテゴリに値をセット
        categoryName.tag = PickerIdentifier.CategoryName.hashValue
        self.selectedCategoryId = paraCategoryId!
        self.categoryName.text = paraCategoryName!

        let photosReview = PhotosReviewAdaptor()
        let categories = photosReview.loadCategory()
        for category in categories {
            // カテゴリピッカー作成
            categoryPickerOption.append(category)
        }
        let categoryPickerView = PopUpPickerView()
        categoryPickerView.delegate = self
        categoryPickerView.tag = PickerIdentifier.CategoryName.hashValue
        
        if let window = UIApplication.sharedApplication().keyWindow {
            window.addSubview(categoryPickerView)
        } else {
            self.view.addSubview(categoryPickerView)
        }
        
//        let button = UIButton(type: UIButtonType.ContactAdd)
//        button.frame = CGRectMake(50, 100, 30, 30);
//        button.addTarget(self, action: #selector(self.showPicker), forControlEvents: UIControlEvents.TouchDown)
//        self.view.addSubview(button)
        
        categoryName.inputView = categoryPickerView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        //非表示にする。
//        if(categoryName.isFirstResponder()){
//            categoryName.resignFirstResponder()
//        }
//        
//    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//
//        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
//            self.showPicker()
//        }
//        return false
//    }
//    
//    func showPicker() {
//        pickerView.showPicker()
//    }
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
        //ピッカーの列数
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
    
    func pickerViewCancel(pickerView: UIPickerView){
        if(categoryName.tag == PickerIdentifier.CategoryName.hashValue){
            self.categoryName.resignFirstResponder()
        }else if(categoryName.tag == PickerIdentifier.CreateDate.hashValue){
            
        }
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
