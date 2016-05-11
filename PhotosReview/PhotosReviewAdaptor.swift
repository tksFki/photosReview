//
//  PhotosReviewAdaptor.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/04/21.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit
import CoreData

class PhotosReviewAdaptor {
    
    var isReviewName:Bool = false
    var isReviewComment:Bool = false
    var isCategoryId:Bool = false
    var isCreateDateFrom:Bool = false
    var isCreateDateTo:Bool = false
    
    // レビュー登録
    func entryReview(review: IReview) {
        
        // エンティティ作成
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let reviewEntity =  NSEntityDescription.entityForName("Review",
                                                              inManagedObjectContext:managedContext)
        
        let reviewItem = NSManagedObject(entity: reviewEntity!,
                                         insertIntoManagedObjectContext: managedContext) as! Review
        
        
        /* レビューエンティティSave */
        reviewItem.reviewNo = getNextReviewNo()
        reviewItem.reviewName = review.reviewName!
        reviewItem.categoryId = review.categoryId!
        reviewItem.estimation = review.estimation!
        reviewItem.photoData = review.photoData!
        reviewItem.comment = review.comment!
        reviewItem.photoOrientation = review.photoOrientation!
        reviewItem.photoWidth = review.photoWidth!
        reviewItem.photoHeight = review.photoHeight!
        
        reviewItem.createDate = NSDate()
        reviewItem.updateDate = reviewItem.createDate!
        do {
            try managedContext.save()
        } catch let error as NSError  {
            fatalError("\(error)")
        }
    }
    
