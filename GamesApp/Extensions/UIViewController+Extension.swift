//
//  UIViewController+Extension.swift
//  GamesApp
//
//  Created by Yunus Emre ÖZŞAHİN on 20.05.2024.
//

import UIKit

extension UIViewController {
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

