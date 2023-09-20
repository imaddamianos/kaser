//
//  ReviewsViewController.swift
//  kaser
//
//  Created by imad on 9/9/22.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme(View: self) { backgroundColor in
            self.view.backgroundColor = backgroundColor
            // Update other UI elements here if needed
        }
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }

}
