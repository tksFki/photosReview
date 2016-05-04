//
//  ReviewController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/02.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

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
    @IBOutlet weak var reviewName: UITextField! // レビュー名
    @IBOutlet weak var estimation: UITextField! // 評価
    @IBOutlet weak var CategoryName: CategoryButton! // カテゴリ名
    @IBOutlet weak var selectedPhoto: UIImageView! // 写真
    
    // 保存する
    @IBAction func saveReview(sender: UIButton) {
        
        let review = IReview()
        let photosReview = PhotosReviewAdaptor()
        
        // レビュー情報
        review.reviewName = self.reviewName.text
        review.categoryId = self.categoryID
        review.estimation = NSNumber(int: Int32(self.estimation.text!)!)
        if let photoData = originalImage {
            review.photoData = UIImagePNGRepresentation(photoData)
            review.photoOrientation = photoData.imageOrientation.hashValue
            review.photoWidth = photoData.size.width
            review.photoHeight = photoData.size.height
        }
        review.comment = self.comments.text

        photosReview.entryReview(review)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // シングルタップジェスチャーを写真窓（selectedPhoto）に登録
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(ReviewController.tappedSingle(_:)))
        singleFingerTap.delegate = self
        self.selectedPhoto.addGestureRecognizer(singleFingerTap)
        self.selectedPhoto.userInteractionEnabled = true
        
        // 写真窓の設定
        selectedPhoto.layer.borderColor = UIColor.redColor().CGColor
        selectedPhoto.layer.borderWidth = 2.0
        
        // コメントの設定
        comments.layer.borderWidth = 1
        comments.layer.borderColor = UIColor.blackColor().CGColor
        comments.layer.cornerRadius = 8
        
        // キーボードの設定
        // textField の情報を受け取るための delegate を設定
        self.reviewName.delegate = self
        self.estimation.delegate = self
        
        // 「改行」を「完了」に変更
        self.reviewName.returnKeyType = UIReturnKeyType.Done
        self.estimation.returnKeyType = UIReturnKeyType.Done
        
        // キーボードの上に表示するバーのインスタンス作成（ボタンを追加するためのViewを生成します。）
        let myKeyboard = UIView(frame: CGRectMake(0, 0, 320, 40))
        myKeyboard.backgroundColor = UIColor.whiteColor()
        
        // キーボードに完了ボタンを生成
        let myButton = UIButton(frame: CGRectMake(260, 5, 55, 30))
        myButton.setTitle("完了", forState: .Normal)
        myButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        myButton.backgroundColor = UIColor.whiteColor()
        myButton.layer.cornerRadius = 2.0
        myButton.addTarget(self, action: #selector(ReviewController.onClickMyButton(_:)), forControlEvents: .TouchUpInside)
        
        // キーボードViewに完了ボタンを追加する。
        myKeyboard.addSubview(myButton)
        
        //ViewをFieldに設定する
        self.comments.inputAccessoryView = myKeyboard
        self.comments.delegate = self
        
        //myTextFieldを追加する
        self.view.addSubview(comments)
    }
    
    // キーボードをリターンで閉じた時の動作
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        // reviewName.text = textField.text
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    //ボタンを押すとキーボードが下がるメソッド
    func onClickMyButton (sender: UIButton) {
        self.view.endEditing(true)
    }
    //改行押すとキーボードが下がるメソッド
    func textViewReturn(textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let imageViewPoint = CGPoint(x: self.selectedPhoto.frame.origin.x, y: self.selectedPhoto.frame.origin.y)
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
    
    @IBAction func backFromModalCategoryView(segue:UIStoryboardSegue){
        let cg:ICategory = ICategory()
        if let vc = segue.sourceViewController as? ModalCategoryViewController{
            cg.categoryId = vc.categoryId
            cg.categoryName = vc.categoryName
        }
        self.CategoryName.setTitle(cg.categoryName, forState: .Normal)
        self.categoryID = cg.categoryId!
    }
}


