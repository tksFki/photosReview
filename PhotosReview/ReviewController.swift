//
//  ReviewController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/02.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import CoreData

class ReviewController: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    /*************** グローバル変数 ***************/
    
    // キーボードを開く前の表示位置を保持する
    var saveContentOffsetY: CGFloat?
    
    var reviewItems = [NSManagedObject]()
    var categoryID: NSNumber = 0
    var originalImage:UIImage?
    var photoMetaData:NSMutableDictionary?
    
    /*************** モーダルカテゴリビュー ***************/
    var modalTextStatic:String?
    
    /*************** コントロール ***************/
    @IBOutlet weak var reviewName: UITextField! // レビュー名
    @IBOutlet weak var estimation: UITextField! // 評価
    @IBOutlet weak var CategoryName: CategoryButton! // カテゴリ名
    @IBOutlet weak var selectedPhoto: UIImageView! // 写真
    @IBAction func selectPhoto(sender: UIButton) { // 写真タップ時の動作
        
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
    
    // 保存する
    @IBAction func saveReview(sender: UIButton) {
        
        let reviewNo:NSNumber = 5
        let categoryId:NSNumber = 5
        
        // エンティティ作成
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let reviewEntity =  NSEntityDescription.entityForName("Review",
                                                              inManagedObjectContext:managedContext)
        
        let reviewItem = NSManagedObject(entity: reviewEntity!,
                                         insertIntoManagedObjectContext: managedContext)
        
        
        /* レビューエンティティSave */
        // レビュー情報
        reviewItem.setValue(reviewNo, forKey: "reviewNo")
        reviewItem.setValue(self.reviewName.text, forKey: "reviewName")
        reviewItem.setValue(categoryID, forKey: "categoryId")
        var estValue :NSNumber = 0
        if Int32(self.estimation.text!) != nil {
            estValue = NSNumber(int: Int32(self.estimation.text!)!)
        }
        reviewItem.setValue(estValue, forKey: "estimation")
        reviewItem.setValue(categoryId, forKey: "categoryId")
        
        // 写真情報
        if let image = originalImage {
            let widthPer:CGFloat = 0.25  // リサイズ後幅の倍率
            let heightPer:CGFloat = 0.25  // リサイズ後高さの倍率
            let sz:CGSize = CGSizeMake(image.size.width * widthPer,image.size.height * heightPer)
            
            // 画面に表示するサイズにリサイズする。
            UIGraphicsBeginImageContextWithOptions(sz, false, 0.0)
            image.drawInRect(CGRectMake(0, 0, sz.width, sz.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let photoData = UIImagePNGRepresentation(resizeImage) {
                //                photoData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                reviewItem.setValue(photoData, forKey: "photoData")
            }
        }
        //        let exif = photoMetaData?.objectForKey("kCGImagePropertyExifDictionary")
        //        print(exif)
        
        //4
        do {
            try managedContext.save()
            self.reviewItems.append(reviewItem)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    @IBOutlet weak var comments: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        //ボタンを追加するためのViewを生成します。
        let myKeyboard = UIView(frame: CGRectMake(0, 0, 320, 40))
        myKeyboard.backgroundColor = UIColor.whiteColor()
        
        //完了ボタンの生成
        let myButton = UIButton(frame: CGRectMake(260, 5, 55, 30))
        myButton.setTitle("完了", forState: .Normal)
        myButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        myButton.backgroundColor = UIColor.whiteColor()
        myButton.layer.cornerRadius = 2.0
        myButton.addTarget(self, action: #selector(ReviewController.onClickMyButton(_:)), forControlEvents: .TouchUpInside)
        
        //Viewに完了ボタンを追加する。
        myKeyboard.addSubview(myButton)
        
        //ViewをFieldに設定する
        self.comments.inputAccessoryView = myKeyboard
        self.comments.delegate = self
        
        //myTextFieldを追加する
        self.view.addSubview(comments)
        
        //        // single swipe up
        //        let swipeLeftGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeLeft:")
        //        swipeLeftGesture.numberOfTouchesRequired = 1  // number of fingers
        //        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        //        self.view.addGestureRecognizer(swipeLeftGesture)
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
        
        photoMetaData = info[UIImagePickerControllerMediaMetadata] as? NSMutableDictionary
        
        let width:CGFloat = 120  // リサイズ後幅の倍率
        let height:CGFloat = 180  // リサイズ後高さの倍率
        let sz:CGSize = CGSizeMake(width,height)
        
        // 画面に表示するサイズにリサイズする。
        UIGraphicsBeginImageContextWithOptions(sz, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, sz.width, sz.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        self.selectedPhoto.image = resizeImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backFromModalCategoryView(segue:UIStoryboardSegue){
        let cg:ICategory = ICategory()
        if let vc = segue.sourceViewController as? ModalCategoryViewController{
            cg.categoryId = vc.categoryId
            cg.categoryName = vc.categoryName
            cg.categoryTemplate = vc.categoryTemplate
        }
        self.CategoryName.setTitle(cg.categoryName, forState: .Normal)
    }
}


