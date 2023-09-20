//
//  FavoriteViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/9/21.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme(View: self)
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
}
