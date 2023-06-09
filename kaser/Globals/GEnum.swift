//
//  GEnum.swift
//  kaser
//
//  Created by imps on 9/25/21.
//

import Foundation

enum StoryBoard : String {
    
    case main = "Main"
    case home = "HomeStoryboard"

    
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}
enum Navi : String {

    case homePage = "homePage"
}

public enum QueueType {
    case main
    case background
    case lowPriority
    case highPriority

    var queue: DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .background:
            return DispatchQueue(label: "com.app.queue",
                                 qos: .background,
                                 target: nil)
        case .lowPriority:
            return DispatchQueue.global(qos: .userInitiated)
        case .highPriority:
            return DispatchQueue.global(qos: .userInitiated)
        }
    }
}

func performOn(_ queueType: QueueType, closure: @escaping () -> Void) {
    queueType.queue.async(execute: closure)
}
