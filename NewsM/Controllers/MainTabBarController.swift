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
        setTabBarAppearance()
        setupDelegate()
    }
    //MARK: Create TabBar
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: HomeViewController(),
                title: "Home",
                image: UIImage(systemName: "house.fill")),
            generateVC(
                viewController: PersonViewController(),
                title: "Person",
                image: UIImage(systemName: "person.fill")),
            generateVC(
                viewController: SettingsViewController(),
                title: "Settings",
                image: UIImage(systemName: "slider.horizontal.3"))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 15
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: 25
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
    }
    // Delegates
    private func setupDelegate() {
        delegate = self
    }
    //MARK: Animation TabBar
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let fromView = selectedViewController?.view, let toView = viewController.view {
            if fromView != toView {
                UIView.transition(from: fromView, to: toView, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
            }
        }
        return true
    }
} // end class MainTabBar
