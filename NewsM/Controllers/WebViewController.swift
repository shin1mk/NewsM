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
    var articleURL: URL?
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
        if let url = articleURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    //    // create star button
    //    private func starButton() {
    //        // Создаем кнопку с изображением звездочки или звездочки с заливкой в зависимости от состояния
    //        let starImage = isStarred ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    //        let starButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(starButtonAction))
    //        navigationItem.rightBarButtonItems = [starButton]
    //    }
    //
    //    // star button action
    //    @objc private func starButtonAction() {
    //        isStarred.toggle() // Инвертируем состояние кнопки при нажатии
    //        starButton() // Обновляем кнопку с новым изображением
    //        print("starButtonAction")
    //        // Добавьте здесь код для обработки нажатия на звездочку
    //    }
    //MARK: StarButton
    private func starButton() {
        let starButton = UIBarButtonItem(image: UIImage(systemName: isStarred ? "star.fill" : "star"), style: .plain, target: self, action: #selector(starButtonAction))
        navigationItem.rightBarButtonItems = [starButton]
    }
    // star button action
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
    // star animation
    private func animateStarFalling() {
        // Создаем анимацию падения
        let fallingAnimation = CABasicAnimation(keyPath: "position.y")
        fallingAnimation.duration = 1.0 // Длительность анимации
        fallingAnimation.fromValue = view.frame.minY // Начальная позиция анимации (верх экрана)
        fallingAnimation.toValue = view.frame.maxY // Конечная позиция анимации (низ экрана)
        
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
        starImageView.frame = CGRect(x: view.center.x, y: view.frame.minY, width: 30, height: 30)
        view.addSubview(starImageView)
        
        // Применяем анимацию к звезде
        starImageView.layer.add(fallingAnimation, forKey: "fallingAnimation")
        
        // Удаляем звезду после завершения анимации
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            starImageView.removeFromSuperview()
        }
    }
}

