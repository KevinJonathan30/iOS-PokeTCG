//
//  UICollectionViewExtension.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 19/03/23.
//

import UIKit

extension UICollectionView {
    func setEmptyState(_ message: String? = nil) {
        if let message = message {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .white
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            messageLabel.sizeToFit()
            
            self.backgroundView = messageLabel
        } else {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            activityIndicator.startAnimating()
            activityIndicator.color = .white
            
            self.backgroundView = activityIndicator
        }
    }
    
    func setLoadedState() {
        self.backgroundView = nil
    }
}
