//
//  HomeViewController.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    let searchBar = SearchBarView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        
        configureSearchBar()
        configureCollection()
    }

    private func configureSearchBar() {
        searchBar.search = { urlString in
            if !urlString.isEmpty {
                self.navigationController?.pushViewController(WebViewController(urlString: urlString), animated: true)
            }
        }
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureCollection() {
        let bookmarks = [Bookmark(icon: UIImage(systemName: "book"), title: "Apple has not been implemented"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "Google"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "TMS"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "OpenAI"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "Yandex")]
        
        let bookmarksCollectionView = BookmarksCollectionView(bookmarks: bookmarks)
        
        view.addSubview(bookmarksCollectionView)
        bookmarksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookmarksCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            bookmarksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
