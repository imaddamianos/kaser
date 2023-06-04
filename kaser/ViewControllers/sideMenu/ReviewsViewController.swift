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

        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }

}
