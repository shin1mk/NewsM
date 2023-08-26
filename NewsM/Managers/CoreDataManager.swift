//
//  CoreDataManager.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 23.08.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsM") // my CoreData model
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // извлечение избранных статей
    func fetchFavoriteArticles() -> [FavoriteArticle] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        
        do {
            let favoriteArticles = try context.fetch(fetchRequest)
            return favoriteArticles
        } catch {
            print("Error fetching favorite articles: \(error.localizedDescription)")
            return []
        }
    }
    // save favorite article
    func saveFavoriteArticle(newsArticle: NewsArticle) {
        let context = persistentContainer.viewContext
        let favoriteArticle = FavoriteArticle(context: context)
        favoriteArticle.title = newsArticle.title
        favoriteArticle.abstract = newsArticle.abstract
        favoriteArticle.url = newsArticle.url
        favoriteArticle.publishedDate = newsArticle.publishedDate
        
        saveContext()
    }
}
