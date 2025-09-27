//
//  HomeViewController.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class HomeViewController: UIViewController, NetworkManager, BookmarkUpdater {

    private let searchBar = SearchBarView()
    private var bookmarks = BookmarkStore()
    private let bookmarksCollectionView = BookmarksCollectionView()
    
    private let editButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupSearchBar()
        setupCollection()
        setupEditButton()
    }

    private func setupSearchBar() {
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        searchBar.networkManager = self
    }
    
    private func setupEditButton() {
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.secondaryLabel, for: .normal)
        editButton.backgroundColor = .systemBackground
        
        editButton.layer.cornerRadius = 20
        
        editButton.layer.shadowOpacity = 0.2
        editButton.layer.shadowRadius = 2
        editButton.layer.shadowOffset = .zero
        
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: bookmarksCollectionView.bottomAnchor, constant: 16),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 80),
            editButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }
    
    private func setupCollection() {
        bookmarksCollectionView.updateBookmarks(self.bookmarks.loadBookmarks())
        
        view.addSubview(bookmarksCollectionView)
        bookmarksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookmarksCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            bookmarksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarksCollectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        bookmarksCollectionView.networkManager = self
    }
    
    @objc private func editTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 6,
                           options: [.curveEaseInOut],
                           animations: {
                sender.transform = .identity
            })
            self.bookmarksCollectionView.isEditingMode.toggle()
            self.bookmarksCollectionView.collectionView.reloadData()
        })
    }
    
    func receiveURL(url: URL?) {
        let webViewController = WebViewController()
        webViewController.bookmarksUpdater = self
        webViewController.receiveURL(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func addBookmark(_ bookmark: Bookmark) {
        bookmarks.addBookmark(bookmark)
        bookmarksCollectionView.updateBookmarks(self.bookmarks.loadBookmarks())
    }

}
