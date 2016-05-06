//
//  CategoryCustomizeController.swift
//  PhotosReview
//
//  Created by TakashiFukui on 2016/04/22.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//

import UIKit

class CategoryCustomizeController: UIViewController {
    
    var categoryId:NSNumber = 0
    var categoryName:String? = ""
    var categoryMaxSeq:NSNumber = 0
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
            category.categoryName = categoryCustomizeField.text
            switch self.categoryId {
            case 0:
                category.categoryId = NSNumber(int: self.categoryMaxSeq.intValue + 1)
                photosReview.entryCategory(category)
                break
            default:
                category.categoryId = self.categoryId
                photosReview.updateCategory(category)
                break
            }
        }
    }
}
