//
//  CoreDataManager.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/22.
//

import UIKit
import CoreData

class CoreDataManager {
    
    // MARK: - Variables and Properties
    
    static let shared = CoreDataManager()
    
    private let persistentContainerIdentifier = "ReetPlace"
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: persistentContainerIdentifier)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var managedObjectContext = persistentContainer.viewContext
    
//    private let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//    lazy var context = appDelegate.persistentContainer.viewContext
    
    // MARK: - Life Cycle
    
    private init() { }
    
    // MARK: - Core Data Saving, Updating support

    
    
    
    
    func saveCategoryFilter(placeCategory: PlaceCategoryModel) {
        // 동일값 중복 저장 금지 설정
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // 1
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityList.categoryFilter.name, in: managedObjectContext)
        else {
            print("Get CategoryFilter Entity Error!")
            return
        }
        
        // 2
        let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        managedObject.setValue(placeCategory.category, forKeyPath: #keyPath(CategoryFilter.category))
        managedObject.setValue(placeCategory.subCategory, forKeyPath: #keyPath(CategoryFilter.subCategory))
        
        // 3
        do {
          try managedObjectContext.save()
        } catch {
            print("could not save value in Core Data")
            print(error.localizedDescription)
        }
    }
    
    func update(targetPlaceCategoryModel: PlaceCategoryModel) {
        let fetchRequest = CategoryFilter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryFilter.category), targetPlaceCategoryModel.category)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            let toUpdateManagedObject = result[0]
            toUpdateManagedObject.setValue(targetPlaceCategoryModel.subCategory, forKey: #keyPath(CategoryFilter.subCategory))
            
            print("Update SubCategoryList Success")
        } catch {
            print("fetch \(targetPlaceCategoryModel.category) error")
        }
    }
    
    
    
    func saveSettings() {
        do {
            try managedObjectContext.save()
            print("save success")
        } catch {
            print("Save CategoryFilter Settings Error")
            print(error.localizedDescription)
        }
    }
    
    func cancelSettings() {
        managedObjectContext.rollback()
        print("CoreData Rollback(cancel save data) called")
        
//        do {
//            try managedObjectContext.rollback()
//        } catch {
//            print("Cancel Settings Error")
//            print(error.localizedDescription)
//        }
    }
    
    
    
    /// CategoryFilter에 저장되어있는 'category' 항목의 하위 카테고리 목록 반환
    func fetch(targetTabPlace: TabPlaceCategoryList) -> [String] {
        let fetchRequest = CategoryFilter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryFilter.category), targetTabPlace.parameterCategory)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result[0].subCategory ?? []
        } catch {
            print("fetch \(targetTabPlace.parameterCategory) error")
            return []
        }
    }
    
    
    
    
    func initLocalCategoryFilterSettings() {
        if let managedObjectList = get(targetEntity: .categoryFilter) {
            managedObjectList.forEach {
                do {
                    managedObjectContext.delete($0)
                    try managedObjectContext.save()
                    
                } catch {
                    print("targetManagedObject Delete Failed")
                    print(error.localizedDescription)
                }
            }
            
            print("\(CoreDataEntityList.categoryFilter.name) Entity is Cleaned")
        }
        
        TabPlaceCategoryList.allCases
            .filter { $0 != .all }
            .forEach {
                saveCategoryFilter(placeCategory: PlaceCategoryModel(category: $0.parameterCategory,
                                                                            subCategory: [$0.categoryDetailParameterList[0]]))
            }
        
        print("Initialize CategoryFilter!")
    }
    
    
    
    
    
    
    func save(targetEntity: CoreDataEntityList, value: Bool, key: String) {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
        
//        // 1. Get NSManagedObjectContext
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        
        // 1. Get NSManagedObjectContext
//        let managedObjectContext = persistentContainer.viewContext
        // 동일값 중복 저장 금지 설정
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // 2. Get Entity by NSManagedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: targetEntity.name, in: managedObjectContext)
        else {
            print("Get Entity Error!")
            return
        }

        // 3. Create NSManagedObject
        let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        // 4. Set the Search Keyword
        managedObject.setValue(value, forKeyPath: key)
        
        // 5. Save NSManagedObjectContext which modified
        do {
          try managedObjectContext.save()
        } catch {
            print("could not save value in Core Data")
            print(error.localizedDescription)
        }
    }

    func get(targetEntity: CoreDataEntityList) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: targetEntity.name)
        do {
            let objectList = try managedObjectContext.fetch(fetchRequest)
            return objectList
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
