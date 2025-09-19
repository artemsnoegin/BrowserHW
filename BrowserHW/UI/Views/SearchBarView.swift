//
//  SearchBarView.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class SearchBarView: UIView, UITextFieldDelegate {
    
    private let searchField = UITextField()
    var search: ((String) -> ())?
    
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
        searchField.delegate = self
        
        let searchButton = UIButton(type: .system)
        searchButton.setContentHuggingPriority(.required, for: .horizontal)
        searchButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchURl), for: .touchUpInside)
        
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
        guard let urlString = searchField.text else { return }
        search?(urlString)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        hideKeyboardOnTap()
    }
    
    private func hideKeyboardOnTap() {
        guard let superview = superview else { return }
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(hideKeyboard))
        
        superview.addGestureRecognizer(gesture)
    }
    
    @objc private func hideKeyboard() {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let urlString = textField.text, !urlString.isEmpty else { return false }
        
        textField.resignFirstResponder()
        search?(urlString)
        
        return true
    }
    
}
