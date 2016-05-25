//
//  ReviewDetailController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/05/01.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import AVFoundation
import Cosmos

class ReviewDetailController: UIViewController,UIGestureRecognizerDelegate {
    
    var reviewNo:NSNumber = 0
    var review = IReview()
    var category = ICategory()
    var originalImage:UIImage?
    let photosReview = PhotosReviewAdaptor()
    var innerframe:CGRect?
    
    
    @IBOutlet weak var reviewDetailNavigation: UINavigationItem!
    @IBOutlet weak var reviewDetailScrollView: UIScrollView!
    @IBOutlet weak var reviewDetailView: UIView!
    @IBOutlet weak var reviewTitle: ReviewLabel!
    @IBOutlet weak var reviewDetailPhotoImage: UIImageView!
    @IBOutlet weak var categoryName: ReviewLabel!
    @IBOutlet weak var estimation: CosmosView!
    @IBOutlet weak var comment: ReviewLabel!
    @IBAction func deleteReview(sender: UIBarButtonItem) {
        
        // レビュー削除　確認ダイアログ
        let alert:UIAlertController = UIAlertController(title: "このレビューを削除しますか", message: "Do you delete this review ?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
        }
        let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            // レビューの削除
            self.deleteReviewWithReviewNo(self.reviewNo)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        // 選択ウィンドウを表示する。
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteReviewWithReviewNo(reviewNo: NSNumber){
        
        self.photosReview.deleteReview(reviewNo)
        
        // レビュー削除　確認ダイアログ
        let alert:UIAlertController = UIAlertController(title: "削除しました", message: "Delete Completed!", preferredStyle: UIAlertControllerStyle.Alert)
        let ok:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(ok)
        
        // 選択ウィンドウを表示する。
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // スクロールビューのcontextSizeをビューのサイズに合わせる。
        self.reviewDetailScrollView.contentSize = self.reviewDetailView.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewNo = self.selectedReviewNo! as! NSNumber
        review = photosReview.loadReviewWithReviewNo(reviewNo)
        category = photosReview.loadCategoryWithCategoryId(review.categoryId!)
        
        reviewTitle.text = review.reviewName!
        if let tmpCategoryName = category.categoryName {
            categoryName.text = tmpCategoryName
            // CoreDataにcategoryIdに該当するcategoryNameが存在しなかった場合
        }else{
            categoryName.text = "カテゴリなし"
        }
        
        // 評価レート
        estimation.rating = Double(review.estimation!)
        estimation.userInteractionEnabled = false
        
        if let photoData = review.photoData {
            
            let contextWidth: CGFloat
            let contextHeight: CGFloat
            let originalImageSize = CGSizeMake(CGFloat(review.photoWidth!), CGFloat(review.photoHeight!))
            
            // リサイズ後の画像の座標取得
            innerframe = AVMakeRectWithAspectRatioInsideRect(originalImageSize, reviewDetailPhotoImage.bounds)
            contextWidth = innerframe!.size.width
            contextHeight = innerframe!.size.height
            let contextSize:CGSize = CGSizeMake(contextWidth,contextHeight)
            
            // コンテキスト描画
            UIGraphicsBeginImageContext(contextSize)
            let contextImg:CGContextRef? = UIGraphicsGetCurrentContext()
            CGContextSaveGState(contextImg)
            
            let uiPhotoDataTmp = UIImage(data: photoData)
            let uiPhotoData = UIImage(CGImage: uiPhotoDataTmp!.CGImage!, scale: 1.0, orientation: UIImageOrientation(rawValue: review.photoOrientation! .hashValue)!)
            originalImage = uiPhotoData
            uiPhotoData.drawInRect(CGRectMake(0, 0, contextSize.width, contextSize.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            reviewDetailPhotoImage.image = resizeImage
        }
        
        // レビュー内容は行数によって大きさを変える
        self.comment.text = review.comment!
        self.comment.numberOfLines = 0
        self.comment.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.comment.sizeToFit()
        //        var rect:CGRect  = comment.frame
        //        rect.size.height = CGRectGetHeight(comment.frame)
        //        self.comment.frame = rect
        //        if rect.size.height <= 200{ // ラベルサイズが200に満たない場合は、一律高さを200にする。
        //            rect.size.height = 200
        //        } // -> 正しく動かないので、方法を模索
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedReviewNo: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("selectedReviewNo")
        }
    }
    
    // 画面遷移時のパラメータ受け渡し
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToReviewEdit"{
            let vc = segue.destinationViewController as! ReviewEditController
            vc.paraReviewNo = review.reviewNo!
            vc.paraReviewName = review.reviewName!
            vc.paraEstimation = review.estimation!
            vc.paraCreateDate = review.createDate!
            vc.paraComment = review.comment!
            if originalImage != nil{
                vc.paraPhotoImage = originalImage!
            }
            if let tmpCategoryName = category.categoryName{
                vc.paraCategoryId = category.categoryId!
                vc.paraCategoryName = tmpCategoryName
            }else{
                vc.paraCategoryId = 0
                vc.paraCategoryName = self.categoryName.text!
            }
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
