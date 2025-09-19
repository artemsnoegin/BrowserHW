//
//  WebViewController.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private var webView = WKWebView()
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let rootView = UIView()
        
        webView.backgroundColor = .systemBackground
        
        rootView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
        ])
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