    func getNextReviewNo() -> NSNumber {
        
        let expressionReviewNo = "maxReviewNo"
        var nextReviewNo:Int = 1
        
        // エンティティ作成
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        /// fetchRequestの生成
        let fetchRequest = NSFetchRequest()
        
        /// EntityDescriptionの生成
        let reviewEntity = NSEntityDescription.entityForName("Review", inManagedObjectContext: managedContext)
        fetchRequest.entity = reviewEntity
        
        let keyPathExpression = NSExpression(forKeyPath: "reviewNo")
        let expression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = expressionReviewNo
        expressionDescription.expression = expression
        expressionDescription.expressionResultType = NSAttributeType.Integer32AttributeType
        
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            if let maxReviewNo = results.first?.valueForKey(expressionReviewNo) as? Int {
                print("maxReviewNo = \(maxReviewNo)")
                nextReviewNo = maxReviewNo + 1
            }
        } catch let error {
            fatalError("\(error)")
        }
        return NSNumber.init(integer: nextReviewNo)
    }
    // カテゴリ更新
    func updateReview(review: IReview) {
        
        // エンティティ作成
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let reviewEntity =  NSEntityDescription.entityForName("Review",
                                                              inManagedObjectContext:managedContext)
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Review")
        fetchRequest.entity = reviewEntity
        let predicate = NSPredicate(format: "%K = %@", "reviewNo", review.reviewNo!)
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
            if let results: Array = fetchResults {
                for result in results {
                    let model = result as! Review
                    model.reviewName = review.reviewName!
                    model.categoryId = review.categoryId!
                    model.estimation = review.estimation!
                    model.photoData = review.photoData!
                    model.comment = review.comment!
                    model.photoOrientation = review.photoOrientation!
                    model.photoWidth = review.photoWidth!
                    model.photoHeight = review.photoHeight!
                    model.createDate = review.createDate!
                    model.updateDate = NSDate()
                }
            }
        } catch let error as NSError {
            fatalError("\(error)")
        }
        // 作成したオブジェクトを保存
        appDelegate.saveContext()
    }
    
    
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
            
            if let results: NSArray = fetchResults {
                for obj:AnyObject in results {
                    let review: IReview = IReview()
                    review.reviewNo = obj.valueForKey("reviewNo") as? NSNumber
                    review.reviewName = obj.valueForKey("reviewName") as? String
                    review.categoryId = obj.valueForKey("categoryId") as? NSNumber
                    review.estimation = obj.valueForKey("estimation") as? NSNumber
                    review.photoData = obj.valueForKey("photoData") as? NSData
                    review.comment = obj.valueForKey("comment") as? String
                    review.photoOrientation = obj.valueForKey("photoOrientation") as? NSNumber
                    review.photoWidth = obj.valueForKey("photoWidth") as? NSNumber
                    review.photoHeight = obj.valueForKey("photoHeight") as? NSNumber
                    review.createDate = obj.valueForKey("createDate") as? NSDate
                    review.updateDate = obj.valueForKey("updateDate") as? NSDate
                    
                    reviews.append(review)
                    //                    self.selectedPhoto.image = photoData.flatMap(UIImage.init)
                }
                //                print("recordCounts:" + results.count.description)
            }
        }catch let error as NSError{
            fatalError("\(error)")
        }
        return reviews
    }
    
    // レビューを読み込む
    func loadReviewWithReviewNo(reviewNo: NSNumber) -> IReview {
        
        let review: IReview = IReview()
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Review")
        let predicate = NSPredicate(format: "%K = %@" ,"reviewNo",reviewNo)
        fetchRequest.predicate = predicate
        
        /* Get result array from ManagedObjectContext */
        do{
            let fetchResults = try manageContext.executeFetchRequest(fetchRequest)
            
            if let results: NSArray = fetchResults {
                for obj:AnyObject in results {
                    review.reviewNo = obj.valueForKey("reviewNo") as? NSNumber
                    review.reviewName = obj.valueForKey("reviewName") as? String
                    review.categoryId = obj.valueForKey("categoryId") as? NSNumber
                    review.estimation = obj.valueForKey("estimation") as? NSNumber
                    review.photoData = obj.valueForKey("photoData") as? NSData
                    review.comment = obj.valueForKey("comment") as? String
                    review.photoOrientation = obj.valueForKey("photoOrientation") as? NSNumber
                    review.photoWidth = obj.valueForKey("photoWidth") as? NSNumber
                    review.photoHeight = obj.valueForKey("photoHeight") as? NSNumber
                    review.createDate = obj.valueForKey("createDate") as? NSDate
                    review.updateDate = obj.valueForKey("updateDate") as? NSDate
                    //                    self.selectedPhoto.image = photoData.flatMap(UIImage.init)
                }
                //                print("recordCounts:" + results.count.description)
            }
        }catch let error as NSError{
            fatalError("\(error)")
        }
        return review
    }
    
    // レビューを読み込む
    func loadReviewWithSearchConditions(conditions: ISearchConditions) -> [IReview] {
        
        var reviews:[IReview] = [IReview]()
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDelegate.managedObjectContext
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Review")
        let formatStr = makeConditionsFormat(conditions)
        if formatStr != "" {
            let predicateTemplate = NSPredicate(format: formatStr)
            var variables = Dictionary<String,AnyObject>()
            if isReviewName {
                if isReviewComment {
                    variables["reviewName"] = conditions.searchedReviewName!
                    variables["comment"] = conditions.searchedReviewName!
                }else{
                    variables["reviewName"] = conditions.searchedReviewName!
                }
            }
            if isCategoryId {
                variables["categoryId"] = conditions.searchedCategoryId!
            }
            if isCreateDateFrom || isCreateDateTo {
                if isCreateDateFrom && isCreateDateTo {
                    variables["createDateFrom"] = conditions.searchedCreateDateFrom!
                    variables["createDateTo"] = conditions.searchedCreateDateTo!
                }
                else if isCreateDateFrom{
                    variables["createDateFrom"] = conditions.searchedCreateDateFrom!
                }
                else if isCreateDateTo {
                    variables["createDateTo"] = conditions.searchedCreateDateFrom!
                }
            }
            let predicate = predicateTemplate.predicateWithSubstitutionVariables(variables)
            fetchRequest.predicate = predicate
        }
        
        /* Get result array from ManagedObjectContext */
        do{
            let fetchResults = try manageContext.executeFetchRequest(fetchRequest)
            
            if let results: NSArray = fetchResults {
                for obj:AnyObject in results {
                    let review: IReview = IReview()
                    review.reviewNo = obj.valueForKey("reviewNo") as? NSNumber
                    review.reviewName = obj.valueForKey("reviewName") as? String
                    review.categoryId = obj.valueForKey("categoryId") as? NSNumber
                    review.estimation = obj.valueForKey("estimation") as? NSNumber
                    review.photoData = obj.valueForKey("photoData") as? NSData
                    review.comment = obj.valueForKey("comment") as? String
                    review.photoOrientation = obj.valueForKey("photoOrientation") as? NSNumber
                    review.photoWidth = obj.valueForKey("photoWidth") as? NSNumber
                    review.photoHeight = obj.valueForKey("photoHeight") as? NSNumber
                    review.createDate = obj.valueForKey("createDate") as? NSDate
                    review.updateDate = obj.valueForKey("updateDate") as? NSDate
                    //                    self.selectedPhoto.image = photoData.flatMap(UIImage.init)
                    reviews.append(review)
                }
                //                print("recordCounts:" + results.count.description)
            }
        }catch let error as NSError{
            fatalError("\(error)")
        }
        return reviews
    }
    
    func makeConditionsFormat(conditions: ISearchConditions) -> String {
        
        var conditionsFormat:String = ""
        
        // レビュータイトル検索条件
        if conditions.searchedReviewName != nil {
            // レビュー本文も含むか
            if conditions.isContainsReviewComment {
                conditionsFormat = "reviewName CONTAINS $reviewName or comment CONTAINS $comment "
                self.isReviewName = true
                self.isReviewComment = true
            }else{
                conditionsFormat = "reviewName CONTAINS $reviewName "
                self.isReviewName = true
            }
        }
        // カテゴリ検索条件
        if conditions.searchedCategoryId != nil {
            if conditionsFormat != "" {
                conditionsFormat += "and categoryId = $categoryId "
            }else{
                conditionsFormat += "categoryId = $categoryId "
            }
            self.isCategoryId = true
        }
        // 作成日付検索条件
        if conditions.searchedCreateDateFrom != nil  || conditions.searchedCreateDateFrom != nil {
            if conditionsFormat != "" {
                if (conditions.searchedCreateDateFrom != nil  && conditions.searchedCreateDateTo != nil){
                    conditionsFormat += "and ( $createDateFrom <= createDate and createDate <= $createDateTo ) "
                    self.isCreateDateFrom = true
                    self.isCreateDateTo = true
                }
                else if (conditions.searchedCreateDateFrom != nil){
                    conditionsFormat += "and $createDateFrom <= createDate "
                    self.isCreateDateFrom = true
                }
                else if (conditions.searchedCreateDateTo != nil){
                    conditionsFormat += "and createDate <= $createDateTo "
                    self.isCreateDateTo = true
                }
            }else{
                if (conditions.searchedCreateDateFrom != nil  && conditions.searchedCreateDateTo != nil){
                    conditionsFormat += " ( $createDateFrom <= createDate and createDate <= $createDateTo ) "
                    self.isCreateDateFrom = true
                    self.isCreateDateTo = true
                }
                else if (conditions.searchedCreateDateFrom != nil){
                    conditionsFormat += "$createDateFrom <= createDate "
                    self.isCreateDateFrom = true
                }
                else if (conditions.searchedCreateDateTo != nil){
                    conditionsFormat += "createDate <= $createDateTo "
                    self.isCreateDateTo = true
                }
            }
        }
        return conditionsFormat
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
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entity
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
    
    // カテゴリ登録（カテゴリ番号は最大 categoryId + 1 で採番されているものとする。）
    func entryCategory(category: ICategory) {
        
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
        categoryItem.createDate = NSDate()
        categoryItem.updateDate = category.createDate
        do {
            try managedContext.save()
        } catch let error as NSError  {
            fatalError("\(error)")
        }
        
    }
    
    // カテゴリ更新
    func updateCategory(category: ICategory) {
        
        // エンティティ作成
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let categoryEntity =  NSEntityDescription.entityForName("Category",
                                                                inManagedObjectContext:managedContext)
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.entity = categoryEntity
        let predicate = NSPredicate(format: "%K = %@", "categoryId", category.categoryId!)
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
            if let results: Array = fetchResults {
                for result in results {
                    let model = result as! Category
                    model.categoryName = category.categoryName
                    model.updateDate = NSDate()
                }
            }
        } catch let error as NSError {
            fatalError("\(error)")
        }
        // 作成したオブジェクトを保存
        appDelegate.saveContext()
    }
    
    // カテゴリを読み込む
    func loadCategory() -> [ICategory] {
        
        var categories = [ICategory]()
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Category")
        // ソート（カテゴリIdを昇順に）
        let sortDescriptror = NSSortDescriptor(key: "categoryId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptror]
        
        /* Get result array from ManagedObjectContext */
        do{
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
            
            if let results: Array = fetchResults {
                for result in results {
                    let category = ICategory()
                    category.categoryId = result.valueForKey("categoryId") as? NSNumber
                    category.categoryName = result.valueForKey("categoryName") as? String
                    category.categoryTemplate = result.valueForKey("categoryTemplate") as? String
                    categories.append(category)
                }
            }
            return categories
        }catch let error as NSError{
            fatalError("\(error)")
        }
    }
    
    // カテゴリを読み込む
    func loadCategoryWithCategoryId(categoryId: NSNumber) -> ICategory {
        
        let category = ICategory()
        
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let predicate = NSPredicate(format: "%K = %@", "categoryId",categoryId)
        fetchRequest.predicate = predicate
        
        /* Get result array from ManagedObjectContext */
        do{
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
            
            if let results: Array = fetchResults {
                for result in results {
                    category.categoryId = result.valueForKey("categoryId") as? NSNumber
                    category.categoryName = result.valueForKey("categoryName") as? String
                    category.categoryTemplate = result.valueForKey("categoryTemplate") as? String
                }
            }
            return category
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
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = categoryEntity
        // NSPredicate SQLのWhere句のようなイメージ
        let predicate = NSPredicate(format: "%K = %@", "categoryId", categoryId)
        fetchRequest.predicate = predicate
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for result in results {
                let model = result as! Category
                managedContext.deleteObject(model)
            }
            
        }catch let error as NSError {
            fatalError("\(error)")
        }
        // 作成したオブジェクトを保存
        appDelegate.saveContext()
    }
    
}