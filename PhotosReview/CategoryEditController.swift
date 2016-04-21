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
    var review:ICategory?
    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let photosReviewAdaptor = PhotosReviewAdaptor()
        categories = photosReviewAdaptor.loadCategory()
    }
    
}
