//
//  HomeVcPresenter.swift
//  kaser
//
//  Created by imps on 11/29/21.
//

import Foundation

protocol HomeVcProtocol: AnyObject {
    
}

class HomeVcPresenter{
    
    weak var view: HomeVcProtocol?
    init(view: HomeVcProtocol) {
        self.view = view
    }
    
    var items: [FeaturesModel] = [
        FeaturesModel(icon: UIImage(named: "post1")!),
        FeaturesModel(icon: UIImage(named: "post2")!),
        FeaturesModel(icon: UIImage(named: "post3")!),
        FeaturesModel(icon: UIImage(systemName: "person.fill")!),
        FeaturesModel(icon: UIImage(systemName: "slider.horizontal.3")!)
//        SideMenuModel(icon: UIImage(systemName: "music.note")!, title: "Settings")
    ]
    
}
