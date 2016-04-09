//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var createDate: NSDate?
    @NSManaged var photoDate: NSDate?
    @NSManaged var photoHeight: NSNumber?
    @NSManaged var photoID: NSNumber?
    @NSManaged var photoLatitude: String?
    @NSManaged var photoLongitude: String?
    @NSManaged var photoName: String?
    @NSManaged var photoPass: String?
    @NSManaged var photoWidth: NSNumber?
    @NSManaged var updateDate: NSDate?
    @NSManaged var photoToReview: NSManagedObject?

}
