//
//  SettingsViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/9/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme(View: self)
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        ThemeManager.shared.toggleTheme()
            // Notify all view controllers to update their themes
            NotificationCenter.default.post(name: Notification.Name("ThemeDidChange"), object: nil)
    }
}
