//
//  CustomTableViewCell.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 21.08.2023.
//

import SnapKit
import UIKit
import SDWebImage

final class CustomTableViewCell: UITableViewCell {
    //MARK: didSet
    var newsArticle: NewsArticle? {
        didSet {
            configure(with: newsArticle)
        }
    }
    //MARK: Properties
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        return titleLabel
    }()
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        return dateLabel
    }()
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    //MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    //MARK: Methods
    private func setupConstraints() {
        // custom Image
        addSubview(customImageView)
        customImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(80)
            make.height.equalTo(60)
        }
        // title Lable
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(customImageView.snp.leading).offset(-8)
        }
        // date Label
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    // Configure
    private func configure(with newsArticle: NewsArticle?) {
        titleLabel.text = newsArticle?.title
        titleLabel.numberOfLines = 2
        dateLabel.text = newsArticle?.publishedDate
        // set image
        setImageFromThumbnailURL(newsArticle?.mediaMetadata.first?.url)
    }
    // setImageFromThumbnailURL
    private func setImageFromThumbnailURL(_ thumbnailURL: String?) {
        guard let thumbnailURL = thumbnailURL, let url = URL(string: thumbnailURL) else {
            return
        }
        customImageView.sd_setImage(with: url) { [weak self] (image, error, cacheType, imageURL) in
            guard let self = self, error == nil, let image = image else {
                return
            }
            self.customImageView.image = image
        }
    }
}
