//
//  WebViewController.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 21.08.2023.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    //MARK: Properties
    var newsArticle: NewsArticle?
    private var isStarred = false
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebViewConstraints()
        loadArticleURL()
        starButton()
    }
    //MARK: Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    // Setup WebView Constraints
    private func setupWebViewConstraints() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // Load Article URL
    private func loadArticleURL() {
        if let urlStr = newsArticle?.url, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    //MARK: Star Button
    private func starButton() {
        let starButton = UIBarButtonItem(image: UIImage(systemName: isStarred ? "star.fill" : "star"), style: .plain, target: self, action: #selector(starButtonAction))
        navigationItem.rightBarButtonItems = [starButton]
    }
    // star button action
    @objc private func starButtonAction() {
        isStarred.toggle()
        starButton()
        print("starButtonAction")
    }
}



/*
 // star animation
 @objc private func starButtonAction() {
     isStarred.toggle() // Инвертируем состояние кнопки при нажатии
     
     switch isStarred {
     case true:
     animateStarFalling()
     case false:
     break
     }
     starButton() // Обновляем кнопку с новым изображением
     print("starButtonAction")
 }
 
 private func animateStarFalling() {
     // Определите начальную позицию с учетом отступа от правого края
     let startX = view.frame.maxX - 35
     // Создаем анимацию падения
     let fallingAnimation = CABasicAnimation(keyPath: "position")
     fallingAnimation.duration = 1.0
     fallingAnimation.fromValue = NSValue(cgPoint: CGPoint(x: startX, y: view.frame.minY))
     fallingAnimation.toValue = NSValue(cgPoint: CGPoint(x: startX, y: view.frame.maxY))
     
     let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
     starImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
     starImageView.center = CGPoint(x: startX, y: view.frame.minY)
     view.addSubview(starImageView)
     // Применяем анимацию к звезде
     starImageView.layer.add(fallingAnimation, forKey: "fallingAnimation")
     // Удаляем звезду после завершения анимации
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
         starImageView.removeFromSuperview()
     }
 }
*/
