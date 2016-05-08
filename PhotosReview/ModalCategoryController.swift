//
//  ModalCategoryViewController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import CoreData

class ModalCategoryController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    
    let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    let group:dispatch_group_t = dispatch_group_create();
    let semaphore:dispatch_semaphore_t = dispatch_semaphore_create(1)
    
    var categoryId:NSNumber = 0
    var categoryName:String = ""
    var categoryTemplate:String = ""
    var categories:[ICategory] = [ICategory]()
    
    @IBAction func categorySelectTouchesDown(sender: CategorySelectButton) {
        sender.selected = !sender.keepingButtonSelected
    }
    @IBAction func categorySelectTouchesUpInside(sender: CategorySelectButton) {
        
//        dispatch_async(queue) { () -> Void in
//            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            for subview in self.categoryColletionView.subviews {
                if subview.isKindOfClass(UICollectionViewCell){
                    let cell = subview as! UICollectionViewCell
                    let button = cell.contentView.viewWithTag(1) as! CategorySelectButton
                    button.selected = false
                }
            }
            sender.selected = !sender.keepingButtonSelected
            sender.keepingButtonSelected = sender.selected
            self.categoryId = sender.categoryId!
            self.categoryName = sender.categoryName!
//            dispatch_semaphore_signal(self.semaphore)
//        }
    }
    @IBAction func categorySelectTouchesUpOutside(sender: CategorySelectButton) {
        sender.selected = sender.keepingButtonSelected
    }
    
    @IBOutlet weak var categoryColletionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let photosReview = PhotosReviewAdaptor()
        categories = photosReview.loadCategory()
        self.categoryColletionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let categoryCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCell", forIndexPath: indexPath)
        
        // Tag番号を使ってbuttonのインスタンス生成
        let button = categoryCell.contentView.viewWithTag(1) as! CategorySelectButton
        button.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping // 複数行で表示
        button.titleLabel!.numberOfLines = 0 // 行数指定なし
        
        if (categories.count > indexPath.row){
            button.setTitle(categories[indexPath.row].categoryName!, forState: .Normal)
            
            button.categoryId = categories[indexPath.row].categoryId
            button.categoryName = categories[indexPath.row].categoryName
            if let categoryTemplate = categories[indexPath.row].categoryTemplate {
                button.categoryTemplate = categoryTemplate
            }
            button.setTitle(button.categoryName, forState: .Normal)
        }
        else{
            button.categoryId = 0
            button.categoryName = ""
            button.categoryTemplate = ""
            button.setTitle("", forState: .Normal)
        }
        return categoryCell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let width = (collectionView.frame.size.width-10)/3
        let height = (collectionView.frame.size.height-10)/5
        
        return CGSize(width: width, height: height)
    }
    
    //section 数の設定、今回は１つにセット
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return 15;
    }
    
    @IBAction func backFromCategoryEditor(segue:UIStoryboardSegue){
        
    }
    
    
}
