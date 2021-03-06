//
//  ReviewController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/04/02.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Cosmos

class ReviewController: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate {
    
    /*************** グローバル変数 ***************/
    
    // キーボードを開く前の表示位置を保持する
    var saveContentOffsetY: CGFloat?
    
    var reviewItems = [NSManagedObject]()
    var categoryID: NSNumber = 0
    var originalImage:UIImage?
    var photoMetaData:NSMutableDictionary?
    var innerframe:CGRect?
    
    /*************** モーダルカテゴリビュー ***************/
    var modalTextStatic:String?
    
    /*************** コントロール ***************/
    @IBOutlet weak var reviewScrollView: UIScrollView!
    @IBOutlet weak var reviewName: UITextField! // レビュー名
    @IBOutlet weak var estimation: CosmosView! // 評価
    @IBOutlet weak var CategoryName: CategoryButton! // カテゴリ名
    @IBOutlet weak var selectedPhoto: UIImageView! // 写真
    
    // 保存する
    @IBAction func saveReview(sender: UIButton) {
        
        // 登録前確認ダイアログ
        let alert:UIAlertController = UIAlertController(title:"レビューを登録しますか",
                                                        message: "Entry your review",
                                                        preferredStyle: UIAlertControllerStyle.Alert)
        
        // キャンセルを選択
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction!) -> Void in
        }
        // OKを選択
        let okAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
            self.entryReview()
        }
        // アクションを追加
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        // 選択ウィンドウを表示する。
        presentViewController(alert, animated: true, completion: nil)
        
//        if let image = originalImage {
//            let widthPer:CGFloat = 0.25  // リサイズ後幅の倍率
//            let heightPer:CGFloat = 0.25  // リサイズ後高さの倍率
//            let sz:CGSize = CGSizeMake(image.size.width * widthPer,image.size.height * heightPer)
//            
//            // 画面に表示するサイズにリサイズする。
//            UIGraphicsBeginImageContextWithOptions(sz, false, 0.0)
//            image.drawInRect(CGRectMake(0, 0, sz.width, sz.height))
//            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            if let photoData = UIImagePNGRepresentation(resizeImage) {
//                //                photoData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
//                reviewItem.setValue(photoData, forKey: "photoData")
//            }
//        }
//                let exif = photoMetaData?.objectForKey("kCGImagePropertyExifDictionary")
//                print(exif)
    }
    
    @IBOutlet weak var comments: UITextView!
    
    func entryReview() {
        
        let review = IReview()
        let photosReview = PhotosReviewAdaptor()
        
        // レビュー情報
        review.reviewName = self.reviewName.text
        review.categoryId = self.categoryID
        review.estimation = NSNumber(int: Int32(self.estimation.rating))
        if let photoData = originalImage {
            review.photoData = UIImagePNGRepresentation(photoData)
            review.photoOrientation = photoData.imageOrientation.hashValue
            review.photoWidth = photoData.size.width
            review.photoHeight = photoData.size.height
        }
        review.comment = self.comments.text
        
        photosReview.entryReview(review)
        
        // 登録後確認ダイアログ
        let alert:UIAlertController = UIAlertController(title:"レビューの登録を完了しました！",
                                                        message: "Entried Success!!",
                                                        preferredStyle: UIAlertControllerStyle.Alert)
        
        // OKを選択
        let okAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
            self.reviewName.text = ""
            self.categoryID = 0
            self.CategoryName.setTitle("カテゴリ", forState: .Normal)
            self.estimation.rating = 0
            self.selectedPhoto.image = UIImage(named: "Noimage.gif")
            self.originalImage = nil
            self.comments.text = ""
            return
        }
        // アクションを追加
        alert.addAction(okAction)
        
        // 選択ウィンドウを表示する。
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // 画面表示前処理
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // キーボードとテキストビューの判定に使用
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardWillBeShown(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardWillBeHidden(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }
    
    // 画面終了前処理
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillShowNotification,
                                                            object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification,
                                                            object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // シングルタップジェスチャーを写真窓（selectedPhoto）に登録
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(ReviewController.tappedSingle(_:)))
        singleFingerTap.delegate = self
        self.selectedPhoto.addGestureRecognizer(singleFingerTap)
        self.selectedPhoto.userInteractionEnabled = true
        
        // コメントの設定
        self.comments.layer.borderWidth = 2.0
        self.comments.layer.borderColor = UIColor.orangeColor().CGColor
        self.comments.layer.cornerRadius = 8
        
        // キーボードの設定
        // textField の情報を受け取るための delegate を設定
        self.reviewName.delegate = self
        
        // 「改行」を「完了」に変更
        self.reviewName.returnKeyType = UIReturnKeyType.Done
        
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
        
        //ViewをTextFieldに設定する
        self.comments.inputAccessoryView = keyBar
        self.comments.delegate = self

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
    
    /************* 写真取り込み用関数 *************/
    // 写真の取り込み先をフォトライブラリ、もしくはカメラから選択する。
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
    
    /********** テキストビューを表示した際のスクロール ***********/
    func keyboardWillBeShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue, animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                restoreScrollViewSize()
                
                let convertedKeyboardFrame = reviewScrollView.convertRect(keyboardFrame, fromView: nil)
                let mainBoundSize: CGSize = UIScreen.mainScreen().bounds.size
                let txtLimit = self.comments.frame.origin.y + self.comments.frame.height + 8.0
                let kbdLimit = mainBoundSize.height - convertedKeyboardFrame.size.height - 40.0
                
                let offsetY: CGFloat
                if txtLimit >= kbdLimit {
                    offsetY = txtLimit - kbdLimit
                }else{
                    return
                }
                updateScrollViewSize(offsetY, duration: animationDuration)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        restoreScrollViewSize()
    }
    
    func updateScrollViewSize(moveSize: CGFloat, duration: NSTimeInterval) {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
        reviewScrollView.contentInset = contentInsets
        reviewScrollView.scrollIndicatorInsets = contentInsets
        reviewScrollView.contentOffset = CGPointMake(0, moveSize)
        
        UIView.commitAnimations()
    }
    
    func restoreScrollViewSize() {
        reviewScrollView.contentInset = UIEdgeInsetsZero
        reviewScrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    
    @IBAction func backFromModalCategoryView(segue:UIStoryboardSegue){
        let cg:ICategory = ICategory()
        if let vc = segue.sourceViewController as? ModalCategoryController{
            cg.categoryId = vc.categoryId
            cg.categoryName = vc.categoryName
        }
        self.CategoryName.setTitle(cg.categoryName, forState: .Normal)
        self.categoryID = cg.categoryId!
    }
}


