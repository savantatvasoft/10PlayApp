
//
//  LoadingOverlayView.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import UIKit

class LoadingOverlayView: UIView {
    
    // 1. Medium Activity Indicator (Smaller height)
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemRed
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let containerView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 20
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.12
            view.layer.shadowOffset = CGSize(width: 0, height: 8)
            view.layer.shadowRadius = 12
            return view
        }()
    
    init(message: String?, isTransparent: Bool) {
            super.init(frame: .zero)
            
            // Background and Shadow logic
            if isTransparent {
                containerView.backgroundColor = .clear
                containerView.layer.shadowOpacity = 0 // Hide shadow if transparent
            } else {
                containerView.backgroundColor = .white
                containerView.layer.shadowOpacity = 0.12
            }
            
            // Handle Optional Message
            if let message = message {
                self.messageLabel.text = message
                self.messageLabel.isHidden = false
            } else {
                self.messageLabel.isHidden = true
            }
            
            setupLayout()
        }
    
    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        backgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        addSubview(containerView)
        contentStack.addArrangedSubview(activityIndicator)
        contentStack.addArrangedSubview(messageLabel)
        containerView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            // ✨ Reduced Height & Width
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            containerView.widthAnchor.constraint(equalToConstant: 160),
            containerView.heightAnchor.constraint(equalToConstant: 80),
            activityIndicator.heightAnchor.constraint(equalToConstant: 30),
            activityIndicator.widthAnchor.constraint(equalToConstant: 30),
            
            // Content Alignment
            contentStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

}
