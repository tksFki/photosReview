//
//  CategoryEditController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CategoryEditController: UITableViewController {
    
    var categories = [ICategory]()
    var categoryMaxSeq: NSNumber = 0
    
    var searchedCategoryId: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("searchedCategoryId")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count+1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        if indexPath.row < categories.count{
            cell.textLabel?.text = categories[indexPath.row].categoryName
        }else{
            cell.textLabel?.text = "+ カテゴリを追加する"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 編集モードの挙動
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        // 編集モードを削除を選択した時の挙動
        case .Delete:
            // レビュー検索条件に削除対象のカテゴリIdがあった場合、削除する。
            if self.searchedCategoryId as? NSNumber == categories[indexPath.row].categoryId {
                let ud = NSUserDefaults.standardUserDefaults()
                ud.removeObjectForKey("searchedCategoryId")
            }
            let photosReview = PhotosReviewAdaptor()
            photosReview.deleteCategory(categories[indexPath.row].categoryId!)
            self.categories.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        default:
            return
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCategoryCustomize"{
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // 選択セルが「カテゴリを追加する」セルだった場合、カテゴリ数のチェック
                if categories.count == indexPath.row && categories.count >= 15 {
                    // カテゴリ数が上限に達している場合、アラートを表示して追加できないように
                    let alert:UIAlertController = UIAlertController(title:"Category Limited",
                                                                    message: "登録できるカテゴリは15個までです。",
                                                                    preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }else{
                    let vc = segue.destinationViewController as! CategoryCustomizeController
                    if indexPath.row < categories.count{
                        let category = categories[indexPath.row]
                        vc.categoryId = category.categoryId!
                        vc.categoryName = category.categoryName
                    }else{
                        vc.categoryId = 0
                        vc.categoryName = ""
                    }
                    vc.categoryMaxSeq = self.categoryMaxSeq
                }
            }
        }
    }
    
    // 画面遷移時に画面表示前にカテゴリデータ取得
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = editButtonItem()
        let photosReviewAdaptor = PhotosReviewAdaptor()
        categories = photosReviewAdaptor.loadCategory()
        if categories.count > 0 {
            self.categoryMaxSeq = categories[categories.count-1].categoryId! // 1番大きいカテゴリIdのシーケンス
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    

}
