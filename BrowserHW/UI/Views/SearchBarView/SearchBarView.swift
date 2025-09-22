//
//  SearchBarView.swift
//  BrowserHW
//
//  Created by Артём Сноегин on 19.09.2025.
//

import UIKit

class SearchBarView: UIView, UITextFieldDelegate {
    
    private let searchField = UITextField()
    private let barButton = UIButton(type: .system)
    
    weak var messageReceiver: MessageReceiver?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(blurView)
            sendSubviewToBack(blurView)
            
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: topAnchor),
                blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        searchField.placeholder = "URL"
        searchField.keyboardType = .URL
        searchField.returnKeyType = .search
        searchField.autocapitalizationType = .none
        searchField.delegate = self
        
        barButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        barButton.setContentHuggingPriority(.required, for: .horizontal)
        barButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        barButton.addTarget(self, action: #selector(didTapBarButton), for: .touchUpInside)
        
        barButton.isEnabled = false
        
        let hStack = UIStackView(arrangedSubviews: [searchField, barButton])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.backgroundColor = .tertiarySystemBackground.withAlphaComponent(0.7)
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        hStack.layer.cornerRadius = 12
        hStack.layer.shadowOffset = .zero
        hStack.layer.shadowOpacity = 0.1
        hStack.layer.shadowRadius = 2.5
        
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
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
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        hideKeyboardOnTap()
    }
    
    private func sendUrlString() {
        guard let urlString = searchField.text, !urlString.isEmpty else { return }
        messageReceiver?.receiveMessage(message: urlString)
    }
    
    @objc private func didTapBarButton() {
        sendUrlString()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        sendUrlString()
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            barButton.isEnabled = false
        } else {
            barButton.isEnabled = true
        }
    }
    
}
