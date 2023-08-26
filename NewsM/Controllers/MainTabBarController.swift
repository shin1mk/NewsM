//
//  MainTabBarController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        updateFavoritesBadge()
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         updateFavoritesBadge()
     }
    //MARK: Create TabBar
    private func generateTabBar() {
        let favoritesViewController = FavoritesViewController()
         
         // Получаем количество статей в избранном
         if let badgeCount = getFavoriteArticlesCount() {
             favoritesViewController.tabBarItem.badgeValue = String(badgeCount)
             print("Badge count set to: \(badgeCount)")
         } else {
             favoritesViewController.tabBarItem.badgeValue = nil // Если нет статей, уберите бейдж
             print("No favorite articles, badge cleared.")
         }
        
        viewControllers = [
            generateVC(
                viewController: EmailedViewController(),
                title: "Emailed",
                image: UIImage(systemName: "message.badge.filled.fill")),
            generateVC(
                viewController: SharedViewController(),
                title: "Shared",
                image: UIImage(systemName: "shareplay")),
            generateVC(
                viewController: ViewedViewController(),
                title: "Viewed",
                image: UIImage(systemName: "person.2.fill")),
            generateVC(
                viewController: FavoritesViewController(),
                title: "Favorites",
                image: UIImage(systemName: "heart.fill"))
        ]
    }
    // Generate View Controller
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    func getFavoriteArticlesCount() -> Int? {
        // Здесь вы можете использовать свою логику для подсчета статей в избранном
        let favoriteArticles = CoreDataManager.shared.fetchFavoriteArticles()
        return favoriteArticles.count
    }
    
    func updateFavoritesBadge() {
        if let favoriteCount = getFavoriteArticlesCount() {
            if favoriteCount > 0 {
                tabBar.items?.last?.badgeValue = String(favoriteCount)
            } else {
                tabBar.items?.last?.badgeValue = nil
            }
        }
    }
}
