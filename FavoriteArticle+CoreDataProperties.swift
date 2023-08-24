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

}
/*
пределите основные требования:
Загрузка статей с сервера.
Сохранение статей в избранное.
Офлайн доступ к сохраненным статьям.
Загрузка изображений, связанных со статьями.
 
Настройте сетевую логику:

Сохранение статей в CoreData:
После успешной загрузки статьи с сервера, сохраните ее в CoreData в качестве "избранной" или "офлайн" статьи.
Для хранения HTML-контента статьи используйте подходящий атрибут в CoreData, как я описал в предыдущем ответе.
 
Загрузка изображений:
Если статьи содержат изображения, загрузите их после загрузки самой статьи. Для загрузки изображений можно использовать Alamofire или стандартные инструменты.
Сохраните изображения в локальное хранилище на устройстве, например, в кеше или в отдельной папке.
 
Обеспечьте офлайн доступ:
Когда пользователь открывает статью, проверьте, есть ли она в CoreData. Если она там, отобразите сохраненное содержание статьи, включая изображения.
Если статьи содержат изображения, убедитесь, что они также доступны офлайн, используя локально сохраненные копии.
 
Управление избранными статьями:
Реализуйте функциональность для добавления и удаления статей в избранное.
При добавлении статьи в избранное сохраните ее в CoreData.
При удалении статьи из избранного удаляйте ее из CoreData.
*/
