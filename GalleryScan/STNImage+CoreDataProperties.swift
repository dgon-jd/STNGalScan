//
//  STNImage+CoreDataProperties.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 3/28/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//
//

import Foundation
import CoreData


extension STNImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STNImage> {
        return NSFetchRequest<STNImage>(entityName: "STNImage")
    }

    @NSManaged public var fileUrl: String?
    @NSManaged public var imageId: String?
    @NSManaged public var markedForReview: Bool
    @NSManaged public var resolveDate: NSDate?

}
