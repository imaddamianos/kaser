//
//  UIViewController+Keyboard.swift
//  kaser
//
//  Created by imps on 9/22/21.
//

import UIKit

extension UIViewController {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let activeTextField = findActiveTextField() {

            let keyboardTopY = self.view.frame.size.height - keyboardFrame.size.height
            let textFieldBottomY = activeTextField.frame.origin.y + activeTextField.frame.size.height
            let offsetY = textFieldBottomY - keyboardTopY

            if offsetY > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -offsetY)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    private func findActiveTextField() -> UITextField? {
        for subview in self.view.subviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            }
        }
        return nil
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
        self.view.layoutIfNeeded()
    }

    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
