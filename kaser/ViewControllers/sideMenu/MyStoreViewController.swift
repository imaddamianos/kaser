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
    var storeName: String?
    var imageCache: NSCache<NSString, UIImage> = NSCache()
    var storeOwnerValue: String?
    
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
        self.performSegue(withIdentifier: "AddProductsNavID", sender: self)
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
            if store.storeOwner == newEmail{
                
                let storeOwner = store.storeOwner
                self.storeName = store.storeName
                let storeLocation = store.delivery
                let storeAddress = store.address
                let storeImage = store.storeImage
                updateStoreHeader(storeName: self.storeName!, storeOwner: storeOwner, storeLocation: storeLocation, storeAddress: storeAddress, storeImage: storeImage)
                getProducts()
            }else{
                updateStoreHeader(storeName: "", storeOwner: "", storeLocation: "", storeAddress: "", storeImage: "")
            }
        }
        
//        if storesArray.isEmpty{
//            
//        }else{
//            
//        }
    }
    
    func getProducts(){
        APICalls.shared.getProducts(store: self.storeName ?? "") { success in
            for store in storesArray {
                let storeOwner = store.storeOwner
                
            }
        }
    }
    
    func handleProductsFetchResult(success: Bool) {
        if success {
            myProductsTbl.reloadData()
            print(productsArray)
        } else {
            // Error occurred while fetching products
            print("Failed to fetch products.")
        }
    }
    
    func updateStoreHeader(storeName: String, storeOwner: String, storeLocation: String, storeAddress: String, storeImage: String){
        if !storeName.isEmpty {
            storeNameLbl.text = "Store Name: " + storeName
            storeNbLbl.text = "Store Location: " + storeLocation
            locationLbl.text = "Store Address: " + storeAddress
            reviewsLbl.text = "Store Owner: " + storeOwner
            addStoreBtn.isHidden = true
            addProductsBtn.isHidden = false
            GFunction.shared.loadImageAsync(from: URL(string: (storeImage)), into: (self.coverImg)!)
        }else{
            addStoreBtn.isHidden = false
            storeNameLbl.isHidden = true
            storeNbLbl.isHidden = true
            locationLbl.isHidden = true
            reviewsLbl.isHidden = true
            addProductsBtn.isHidden = true
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AddProductsNavID",
               let destinationVC = segue.destination as? AddProductsViewController {
                // Set the value you want to pass to the destination view controller
                destinationVC.storeName = storeName
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
        return productsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProductsTableViewCell.identifier, for: indexPath) as? MyProductsTableViewCell else { fatalError("xib doesn't exist") }
//            cell.iconImageView.image = productsArray[indexPath.row].productImage
        cell.titleLabel.text = productsArray[indexPath.row].productName
        cell.priceLbl.text = productsArray[indexPath.row].productOwner
        cell.locationLbl.text = productsArray[indexPath.row].brand
        cell.descriptionLbl.text = productsArray[indexPath.row].description
        cell.storeLbl.text = productsArray[indexPath.row].productOwner
        
        if let cachedImage = imageCache.object(forKey: productsArray[indexPath.row].productImage as NSString) {
            // If the image is already cached, use it
            cell.iconImageView.image = cachedImage
        } else {
            // Image not cached, fetch asynchronously
            GFunction.shared.loadImageAsync(from: URL(string: (productsArray[indexPath.row].productImage)), into: (cell.iconImageView)!)
        }
        
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
