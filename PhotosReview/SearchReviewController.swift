//
//  SearchReviewController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/02.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class SearchReviewController: UIViewController {
    
    var reviews:[IReview] = [IReview]()
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    @IBOutlet weak var searchReviewCollectionView: UICollectionView!
    var selectedReviewNo: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("selectedReviewNo")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue!, forKey: "selectedReviewNo")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let photosReview = PhotosReviewAdaptor()
        reviews = photosReview.loadReview()
        self.searchReviewCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let reviewCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ReviewCell", forIndexPath: indexPath)
        
        // Tag番号を使ってbuttonのインスタンス生成
        let reviewImage = reviewCell.contentView.viewWithTag(1) as! photoReviewCell
        
        if reviews.count > indexPath.row {
            if let binPhotoData = reviews[indexPath.row].photoData{
                // リサイズしてサムネイルに格納
                // 1.コンテキスト作成
                let contextImg:CGContextRef? = UIGraphicsGetCurrentContext()
                CGContextSaveGState(contextImg)
                // 2.画像取り出し
                let sz:CGSize = CGSizeMake(width,height)
                UIGraphicsBeginImageContextWithOptions(sz, false, 0.0)
                // -- NSData → UIImage
                let uiPhotoDataTmp = UIImage(data: binPhotoData)
                let photoOrientationTmp = reviews[indexPath.row].photoOrientation
                let photoOrientation = photoOrientationTmp!.intValue.hashValue
                // -- 取り出した画像の回転を調整
                let uiPhotoData = UIImage(CGImage: uiPhotoDataTmp!.CGImage!, scale: 1.0, orientation: UIImageOrientation(rawValue: photoOrientation)!)
                // 3.画像をコンテキストに描画
                uiPhotoData.drawInRect(CGRectMake(0, 0, sz.width, sz.height))
                let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                // 4.コンテキストを解放
                UIGraphicsEndImageContext()
                CGContextRestoreGState(contextImg)
                
                // 画像の情報をセルに登録
                reviewImage.reviewNo = reviews[indexPath.row].reviewNo
                reviewImage.image = resizeImage
            }
        }
        return reviewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedReviewNo = reviews[indexPath.row].reviewNo
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        width = (collectionView.frame.size.width-20)/3
        height = (collectionView.frame.size.height-20)/5
        
        return CGSize(width: width, height: height)
    }
    
    //section 数の設定、今回は１つにセット
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return reviews.count;
    }
    
}
