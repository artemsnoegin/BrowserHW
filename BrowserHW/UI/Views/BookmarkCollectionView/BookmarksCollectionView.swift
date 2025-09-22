//
//  BookmarksCollectionView.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class BookmarksCollectionView: UIView {
    
    private let bookmarks: [Bookmark]
    private let collectionView: UICollectionView
    
    weak var messageReceiver: MessageReceiver?
    
    init(bookmarks: [Bookmark]) {
        self.bookmarks = bookmarks
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.register(
            BookmarksHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BookmarksHeaderView.reuseIdentifier
        )
        
        collectionView.register(
            BookmarkCollectionViewCell.self,
            forCellWithReuseIdentifier: BookmarkCollectionViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.layer.cornerRadius = 24
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        collectionView.clipsToBounds = true
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateHeight(maxHeight: CGFloat) {
            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            if contentHeight < maxHeight {
                collectionView.isScrollEnabled = false
                collectionView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
            } else {
                collectionView.isScrollEnabled = true
                collectionView.heightAnchor.constraint(equalToConstant: maxHeight).isActive = true
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            guard let superview = superview else { return updateHeight(maxHeight: 400) }

            updateHeight(maxHeight: superview.frame.height / 2)
        }
    
}

extension BookmarksCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BookmarksHeaderView.reuseIdentifier,
                for: indexPath
            ) as! BookmarksHeaderView
            header.configure(text: "Bookmarks")
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookmarkCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! BookmarkCollectionViewCell
        
        cell.configure(bookmark: bookmarks[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString = bookmarks[indexPath.item].urlString
        
        if !urlString.isEmpty {
            messageReceiver?.receiveMessage(message: urlString)
        }
    }
}

extension BookmarksCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let padding: CGFloat = 16
        let totalPaddingWidth = padding * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - totalPaddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 32) // (font size + title topAnchor) * 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    
}
