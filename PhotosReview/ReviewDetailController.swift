//
//  ReviewDetailController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/05/01.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class ReviewDetailController: UIViewController {
    
    var reviewNo:NSNumber = 0
    var review = IReview()
    var category = ICategory()
    let photosReview = PhotosReviewAdaptor()
    
    @IBOutlet weak var reviewTitle: ReviewLabel!
    @IBOutlet weak var reviewDetailPhotoImage: UIImageView!
    @IBOutlet weak var categoryName: ReviewLabel!
    @IBOutlet weak var estimation: ReviewLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewNo = self.selectedReviewNo! as! NSNumber
        review = photosReview.loadReviewWithReviewNo(reviewNo)
        category = photosReview.loadCategoryWithCategoryId(review.categoryId!)
        
        reviewTitle.text = review.reviewName!
        categoryName.text = category.categoryName!
        estimation.text = review.estimation!.stringValue
        
        if let photoData = review.photoData {
            
            let width:CGFloat = 320 // コンテキスト幅の倍率
            let height:CGFloat = 180  // コンテキスト高さの倍率
            let contextSize:CGSize = CGSizeMake(width,height)
            // コンテキスト描画
            UIGraphicsBeginImageContext(contextSize)
            let contextImg:CGContextRef? = UIGraphicsGetCurrentContext()
            CGContextSaveGState(contextImg)
            
            let uiPhotoDataTmp = UIImage(data: photoData)
            let uiPhotoData = UIImage(CGImage: uiPhotoDataTmp!.CGImage!, scale: 1.0, orientation: UIImageOrientation(rawValue: review.photoOrientation! .hashValue)!)
            uiPhotoData.drawInRect(CGRectMake(0, 0, contextSize.width, contextSize.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            reviewDetailPhotoImage.image = resizeImage
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
