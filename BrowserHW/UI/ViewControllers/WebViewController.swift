//
//  WebViewController.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController, MessageReceiver {

    private var webView = WKWebView()
    private let searchBar = SearchBarView()
    
    private var backButton = UIBarButtonItem()
    private var forwardButton = UIBarButtonItem()
    private var webPageActionButton = UIBarButtonItem()
    private var addBookmarkButton = UIBarButtonItem()
    
    private var urlString: String
    
    init(urlString: String, bookmarks: [Bookmark]) {
        self.urlString = urlString
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .tertiarySystemBackground
            
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
        searchBar.messageReceiver = self
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
        
        addBookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(addBookmark))
        
        webPageActionButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(webPageAction))
        
        toolbarItems = [
            backButton, UIBarButtonItem.flexibleSpace(),
            forwardButton, UIBarButtonItem.flexibleSpace(),
            addBookmarkButton, UIBarButtonItem.flexibleSpace(),
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
    
    @objc private func addBookmark() {
//        bookmarks.append(Bookmark(icon: UIImage(systemName: "book"), title: "new", urlString: urlString))
    }
    
    func receiveMessage(message: String) {
        self.urlString = message
        loadRequest()
    }
    
    private func loadRequest() {
        var urlStringToLoad = urlString
        
        if !urlStringToLoad.hasPrefix("https://") {
            urlStringToLoad = "https://" + urlStringToLoad
        }
        
        guard let url = URL(string: urlStringToLoad) else { return }
        webView.load(URLRequest(url: url))
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        webPageActionButton.image = UIImage(systemName: "xmark")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webPageActionButton.image = UIImage(systemName: "arrow.clockwise")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        
        webPageActionButton.image = UIImage(systemName: "arrow.clockwise")
    }
    
}
