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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupSearchBar()
        setupCollection()
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
