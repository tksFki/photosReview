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
    var photoMetaData:NSMutableDictionary?
    
    /*************** コントロール ***************/
    @IBOutlet weak var reviewName: UITextField! // レビュー名
    @IBOutlet weak var estimation: UITextField! // 評価
    @IBOutlet weak var categoryName: UITextField! // カテゴリ
    
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
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
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
        if let image = self.selectedPhoto.image {
            if let photoData = UIImagePNGRepresentation(image) {
//                photoData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                reviewItem.setValue(photoData, forKey: "photoData")
            }
        }
        let exif = photoMetaData?.objectForKey("kCGImagePropertyExifDictionary")
        print(exif)
        
        
        //4
        do {
            try managedContext.save()
            self.reviewItems.append(reviewItem)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    // レビューエンティティ読み出し（サンプル）
    @IBAction func loadReview(sender: UIButton) {
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Review")
        
        /* Get result array from ManagedObjectContext */
        do{
            let fetchResults = try manageContext.executeFetchRequest(fetchRequest)
            
            if let results: Array = fetchResults {
                for obj:AnyObject in results {
                    let reviewNo:NSNumber? = obj.valueForKey("reviewNo") as? NSNumber
                    let reviewName:String? = obj.valueForKey("reviewName") as? String
                    let categoryId:NSNumber? = obj.valueForKey("categoryId") as? NSNumber
                    let estimation:NSNumber? = obj.valueForKey("estimation") as? NSNumber
                    let photoData:NSData? = obj.valueForKey("photoData") as? NSData
                    print(reviewNo!)
                    print(reviewName!)
                    print(categoryId!)
                    print(estimation!)
                    self.selectedPhoto.image = photoData.flatMap(UIImage.init)
                }
                print("recordCounts:" + results.count.description)
            }
        }catch let error as NSError{
            fatalError("\(error)")
        }
        
    }
    
    // 削除
    @IBAction func deleteReview(sender: UIButton) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Review",
            inManagedObjectContext:managedContext)
        
        do
        {
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entity;
            // NSPredicate SQLのWhere句のようなイメージ
            let predicate = NSPredicate(format: "%K = %@", "reviewNo", "99")
            fetchRequest.predicate = predicate
            
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for result in results {
                let model = result as! Review
                //
                // レコード削除！
                //
                managedContext.deleteObject(model)
            }
            
        }catch let error as NSError {
            fatalError("\(error)")
        }
        
        // 作成したオブジェクトを保存
        appDelegate.saveContext()
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
        self.categoryName.delegate = self
        self.estimation.delegate = self
        
        // 「改行」を「完了」に変更
        self.reviewName.returnKeyType = UIReturnKeyType.Done
        self.categoryName.returnKeyType = UIReturnKeyType.Done
        self.categoryName.returnKeyType = UIReturnKeyType.Done
    }
    
    // キーボードをリターンで閉じた時の動作
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        // reviewName.text = textField.text
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
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
        
        let width: CGFloat = 120
        let height: CGFloat = 180
        
        // 元のサイズのままフォトライブラリに書き込み
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        photoMetaData = info[UIImagePickerControllerMediaMetadata] as? NSMutableDictionary
        
        // 画面に表示するサイズにリサイズする。
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), false, 0.0)
        image.drawInRect(CGRectMake(0, 0, width, height))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.selectedPhoto.image = resizeImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
}


