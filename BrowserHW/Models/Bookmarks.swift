//
//  DataStore.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 22.09.2025.
//

import UIKit

class Bookmarks {
    
    private var bookmarks = [Bookmark(icon: UIImage(systemName: "book"), title: "Apple",
                                      urlString: "https://apple.com"),
                             Bookmark(icon: UIImage(systemName: "book"), title: "Google",
                                      urlString: "https://google.com"),
                             Bookmark(icon: UIImage(systemName: "book"), title: "Test errors and large titles",
                                      urlString: "error test"),
                             Bookmark(icon: UIImage(systemName: "book"), title: "OpenAI",
                                      urlString: "https://openai.com"),
                             Bookmark(icon: UIImage(systemName: "book"), title: "Yandex",
                                      urlString: "https://yandex.ru"),
                             Bookmark(icon: UIImage(systemName: "book"), title: "Apple",
                                      urlString: "https://apple.com"),
                             Bookmark(icon: UIImage(systemName: "book"), title: "Apple",
                                      urlString: "https://apple.com"),]
    
    func loadBookmarks() -> [Bookmark] {
        
        return self.bookmarks
    }
    
}
