//
//  PhotosReviewAdaptor.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/21.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import CoreData

class PhotosReviewAdaptor {
    
    // レビューを読み込む
    func loadReview() -> [IReview] {
        
        var reviews:[IReview] = [IReview]()
        
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
                    let review: IReview = IReview()
                    review.reviewNo = obj.valueForKey("reviewNo") as? NSNumber
                    review.reviewName = obj.valueForKey("reviewName") as? String
                    review.categoryId = obj.valueForKey("categoryId") as? NSNumber
                    review.estimation = obj.valueForKey("estimation") as? NSNumber
                    review.photoData = obj.valueForKey("photoData") as? NSData
                    reviews.append(review)
//                    self.selectedPhoto.image = photoData.flatMap(UIImage.init)
                }
//                print("recordCounts:" + results.count.description)
            }
            return reviews
        }catch let error as NSError{
            fatalError("\(error)")
        }
    }
    
    // レビューを削除する
    func deleteReview(reviewNo: NSNumber) {
        
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
            let predicate = NSPredicate(format: "%K = %@", "reviewNo", reviewNo)
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

    // カテゴリ登録
    func EntryCategory(category: ICategory) {
        
        // エンティティ作成
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let categoryEntity =  NSEntityDescription.entityForName("Category",
                                                                inManagedObjectContext:managedContext)
        
        let categoryItem = NSManagedObject(entity: categoryEntity!,
                                           insertIntoManagedObjectContext: managedContext) as! Category
        
        
        /* カテゴリエンティティSave */
        categoryItem.categoryId = category.categoryId
        categoryItem.categoryName = category.categoryName
        categoryItem.createDate = category.createDate
        categoryItem.updateDate = category.updateDate
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    // カテゴリを読み込む
    func loadCategory() -> [ICategory] {
        
        var categories = [ICategory]()
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Category")
        // ソート（カテゴリIdを昇順に）
        let sortDescriptror = NSSortDescriptor(key: "categoryId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptror]
        
        /* Get result array from ManagedObjectContext */
        do{
            let fetchResults = try manageContext.executeFetchRequest(fetchRequest)

            if let results: Array = fetchResults {
                for obj:AnyObject in results {
                    let category = ICategory()
                    category.categoryId = obj.valueForKey("categoryId") as? NSNumber
                    category.categoryName = obj.valueForKey("categoryName") as? String
                    category.categoryTemplate = obj.valueForKey("categoryTemplate") as? String
                    categories.append(category)
                }
            }
            return categories
        }catch let error as NSError{
            fatalError("\(error)")
        }
    }
    
    // レビューを削除する
    func deleteCategory(categoryId: NSNumber) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let categoryEntity =  NSEntityDescription.entityForName("Category",
                                                        inManagedObjectContext:managedContext)
        do
        {
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = categoryEntity;
            // NSPredicate SQLのWhere句のようなイメージ
            let predicate = NSPredicate(format: "%K = %@", "categoryId", categoryId)
            fetchRequest.predicate = predicate
            
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for result in results {
                let model = result as! Category
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

    

    

}