//
//  FavoriteArticle+CoreDataProperties.swift
//  
//
//  Created by SHIN MIKHAIL on 23.08.2023.
//
//

import Foundation
import CoreData

extension FavoriteArticle {
    @objc(FavoriteArticle)
    public class FavoriteArticle: NSManagedObject {
        
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteArticle> {
        return NSFetchRequest<FavoriteArticle>(entityName: "FavoriteArticle")
    }
    
    @NSManaged public var abstract: String?
    @NSManaged public var url: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var title: String?
    @NSManaged public var isFavorite: Bool
}
