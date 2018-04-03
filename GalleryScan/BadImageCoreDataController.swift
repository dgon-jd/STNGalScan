//
//  BadImageCoreDataWrapper.swift
//  GalleryScan
//
//  Created by Dmitry Goncharenko on 3/28/18.
//  Copyright © 2018 Ciklum. All rights reserved.
//

import Foundation
import CoreData

class BadImageCoreDataController: NSObject {
  var persistentContainer: NSPersistentContainer

  init(completion: (() -> ())?) {
    persistentContainer = NSPersistentContainer(name: "GalleryScan" )
    persistentContainer.loadPersistentStores { (description, error) in
      if let error = error {
        fatalError("Failed to load Core Data stack: \(error)")
      }
      completion?()
    }
  }

  func saveAsset(id: String) {
    persistentContainer.performBackgroundTask { context in
      let imageModel = self.imageModel(id: id, context: context) ?? NSEntityDescription.insertNewObject(forEntityName: "STNImage", into: context) as! STNImage
      imageModel.imageId = id
      try? context.save()
      print("Saved")
    }
  }

  func imageModel(id: String, context: NSManagedObjectContext) -> STNImage? {
    let fetchRequest = NSFetchRequest<STNImage>(entityName: "STNImage")
    fetchRequest.predicate = NSPredicate(format: "imageId = %@", id)
    let images = try? context.fetch(fetchRequest)
    return images?.first
  }

  func fetchAllsavedImages() {
    let fetchRequest = NSFetchRequest<STNImage>(entityName: "STNImage")
    do {
      let images = try persistentContainer.viewContext.fetch(fetchRequest)
      print(images.count)
    } catch {
      fatalError("Failed to fetch images: \(error)")
    }
  }

  func deleteAllImageModels()
  {
    let managedContext = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<STNImage>(entityName: "STNImage")
    fetchRequest.returnsObjectsAsFaults = false

    do
    {
      let results = try managedContext.fetch(fetchRequest)
      for managedObject in results
      {
        managedContext.delete(managedObject)
      }
    } catch let error as NSError {
      print("Detele all data in STNIMage error : \(error) \(error.userInfo)")
    }
    try? managedContext.save()

  }
}
