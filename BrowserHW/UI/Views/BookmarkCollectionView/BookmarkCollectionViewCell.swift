//
//  BookmarkCollectionViewCell.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BookmarkCollectionViewCell"
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    
    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(bookmark: Bookmark) {
        iconView.image = bookmark.icon
        titleLabel.text = bookmark.title
    }
    
    private func setupUI() {
        let iconBackgroundView = UIView()
        iconBackgroundView.backgroundColor = .secondarySystemGroupedBackground
        iconBackgroundView.layer.cornerRadius = 12
        iconBackgroundView.layer.shadowOpacity = 0.1
        iconBackgroundView.layer.shadowRadius = 2.5
        iconBackgroundView.layer.shadowOffset = .zero
        contentView.addSubview(iconBackgroundView)
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.contentMode = .scaleAspectFit
        iconBackgroundView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .boldSystemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconBackgroundView.heightAnchor.constraint(equalTo: iconBackgroundView.widthAnchor),
            
            iconView.topAnchor.constraint(equalTo: iconBackgroundView.topAnchor, constant: 8),
            iconView.leadingAnchor.constraint(equalTo: iconBackgroundView.leadingAnchor, constant: 8),
            iconView.trailingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: -8),
            iconView.bottomAnchor.constraint(equalTo: iconBackgroundView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: iconBackgroundView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
