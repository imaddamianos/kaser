//
//  UIViewController.swift
//  kaser
//
//  Created by imps on 9/25/21.
//

import Foundation
@_exported import AVFoundation
@_exported import AVKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: StoryBoard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}
