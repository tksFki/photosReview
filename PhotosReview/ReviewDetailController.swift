//
//  ReviewDetailController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/05/01.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import AVFoundation

class ReviewDetailController: UIViewController,UIGestureRecognizerDelegate {
    
    var reviewNo:NSNumber = 0
    var review = IReview()
    var category = ICategory()
    let photosReview = PhotosReviewAdaptor()
    var innerframe:CGRect?
    
    
    @IBOutlet weak var reviewDetailScrollView: UIScrollView!
    @IBOutlet weak var reviewDetailView: UIView!
    @IBOutlet weak var reviewTitle: ReviewLabel!
    @IBOutlet weak var reviewDetailPhotoImage: UIImageView!
    @IBOutlet weak var categoryName: ReviewLabel!
    @IBOutlet weak var estimation: ReviewLabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // スクロールビューのcontextSizeをビューのサイズに合わせる。
        self.reviewDetailScrollView.contentSize = self.reviewDetailView.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(ReviewDetailController.tappedSingle(_:)))
        singleFingerTap.delegate = self
        self.reviewDetailPhotoImage.addGestureRecognizer(singleFingerTap)
        self.reviewDetailPhotoImage.userInteractionEnabled = true
        
        reviewNo = self.selectedReviewNo! as! NSNumber
        review = photosReview.loadReviewWithReviewNo(reviewNo)
        category = photosReview.loadCategoryWithCategoryId(review.categoryId!)
        
        reviewTitle.text = review.reviewName!
        categoryName.text = category.categoryName!
        estimation.text = review.estimation!.stringValue
        
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
            uiPhotoData.drawInRect(CGRectMake(0, 0, contextSize.width, contextSize.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            reviewDetailPhotoImage.image = resizeImage
            
            print("Aspect Fit originX \(innerframe?.origin.x)")
            print("Aspect Fit originY \(innerframe?.origin.y)")
            print("Aspect Fit width \(innerframe?.size.width)")
            print("Aspect Fit height \(innerframe?.size.height)")
            print("UIImageView frame X \(reviewDetailPhotoImage.frame.origin.x)")
            print("UIImageView frame Y \(reviewDetailPhotoImage.frame.origin.y)")
            
        }
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
    
    func tappedSingle(sender: UITapGestureRecognizer!) {
        // シングルタップしたときの処理
        let touchPoint:CGPoint = sender.locationInView(sender.view)
        let imageRectOrigin = CGPoint(x: innerframe!.origin.x, y: innerframe!.origin.y)
        let imageRect = CGRect(x: imageRectOrigin.x, y: imageRectOrigin.y, width: innerframe!.size.width, height: innerframe!.size.height)
        // タッチポイントがレビュー画像上の時
        if (CGRectContainsPoint(imageRect, touchPoint)){
            print("Touch OK")
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
