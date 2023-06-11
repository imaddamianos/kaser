//
//  MyStoreViewController.swift
//  kaser
//
//  Created by iMad on 11/06/2023.
//

import UIKit

class MyStoreViewController: UIViewController {
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
}
