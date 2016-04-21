//
//  ModalCategoryViewController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import CoreData

class ModalCategoryViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    
    var categoryId:NSNumber = 0
    var categoryName:String = "カテゴリなし"
    var categoryTemplate:String = ""
    var categories:[ICategory] = [ICategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        // dequeueReusableCellWithReuseIdentifier の働きは
        // 再利用できるセルがあればそれを使う
        // 再利用できるセルがなければ生成する
        // Cell はストーリーボードで設定したセルのID
        let testCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCell", forIndexPath: indexPath)
        
        // Tag番号を使ってbuttonのインスタンス生成
        let button = testCell.contentView.viewWithTag(1) as! CategorySelectButton
        
        if (categories.count > indexPath.row){
            button.setTitle(categories[indexPath.row].categoryName!, forState: .Normal)
            button.categoryId = categories[indexPath.row].categoryId!
            button.categoryName = categories[indexPath.row].categoryName!
            button.categoryTemplate = categories[indexPath.row].categoryTemplate!
        }
        return testCell
    }
    
    //section 数の設定、今回は１つにセット
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return 18;
    }
    
    // カテゴリエンティティ読み出し
    func loadCategory() {
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        /* Get result array from ManagedObjectContext */
        do{
            let fetchResults = try manageContext.executeFetchRequest(fetchRequest)
            
            if let results: Array = fetchResults {
                for obj:AnyObject in results {
                    let category:ICategory = ICategory()
                    category.categoryId = obj.valueForKey("categoryId") as? NSNumber
                    category.categoryName = obj.valueForKey("categoryName") as? String
                    category.categoryTemplate = obj.valueForKey("categoryTemplate") as? String
                    categories.append(category)
                }
            }
        }catch let error as NSError{
            fatalError("\(error)")
        }
        
    }

}
