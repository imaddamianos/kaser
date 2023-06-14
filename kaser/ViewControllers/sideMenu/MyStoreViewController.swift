//
//  MyStoreViewController.swift
//  kaser
//
//  Created by iMad on 11/06/2023.
//

import UIKit

class MyStoreViewController: UIViewController{

    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeNbLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var reviewsLbl: UILabel!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var myProductsTbl: UITableView!
    @IBOutlet weak var addStoreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    
    @IBAction func addStoreTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AddStoreNavID", sender: self)
    }
    
    func setupView() {
        myProductsTbl.dataSource = self
        myProductsTbl.delegate = self
        myProductsTbl.register(MyProductsTableViewCell.nib, forCellReuseIdentifier: MyProductsTableViewCell.identifier)
        
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        sideMenu = GFunction.shared.sideMenuItems()
        myProductsTbl.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension MyStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // Adjust the height to your desired value
    }
}

// MARK: - UITableViewDataSource

extension MyStoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProductsTableViewCell.identifier, for: indexPath) as? MyProductsTableViewCell else { fatalError("xib doesn't exist") }
            cell.iconImageView.image = sideMenu[indexPath.row].icon
            cell.titleLabel.text = sideMenu[indexPath.row].title
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        self.delegate?.selectedCell(indexPath.row)
//        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
//        if indexPath.row == 4 || indexPath.row == 6 {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
}
