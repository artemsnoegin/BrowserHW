//
//  WebViewController.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController, NetworkManager {

    private var webView = WKWebView()
    private let searchBar = SearchBarView()
    
    private var backButton = UIBarButtonItem()
    private var forwardButton = UIBarButtonItem()
    private var webPageActionButton = UIBarButtonItem()
    private var bookmarkButton = UIBarButtonItem()
    
    weak var bookmarksUpdater: BookmarkUpdater?
    
    private var pageURL: URL?
    private var pageTitle: String?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemGroupedBackground
            
            setupWebView()
            setupSearchBar()
            setupToolBar()
            loadRequest()
        }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        webView.navigationDelegate = self
    }
    
    private func setupSearchBar() {
        searchBar.networkManager = self
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupToolBar() {
        backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBack))
        
        forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: self, action: #selector(goForward))
        forwardButton.isEnabled = webView.canGoForward
        
        bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(didTapOnBookmark))
        
        webPageActionButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(webPageAction))
        
        toolbarItems = [
            backButton, UIBarButtonItem.flexibleSpace(),
            forwardButton, UIBarButtonItem.flexibleSpace(),
            bookmarkButton, UIBarButtonItem.flexibleSpace(),
            webPageActionButton
        ]
        
        navigationController?.isToolbarHidden = false
        
        if let toolbar = navigationController?.toolbar {
            let appearance = UIToolbarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            toolbar.standardAppearance = appearance
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.scrollView.contentInset.top = searchBar.frame.maxY
        webView.scrollView.contentInset.bottom = view.safeAreaInsets.bottom
        webView.scrollView.verticalScrollIndicatorInsets.top = searchBar.frame.maxY - view.safeAreaInsets.top
    }
    
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc private func webPageAction() {
        if webView.isLoading {
            webView.stopLoading()
        } else {
            webView.reload()
        }
    }
    
    @objc private func didTapOnBookmark() {
        bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        
        showBookmarkAlert()
    }
    
    private func showBookmarkAlert() {
        let alert = UIAlertController(title: "Bookmarks", message: nil, preferredStyle: .actionSheet)
        
        let addNewBookmarkAction = UIAlertAction(title: "Add new bookmark", style: .default) { _ in
            
            self.showNewBookmarkAlert()
        }
        alert.addAction(addNewBookmarkAction)
        
        let showBookmarksAction = UIAlertAction(title: "Show bookmarks", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
            self.bookmarkButton.image = UIImage(systemName: "bookmark")
        }
        alert.addAction(showBookmarksAction)
        
        present(alert, animated: true)
    }
    
    private func showNewBookmarkAlert() {
        let alert = UIAlertController(title: "New Bookmark", message: nil, preferredStyle: .alert)
        
        alert.addTextField { title in
            title.placeholder = "Title"
            title.text = self.pageTitle
        }
        
        alert.addTextField { url in
            url.placeholder = "URL"
            url.text = self.pageURL?.absoluteString
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .cancel) { _ in
            let title = alert.textFields?[0].text ?? "New Bookmark"
            let url = URL(string: alert.textFields?[1].text ?? "")
            let newBookmark = Bookmark(icon: UIImage(), title: title, pageURL: url)
            self.bookmarksUpdater?.addBookmark(newBookmark)
            
            self.bookmarkButton.image = UIImage(systemName: "bookmark")
        }
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
    }
    
    func receiveURL(url: URL?) {
        self.pageURL = url
        loadRequest()
    }
    
    private func loadRequest() {
        guard let url = pageURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func getInfo() {
        webView.evaluateJavaScript("document.title") { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let title = result as? String {
                self.searchBar.updatePlaceholder(text: title)
                self.pageTitle = title
            }
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        searchBar.updatePlaceholder(text: pageURL?.absoluteString ?? "Loading...")
        webPageActionButton.image = UIImage(systemName: "xmark")
        pageURL = webView.url
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webPageActionButton.image = UIImage(systemName: "arrow.clockwise")
        pageURL = webView.url
        getInfo()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        
        webPageActionButton.image = UIImage(systemName: "arrow.clockwise")
    }
    
}
