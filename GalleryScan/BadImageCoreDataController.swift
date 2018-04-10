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
  var backGorundContext: NSManagedObjectContext!
  init(completion: (() -> ())?) {
    let momdName = "GalleryScan"

    guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd") else {
      fatalError("Error loading model from bundle")
    }

    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Error initializing mom from: \(modelURL)")
    }

    persistentContainer = NSPersistentContainer(name: momdName, managedObjectModel: mom)
//    persistentContainer = NSPersistentContainer(name: "GalleryScan" )
    persistentContainer.loadPersistentStores { (description, error) in
      if let error = error {
        fatalError("Failed to load Core Data stack: \(error)")
      }
      completion?()
    }
    backGorundContext = persistentContainer.newBackgroundContext()
  }

  func saveAsset(item: STNImageObj, success: (() -> Void)?) {
//    backGorundContext.perform {
//
//    }
    persistentContainer.performBackgroundTask { (context) in
      let imageModel = self.imageModel(id: item.assetId!, context: context) ?? NSEntityDescription.insertNewObject(forEntityName: "STNImage", into: context) as! STNImage
      imageModel.imageId = item.assetId!
      print("Saving \(imageModel.imageId)")
      do {
        try context.save()
      } catch {
        fatalError("Cannot save")
      }
      success?()
    }
  }

  func imageModel(id: String, context: NSManagedObjectContext) -> STNImage? {
    let fetchRequest = NSFetchRequest<STNImage>(entityName: "STNImage")
    fetchRequest.predicate = NSPredicate(format: "imageId = %@", id)
    var images = [STNImage]()
    do {
      images = try context.fetch(fetchRequest)
    }
    catch {
      fatalError("Failed to fetch image!: \(error)")
    }
    return images.first
  }

  func fetchAllsavedImages() {
    let fetchRequest = NSFetchRequest<STNImage>(entityName: "STNImage")
    do {
      let images = try persistentContainer.viewContext.fetch(fetchRequest)
      print("Count: \(images.count)")
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
