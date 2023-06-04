//
//  UIView.swift
//  kaser
//
//  Created by UDU Jobs on 9/23/21.
//

import UIKit



extension ViewStyle where Self: UIView {

    @discardableResult func setRound() -> Self {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult func cornerRadius(cornerRadius: CGFloat) -> Self {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        return self
    }
}
