//
//  Category+CoreDataProperties.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/21.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var categoryId: NSNumber?
    @NSManaged var categoryName: String?
    @NSManaged var categoryTemplate: String?
    @NSManaged var createDate: NSDate?
    @NSManaged var updateDate: NSDate?
    @NSManaged var categoryToReview: Review?

}
