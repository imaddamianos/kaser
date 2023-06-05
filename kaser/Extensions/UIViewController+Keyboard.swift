//
//  UIViewController+Keyboard.swift
//  kaser
//
//  Created by imps on 9/22/21.
//

import UIKit

extension UIViewController{
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
