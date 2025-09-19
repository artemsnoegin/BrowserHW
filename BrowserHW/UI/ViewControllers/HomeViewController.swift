//
//  HomeViewController.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class HomeViewController: UIViewController, WebSearchDelegate {

    let searchBar = SearchBarView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        
        configureSearchBar()
        configureCollection()
    }

    private func configureSearchBar() {
        searchBar.webSearchDelegate = self
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureCollection() {
        let bookmarks = [Bookmark(icon: UIImage(systemName: "book"), title: "Apple",
                                  urlString: "https://apple.com"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "Google",
                                 urlString: "https://google.com"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "Test errors and large titles",
                                 urlString: "error test"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "OpenAI",
                                 urlString: "https://openai.com"),
                         Bookmark(icon: UIImage(systemName: "book"), title: "Yandex",
                                 urlString: "https://yandex.ru")]
        
        let bookmarksCollectionView = BookmarksCollectionView(bookmarks: bookmarks)
        bookmarksCollectionView.webSearchDelegate = self
        
        view.addSubview(bookmarksCollectionView)
        bookmarksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookmarksCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            bookmarksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func search(urlString: String) {
        navigationController?.pushViewController(WebViewController(urlString: urlString), animated: true)
    }

}
