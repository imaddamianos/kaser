//
//  SettingsViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/9/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var themeModeLbl: UILabel!
    @IBOutlet weak var lightLbl: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var darkLbl: UILabel!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
                sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        ThemeManager.shared.toggleTheme()
        applyTheme(View: self) { backgroundColor in
            self.view.backgroundColor = backgroundColor
            if ThemeManager.shared.currentTheme == .dark {
                self.lightLbl.textColor = UIColor.white
                self.darkLbl.textColor = UIColor.white
                self.themeModeLbl.textColor = UIColor.white
            }else{
                self.lightLbl.textColor = UIColor.black
                self.darkLbl.textColor = UIColor.black
                self.themeModeLbl.textColor = UIColor.black
            }
        }
            NotificationCenter.default.post(name: Notification.Name("ThemeDidChange"), object: nil)
    }
}
