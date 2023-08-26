//
//  MainTabBarController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    //MARK: Lifecycle
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
        _ = configureFavoritesViewControllerBadge() // FavoritesViewControllerBadge
        
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
    // Generate View Controllers
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}
//MARK: - Create Badge
extension MainTabBarController {
    // Favorites View Controller Badge
    private func configureFavoritesViewControllerBadge() -> UIViewController {
        let favoritesViewController = FavoritesViewController()
        // Получаем количество статей в избранном
        if let badgeCount = getFavoriteArticlesCount() {
            favoritesViewController.tabBarItem.badgeValue = String(badgeCount)
            print("Badge count \(badgeCount)")
        } else {
            favoritesViewController.tabBarItem.badgeValue = nil // Если нет статей удаляем badge
            print("No favorite articles")
        }
        return favoritesViewController
    }
    // get Favorite Articles Count
    private func getFavoriteArticlesCount() -> Int? {
        let favoriteArticles = CoreDataManager.shared.fetchFavoriteArticles()
        return favoriteArticles.count
    }
    // update Favorites Badge
    private func updateFavoritesBadge() {
        if let favoriteCount = getFavoriteArticlesCount() {
            if favoriteCount > 0 {
                tabBar.items?.last?.badgeValue = String(favoriteCount)
            } else {
                tabBar.items?.last?.badgeValue = nil
            }
        }
    }
}
