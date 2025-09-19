//
//  SearchBarView.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class SearchBarView: UIView, UITextFieldDelegate {
    
    private let searchField = UITextField()
    private let searchButton = UIButton(type: .system)
    
    weak var webSearchDelegate: WebSearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGroupedBackground
        
        searchField.placeholder = "URL"
        searchField.keyboardType = .URL
        searchField.returnKeyType = .search
        searchField.autocapitalizationType = .none
        searchField.delegate = self
        
        searchButton.setContentHuggingPriority(.required, for: .horizontal)
        searchButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchURl), for: .touchUpInside)
        
        searchButton.isEnabled = false
        
        let hStack = UIStackView(arrangedSubviews: [searchField, searchButton])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.backgroundColor = .tertiarySystemBackground
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        hStack.layer.cornerRadius = 12
        
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    @objc private func searchURl() {
        guard let urlString = searchField.text, !urlString.isEmpty else { return }
        webSearchDelegate?.search(urlString: urlString)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        hideKeyboardOnTap()
    }
    
    private func hideKeyboardOnTap() {
        guard let superview = superview else { return }
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        
        superview.addGestureRecognizer(gesture)
    }
    
    @objc private func hideKeyboard() {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let urlString = textField.text, !urlString.isEmpty else { return false }
        
        textField.resignFirstResponder()
        webSearchDelegate?.search(urlString: urlString)
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            searchButton.isEnabled = false
        } else {
            searchButton.isEnabled = true
        }
    }
    
}
