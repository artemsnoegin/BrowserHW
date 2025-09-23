//
//  BookmarksStore.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 22.09.2025.
//

import UIKit

class BookmarkStore {
    
    private var bookmarks = [Bookmark(icon: UIImage(systemName: "book"), title: "Apple",
                                      pageURL: URL(string: "https://apple.com")),
                             Bookmark(icon: UIImage(systemName: "book"), title: "Google",
                                      pageURL: URL(string: "https://google.com")),
                             Bookmark(icon: UIImage(systemName: "book"), title: "OpenAI",
                                      pageURL: URL(string: "https://openai.com")),
                             Bookmark(icon: UIImage(systemName: "book"), title: "Yandex",
                                      pageURL: URL(string:"https://yandex.ru")),]
    
    func loadBookmarks() -> [Bookmark] {
        
        return self.bookmarks
    }
    
    func addBookmark(_ bookmark: Bookmark) {
        bookmarks.append(bookmark)
    }
    
}
