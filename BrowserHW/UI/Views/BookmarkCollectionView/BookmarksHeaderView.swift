//
//  BookmarksHeaderView.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class BookmarksHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "BookmarksHeaderView"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .label
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
}
