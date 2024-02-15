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
    
    private let searchHistoryKeywordsMax: Int = 20
    
    // MARK: - Life Cycle
    
    private init() { }
    
    // MARK: - Core Data CRUD
    
    /// EntityList에 정의된 이름 중 특정한 Entity 반환
    func getEntityDescription(targetEntity: CoreDataEntityList) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: targetEntity.name, in: managedObjectContext) ?? nil
    }
    
    /// EntityList에 정의된 이름 중 특정한 Entity에 대한 managedObject List를 반환
    func fetchManagedObjectList(targetEntity: CoreDataEntityList) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: targetEntity.name)
        do {
            let objectList = try managedObjectContext.fetch(fetchRequest)
            return objectList
        } catch {
            print("Fetch \(targetEntity.name) Entity ManagedObjectList Error")
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 현재 managedObjectContext 상태의 변경사항을 저장
    func saveManagedObjectContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Save ManagedObjectContext Error")
            print(error.localizedDescription)
        }
    }
    
    /// managedObjectContext의 변경사항을 저장하지 않고 원상복구
    func rollbackManagedObjectContext() {
        managedObjectContext.rollback()
    }
    
}

// MARK: - CategoryFilterBottomSheet Action

extension CoreDataManager {
    
    /// CategoryFilter Entity에 저장되어있는 'category' 항목의 하위 카테고리 목록 반환
    func fetchSubCategoryList(targetTabPlace: TabPlaceCategoryList) -> [String] {
        let fetchRequest = CategoryFilter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryFilter.category), targetTabPlace.parameterCategory)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.count > 0 ? result[0].subCategory ?? [] : []
        } catch {
            print("fetch \(targetTabPlace.parameterCategory) error")
            return []
        }
    }
    
    /// 세부 카테고리 선택 상태값 업데이트
    func updateSubCategory(category: String, subCategory: String, isSelected: Bool, currentViewController: UIViewController?) -> Bool {
        let fetchRequest = CategoryFilter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryFilter.category), category)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if result.count == 0 {
                addCategoryFilter(placeCategory: PlaceCategoryModel(category: category, subCategory: [subCategory]))
                return true
            }
            
            let toUpdateManagedObject = result[0]
            
            let subCategoryList = toUpdateManagedObject.subCategory
            var toUpdateSubCategoryList = isSelected ? [subCategory] : []
            
            switch isSelected {
            case true:
                // Detail Category 중복저장 방지
                subCategoryList?.forEach {
                    if !toUpdateSubCategoryList.contains($0) {
                        toUpdateSubCategoryList.append($0)
                    }
                }
            case false:
                subCategoryList?.forEach {
                    if $0 != subCategory {
                        toUpdateSubCategoryList.append($0)
                    }
                }
                
                // 최소 1개 이상 저장 필수조건 설정
                if toUpdateSubCategoryList.count == 0 {
                    if let vc = currentViewController {
                        vc.showToast(message: "CannotSelectNothing".localized, bottomViewHeight: 40.0)
                    }
                    return false
                }
            }
            toUpdateManagedObject.setValue(toUpdateSubCategoryList, forKey: #keyPath(CategoryFilter.subCategory))
            
            return true
        } catch {
            print("Fetch \(category) List error")
            
            return false
        }
    }
    
    /// CategoryFilter Entity 안에 내용을 모두 삭제
    func deleteCategoryFilterSelection() {
        if let managedObjectList = fetchManagedObjectList(targetEntity: .categoryFilter) {
            managedObjectList.forEach {
                managedObjectContext.delete($0)
            }
            print("\(CoreDataEntityList.categoryFilter.name) Entity is Cleaned")
        }
    }
      
    /// 기본설정(전체선택 상태)로 초기화
    func resetSubCategorySelection() {
        deleteCategoryFilterSelection()
        
        // 동일값 중복 저장 금지 설정
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        TabPlaceCategoryList.allCases
            .filter { $0 != .all }
            .forEach {
                addCategoryFilter(placeCategory: PlaceCategoryModel(category: $0.parameterCategory,
                                                                     subCategory: $0.categoryDetailParameterList))
            }
    }
    
    /// 세부 카테고리 전체선택 상태으로 초기화
    func initialLocalCategoryFilterSelection() {
        resetSubCategorySelection()
        saveManagedObjectContext()
        print("Initialized CategoryFilter")
    }
    
    /// PlaceCategory 모델에 있는 카테고리와 세부 카테고리를 CategoryFilter Entity에 추가
    func addCategoryFilter(placeCategory: PlaceCategoryModel) {
        if let entity = getEntityDescription(targetEntity: CoreDataEntityList.categoryFilter) {
            let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
            managedObject.setValue(placeCategory.category, forKeyPath: #keyPath(CategoryFilter.category))
            managedObject.setValue(placeCategory.subCategory, forKeyPath: #keyPath(CategoryFilter.subCategory))
        }
    }
    
}

// MARK: - SearchHistory Action

extension CoreDataManager {
    
    /// 키워드 검색기록 목록 반환
    func getKeywordHistoryList() -> [SearchHistoryContent] {
        if let searchHistoryObjectList = fetchSearchHistoryObjectList() {
            var keywordHistoryList: [SearchHistoryContent] = []
            
            searchHistoryObjectList.forEach {
                if let keyword = $0.value(forKey: #keyPath(SearchHistory.keyword)) as? String,
                   let time = $0.value(forKey: #keyPath(SearchHistory.time)) as? Date {
                    keywordHistoryList.append(SearchHistoryContent(id: 0, query: keyword, createdAt: time.toString()))
                }
            }
            return keywordHistoryList
        } else {
            return []
        }
    }
    
    /// 키워드 검색기록 SearchHistory ManagedObject 목록 반환
    func fetchSearchHistoryObjectList() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntityList.searchHistory.name)
        
        // 키워드 검색 시간 순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: #keyPath(SearchHistory.time), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let searchHistoryObjectList = try managedObjectContext.fetch(fetchRequest)
            return searchHistoryObjectList
        } catch {
            print("fetch \(CoreDataEntityList.searchHistory.name) Entity error")
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    /// 키워드 검색기록 저장
    func saveSearchKeyword(toSaveKeyword keyword: String) {
        // 같은 키워드 중복 저장 금지 설정
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if let entity = getEntityDescription(targetEntity: .searchHistory),
           let objectList = fetchSearchHistoryObjectList() {
            let searchHistoryContentList = getKeywordHistoryList()
            let keywordHistoryList = searchHistoryContentList.map { $0.query }
            
            // 최대 저장 개수 초과시 가장 오래된 키워드 삭제
            if objectList.count >= searchHistoryKeywordsMax,
               keywordHistoryList.contains(keyword) == false {
                let toDeleteObjectList = objectList.dropFirst(searchHistoryKeywordsMax - 1)
                toDeleteObjectList.forEach {
                    managedObjectContext.delete($0)
                }
            }
            
            let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
            managedObject.setValue(keyword, forKeyPath: #keyPath(SearchHistory.keyword))
            managedObject.setValue(Date(), forKeyPath: #keyPath(SearchHistory.time))
            
            saveManagedObjectContext()
        } else {
            print("Save SearchKeyword error!")
        }
    }
    
    /// 특정한 키워드 검색기록 삭제
    func deleteSearchKeyword(targetKeyword: String) -> Bool {
        if let objectList = fetchSearchHistoryObjectList() {
            for object in objectList {
                if let curkeyword = object.value(forKey: #keyPath(SearchHistory.keyword)) as? String {
                    if curkeyword == targetKeyword {
                        managedObjectContext.delete(object)
                        break
                    }
                }
            }
            saveManagedObjectContext()
            
            return true
        } else {
            return false
        }
    }
    
    /// 모든 키워드 검색기록 삭제
    func deleteAllSearchKeyword() -> Bool {
        if let objectList = fetchSearchHistoryObjectList() {
            objectList.forEach {
                managedObjectContext.delete($0)
            }
            saveManagedObjectContext()
            
            return true
        } else {
            return false
        }
    }
    
}
