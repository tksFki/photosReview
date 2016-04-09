//
//  Review+CoreDataProperties.swift
//  PhotosReview
//
//  Created by TechnoData on 2016/04/03.
//  Copyright © 2016年 privateTakashi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Review {

    @NSManaged var categoryID: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var createDate: NSDate?
    @NSManaged var estimation: NSNumber?
    @NSManaged var photoID: NSNumber?
    @NSManaged var reviewName: String?
    @NSManaged var reviewNo: NSNumber?
    @NSManaged var tag1: String?
    @NSManaged var tag2: String?
    @NSManaged var tag3: String?
    @NSManaged var tag4: String?
    @NSManaged var tag5: String?
    @NSManaged var updateDate: NSDate?
    @NSManaged var reviewToCategory: Category?
    @NSManaged var reviewToPhoto: Photo?

}
