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
    @IBOutlet weak var addProductsBtn: UIButton!
    
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
    @IBAction func addProductsTapped(_ sender: Any) {
        
    }
    
    func setupView() {
        myProductsTbl.dataSource = self
        myProductsTbl.delegate = self
        myProductsTbl.register(MyProductsTableViewCell.nib, forCellReuseIdentifier: MyProductsTableViewCell.identifier)
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        sideMenu = GFunction.shared.sideMenuItems()
        
        for index in 0..<storesArray.count {
            let store = storesArray[index]
            let storeOwner = store.storeOwner
            let storeName = store.storeName
            let storeLocation = store.delivery
            let storeAddress = store.address
            updateStoreHeader(storeName: storeName, storeOwner: storeOwner, storeLocation: storeLocation, storeAddress: storeAddress)
            
            // Use the storeOwner value as needed
            print("Store owner for index \(storesArray[index].storeName): \(storeOwner)")
        }

        updateStoreHeader(storeName: "", storeOwner: "", storeLocation: "", storeAddress: "")
        myProductsTbl.reloadData()
    }
    
    func updateStoreHeader(storeName: String, storeOwner: String, storeLocation: String, storeAddress: String){
        if !storeName.isEmpty {
//        if storeName != {
            storeNameLbl.text = "Store Name: " + storeName
            storeNbLbl.text = "Store Location: " + storeLocation
            locationLbl.text = "Store Address: " + storeAddress
            reviewsLbl.text = "Store Owner: " + storeOwner
            addStoreBtn.isHidden = true
        }else{
            addStoreBtn.isHidden = false
            storeNameLbl.isHidden = true
            storeNbLbl.isHidden = true
            locationLbl.isHidden = true
            reviewsLbl.isHidden = true
        }
        
        
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
