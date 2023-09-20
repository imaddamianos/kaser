//
//  SideMenuViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/7/21.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    @IBAction func logOutBtn(_ sender: Any) {
        Logout()
    }

    var delegate: SideMenuViewControllerDelegate?

    var defaultHighlightedCell: Int = 0

    override func viewDidAppear(_ animated: Bool) {
//        self.sideMenuTableView.backgroundColor = UIColor.originalColor
        view.backgroundColor = UIColor.originalColor.withAlphaComponent(0.7)
        self.sideMenuTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme(View: self) { backgroundColor in
            self.view.backgroundColor = backgroundColor
            // Update other UI elements here if needed
        }
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = UIColor.black
        self.sideMenuTableView.separatorStyle = .none
//        view.backgroundColor = UIColor.originalColor
        //                     Footer
        self.footerLabel.textColor = UIColor.white
        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.footerLabel.text = "Version 1.0"

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        APICalls.shared.getUserInfo(name: newEmail!){[weak self] (isSuccess) in
            guard let StrongSelf = self else{
                return
            }
            if !isSuccess { return }
            
            sideMenu = GFunction.shared.sideMenuItems(userType: (userDetails?.userType)!)
            // Update TableView with the data
            StrongSelf.sideMenuTableView.reloadData()

        }
    }
}

func Logout(){
    DispatchQueue.main.async {
        let email = UserDefaults.standard.value(forKey: "email")
        let password = UserDefaults.standard.value(forKey: "password")
        let isSaveSelected = UserDefaults.standard.value(forKey: "isSaveSelected")
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(isSaveSelected, forKey: "isSaveSelected")
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        UIApplication.present(viewController: viewController)
    }
}


// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        performOn(.main){
            cell.iconImageView.image = sideMenu[indexPath.row].icon
            cell.titleLabel.text = sideMenu[indexPath.row].title
        }
//        cell.titleLabel.textColor = #colorLiteral(red: 0.2354828119, green: 0.2450637817, blue: 0.3699719906, alpha: 1)

        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
