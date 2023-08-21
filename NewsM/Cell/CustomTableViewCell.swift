//
//  CustomTableViewCell.swift
//  NewsM
//
//  Created by SHIN MIKHAIL on 21.08.2023.
//

import SnapKit
import UIKit

class CustomTableViewCell: UITableViewCell {
    var articleURL: URL?
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
