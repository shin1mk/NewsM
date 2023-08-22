//
//  MainTabBarController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 20.08.2023.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    //MARK: Create TabBar
    private func generateTabBar() {
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
    // Delegate
    private func setupDelegate() {
        delegate = self
    }
    //MARK: Animation TabBar
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let fromView = selectedViewController?.view, let toView = viewController.view {
            if fromView != toView {
                UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
            }
        }
        return true
    }
}
