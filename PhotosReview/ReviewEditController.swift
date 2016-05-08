//
//  ReviewEditController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/04.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import AVFoundation



class ReviewEditController: UIViewController, PopUpPickerViewDelegate, UITextFieldDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
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
    
    var originalImage:UIImage?
    var innerframe:CGRect?
    
    var dts = DateToString()
    var std = StringToDate()
    
    @IBOutlet weak var reviewName: UITextField!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var createDate: DatePickerTextField!
    @IBOutlet weak var estimation: UITextField!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var reviewEditScrollView: UIScrollView!
    @IBOutlet weak var reviewEditView: UIView!
    
    // 更新する
    @IBAction func updateReview(sender: UIButton) {
        
        let review = IReview()
        let photosReview = PhotosReviewAdaptor()
        
        // レビュー情報
        review.reviewNo = paraReviewNo!
        review.reviewName = self.reviewName.text
        review.categoryId = self.selectedCategoryId!
        review.estimation = NSNumber(int: Int32(self.estimation.text!)!)
        if let photoData = originalImage {
            review.photoData = UIImagePNGRepresentation(photoData)
            review.photoOrientation = photoData.imageOrientation.hashValue
            review.photoWidth = photoData.size.width
            review.photoHeight = photoData.size.height
        }
        review.createDate = std.stringToDateRemovedWeekday(self.createDate.text!)
        review.comment = self.comment.text!
        
        photosReview.updateReview(review)
        
    }
    @IBOutlet weak var selectedPhoto: UIImageView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // スクロールビューのcontextSizeをビューのサイズに合わせる。
        self.reviewEditScrollView.contentSize = self.reviewEditView.bounds.size
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /********* テキストフィールド *********/
        self.reviewName.text = paraReviewName!
        self.estimation.text = paraEstimation!.stringValue
        self.comment.text = paraComment!
        
        comment.layer.borderWidth = 1
        comment.layer.borderColor = UIColor.blackColor().CGColor
        comment.layer.cornerRadius = 8
        
        // textField の情報を受け取るための delegate を設定
        self.reviewName.delegate = self
        self.estimation.delegate = self
        
        // 「改行」を「完了」に変更
        self.reviewName.returnKeyType = UIReturnKeyType.Done
        self.estimation.returnKeyType = UIReturnKeyType.Done
        
        // キーボードの上に表示するバーのインスタンス作成（ボタンを追加するためのViewを生成します。）
        let keyBar = UIView(frame: CGRectMake(0, 0, 320, 40))
        keyBar.backgroundColor = UIColor.whiteColor()
        
        // キーボードに完了ボタンを生成
        let keyButton = UIButton(frame: CGRectMake(260, 5, 55, 30))
        keyButton.setTitle("完了", forState: .Normal)
        keyButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        keyButton.backgroundColor = UIColor.whiteColor()
        keyButton.layer.cornerRadius = 2.0
        keyButton.addTarget(self, action: #selector(self.onTapCompleteButton(_:)), forControlEvents: .TouchUpInside)
        
        // キーボードViewに完了ボタンを追加する。
        keyBar.addSubview(keyButton)
        
        // キーボードViewをTextViewに設定する
        self.comment.inputAccessoryView = keyBar
        self.comment.delegate = self
        
        /********* ピッカーコントロール *********/
        let photosReview = PhotosReviewAdaptor()
        /*** カテゴリに値をセット ***/
        self.selectedCategoryId = paraCategoryId!
        self.selectedCategoryName = paraCategoryName!
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
        
        categoryName.inputView = categoryPickerView
        categoryPickerView.setDefaultSelectRow(selectedRow, inComponent: categoryComponentsNumber)
        
        /*** 作成日付に値をセット ***/
        self.selectedCreateDate = paraCreateDate!
        self.createDate.text = dts.dateToStringWithWeekday(paraCreateDate!)
        
        /********* 写真編集 *********/
        // シングルタップジェスチャーを写真窓（selectedPhoto）に登録
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(self.tappedSingle(_:)))
        singleFingerTap.delegate = self
        self.selectedPhoto.addGestureRecognizer(singleFingerTap)
        self.selectedPhoto.userInteractionEnabled = true
        
        if (paraPhotoImage != nil){
            self.selectedPhoto.image = paraPhotoImage
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // ピッカーで選択した値をテキストフィールドに表示
    func pickerViewComplete(pickerView: UIPickerView, didSelect numbers: [Int]) {
        categoryName.text = selectedCategoryName!
        self.categoryName.resignFirstResponder()
    }
    
    // ピッカーで完了を押した時の挙動
    func pickerViewCancel(pickerView: UIPickerView){
        self.categoryName.resignFirstResponder()
    }
    
    
    /********* テキストフィールド（ビュー）用関数 *********/
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
    
    /********* 写真編集用関数 *********/
    // 取り込み先に「カメラ」を選択
    func selectedCamera(){
        
        let camera = UIImagePickerControllerSourceType.Camera
        
        if UIImagePickerController.isSourceTypeAvailable(camera){
            
            let picker = UIImagePickerController()
            picker.sourceType = camera
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    // 取り込み先に「フォトライブラリ」を選択
    func selectedPhotoLibrary(){
        
        let photoLibrary = UIImagePickerControllerSourceType.PhotoLibrary
        
        if(UIImagePickerController.isSourceTypeAvailable(photoLibrary)){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = photoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    // 写真を保存した後に動く
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 元のサイズのままフォトライブラリに書き込み
        originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let image:UIImage = originalImage!
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        //        photoMetaData = info[UIImagePickerControllerMediaMetadata] as? NSMutableDictionary
        
        let contextWidth: CGFloat // コンテキスト幅
        let contextHeight: CGFloat // コンテキスト高さ
        // コンテキスト（描画領域）のサイズを設定
        innerframe = AVMakeRectWithAspectRatioInsideRect(originalImage!.size, selectedPhoto.bounds)
        contextWidth = innerframe!.size.width
        contextHeight = innerframe!.size.height
        let contextSize:CGSize = CGSizeMake(contextWidth,contextHeight)
        
        // コンテキストのインスタンスを作成
        UIGraphicsBeginImageContextWithOptions(contextSize, false, 0.0)
        let contextImg:CGContextRef? = UIGraphicsGetCurrentContext()
        CGContextSaveGState(contextImg)
        
        // 画像データをコンテキストに描画する
        image.drawInRect(CGRectMake(0, 0, contextSize.width, contextSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        self.selectedPhoto.image = resizeImage
        
        // コンテキストインスタンスの解放
        UIGraphicsEndImageContext()
        CGContextRestoreGState(contextImg)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tappedSingle(sender: UITapGestureRecognizer!) {
        // シングルタップしたときの処理
        let touchPoint:CGPoint = sender.locationInView(sender.view)
        if innerframe == nil {
            
            let imageViewPoint = CGPoint(x: self.selectedPhoto.bounds.origin.x, y: self.selectedPhoto.bounds.origin.y)
            let imageViewRect = CGRect(x: imageViewPoint.x, y: imageViewPoint.y, width: self.selectedPhoto.frame.width, height: self.selectedPhoto.frame.height)
            // タッチポイントが画像ビュー上の時
            if (CGRectContainsPoint(imageViewRect, touchPoint)){
                selectLibraryOrCamera()
            }
        }else
        {
            let imageRectOrigin = CGPoint(x: innerframe!.origin.x, y: innerframe!.origin.y)
            let imageRect = CGRect(x: imageRectOrigin.x, y: imageRectOrigin.y, width: innerframe!.size.width, height: innerframe!.size.height)
            // タッチポイントがレビュー画像上の時
            if (CGRectContainsPoint(imageRect, touchPoint)){
                selectLibraryOrCamera()
            }
        }
    }
    
    func selectLibraryOrCamera(){
        
        // 写真の取り込み先を選択する。（フォトライブラリ or カメラ）
        let alert:UIAlertController = UIAlertController(title:"写真を選択してください",
                                                        message: "Library or Camera",
                                                        preferredStyle: UIAlertControllerStyle.Alert)
        
        // キャンセル
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction!) -> Void in
        }
        // フォトライブラリを選択
        let fromPhotoLibraryAction:UIAlertAction = UIAlertAction(title: "フォトライブラリから選ぶ", style: UIAlertActionStyle.Destructive) { (action:UIAlertAction!) -> Void in
            self.selectedPhotoLibrary()
        }
        // カメラを選択
        let fromPictureAction:UIAlertAction = UIAlertAction(title: "カメラで写真を撮る", style: UIAlertActionStyle.Destructive) { (action:UIAlertAction!) -> Void in
            self.selectedCamera()
        }
        
        // アクションを追加
        alert.addAction(cancelAction)
        alert.addAction(fromPhotoLibraryAction)
        alert.addAction(fromPictureAction)
        
        // 選択ウィンドウを表示する。
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
}
