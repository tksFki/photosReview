//
//  CategoryEditController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/17.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CategoryEditController: UITableViewController {
    
    var categories = [ICategory]()
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCategoryCustomize"{
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                let vc = segue.destinationViewController as! CategoryCustomizeController
                if indexPath.row < categories.count{
                    vc.categoryId = category.categoryId
                    vc.categoryName = category.categoryName
                }else{
                    vc.categoryId = 0
                    vc.categoryName = ""
                }
                
            }
        }
    }

    // 画面遷移時に画面表示前にカテゴリデータ取得
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let photosReviewAdaptor = PhotosReviewAdaptor()
        categories = photosReviewAdaptor.loadCategory()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
