//
//  CategoryCustomizeController.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/22.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CategoryCustomizeController: UIViewController {
    
    var categoryId:NSNumber! = 0
    var categoryName:String? = ""
    @IBOutlet weak var categoryCustomizeField: UITextField!
    
    var category = ICategory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.categoryCustomizeField.text = categoryName
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if categoryCustomizeField.text != "" {
            let photosReview = PhotosReviewAdaptor()
            category.categoryId = 1
            category.categoryName = categoryCustomizeField.text
            category.updateDate = NSDate() // GMTで保存
            categoryId = 0
            switch categoryId {
            case 0:
                category.createDate = NSDate() // GMTで保存
                photosReview.EntryCategory(category)
                break
            default:
                break
            }
        }
    }
}
