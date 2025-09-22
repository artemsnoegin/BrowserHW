//
//  HomeViewController.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class HomeViewController: UIViewController, MessageReceiver {

    private let searchBar = SearchBarView()
    private var bookmarks = Bookmarks()
    
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
        
        searchBar.messageReceiver = self
    }
    
    private func setupCollection() {
        let bookmarksCollectionView = BookmarksCollectionView(bookmarks: bookmarks.loadBookmarks())
        
        view.addSubview(bookmarksCollectionView)
        bookmarksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookmarksCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            bookmarksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookmarksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        bookmarksCollectionView.layer.cornerRadius = 12
        
        bookmarksCollectionView.messageReceiver = self
    }
    
    func receiveMessage(message: String) {
        navigationController?.pushViewController(WebViewController(urlString: message, bookmarks: bookmarks.loadBookmarks()), animated: true)
    }

}
