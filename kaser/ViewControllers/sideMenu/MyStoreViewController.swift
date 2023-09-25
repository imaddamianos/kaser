//
//  MyStoreViewController.swift
//  kaser
//
//  Created by iMad on 11/06/2023.
//

import UIKit

class MyStoreViewController: UIViewController{

    @IBOutlet weak var stackInfo: UIStackView!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeNbLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var storePriceLbl: UILabel!
    @IBOutlet weak var storeDescriptionLbl: UILabel!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var myProductsTbl: UITableView!
    @IBOutlet weak var addStoreBtn: UIButton!
    @IBOutlet weak var addProductsBtn: UIButton!
    var storeName: String?
    var storeOwnerValue: String?
    var store: Store?
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    
    @IBAction func addStoreTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AddStoreNavID", sender: self)
    }
    @IBAction func addProductsTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AddProductsNavID", sender: self)
    }
    @IBAction func editStoreBtnTapped(_ sender: Any) {
        // Create a UIAlertController with a preferred style of .alert
        let alertController = UIAlertController(title: "Edit Store", message: nil, preferredStyle: .alert)
        
        // Add text fields to the alert controller for user input
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Store Name"
        }
        
        alertController.addTextField { (locationTextField) in
            locationTextField.placeholder = "Location"
        }
        
        alertController.addTextField { (descriptionTextField) in
            descriptionTextField.placeholder = "Description"
        }
        
        alertController.addTextField { (priceTextField) in
            priceTextField.placeholder = "Price"
            priceTextField.keyboardType = .decimalPad // Use decimal pad for price
        }
        
        alertController.addTextField { (numberTextField) in
            numberTextField.placeholder = "Number"
            numberTextField.keyboardType = .numberPad // Use number pad for number
        }
        
        // Add "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Add "Save" action
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (_) in
            // Retrieve text field values
            if let nameField = alertController.textFields?[0],
               let locationField = alertController.textFields?[1],
               let descriptionField = alertController.textFields?[2],
               let priceField = alertController.textFields?[3],
               let numberField = alertController.textFields?[4],
               let storeName = nameField.text,
               let location = locationField.text,
               let description = descriptionField.text,
               let priceText = priceField.text,
               let numberText = numberField.text,
               let price = Double(priceText), // Convert price to a Double
               let number = Int(numberText) // Convert number to an Int
            {
                // Use the retrieved values as needed
                // Here, you can update your data model or perform any necessary actions
                
                // Example: Update UI labels with the retrieved values
                self?.storeNameLbl.text = storeName
                self?.locationLbl.text = location
                self?.storeDescriptionLbl.text = description
                self?.storePriceLbl.text = String(format: "$%.2f", price)
//                self?.storePriceLbl.text = String(number)
            }
        }
        alertController.addAction(saveAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    
    
    @objc func productsCellTapped(_ sender: UITapGestureRecognizer) {
        // Handle cell tap here
        if let cell = sender.view as? UITableViewCell {
            if let indexPath = myProductsTbl.indexPath(for: cell) {
                let product = productsArray[indexPath.row]
                self.product = product
                self.performSegue(withIdentifier: "ProductDetailsNavID", sender: self)
                
            }
        }
    }
    
    func setupView() {
        changeNavBarColor()
        myProductsTbl.dataSource = self
        myProductsTbl.delegate = self
        myProductsTbl.register(MyProductsTableViewCell.nib, forCellReuseIdentifier: MyProductsTableViewCell.identifier)
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        addStoreBtn.cornerRadius(cornerRadius: 15)
        addProductsBtn.cornerRadius(cornerRadius: 15)
        GFunction.shared.addBlurBackground(toView: stackInfo)
        
        // Check if there's a store associated with the user
              if let userStore = storesArray.first(where: { $0.storeOwner == newEmail }) {
                  self.store = userStore
                  storeName = userStore.storeName
                  storeOwnerValue = userStore.storeOwner
                  let storePrice = userStore.delivery
                  let storeAddress = userStore.LocationName!
                  let storeImage = userStore.storeImage
                  let storeDescription = userStore.description
                  let storeNumber = userStore.phone
//                  let storePrice = userStore.delivery
                  
//                  updateStoreHeader(storeName: storeName!, storeOwner: storeOwnerValue ?? "", storeLocation: storeLocation, storeAddress: storeAddress!, storeImage: storeImage)
                  updateStoreHeader(storeName: storeName!, storeOwner: storeOwnerValue ?? "", storeNumber: storeNumber, storeAddress: storeAddress, storeDescription: storeDescription, storePrice: storePrice, storeImage: storeImage)
                  
                  // Fetch products associated with the user's store
                  getProducts { [weak self] success in
                          self?.myProductsTbl.reloadData()
                  }
              } else {
                  // No store associated with the user, handle accordingly
                  updateStoreHeader(storeName: "", storeOwner: "", storeNumber: "", storeAddress: "", storeDescription: "", storePrice: "", storeImage: "")
                  productsArray.removeAll()
              }
          }
    
    func changeNavBarColor() {
        
        if ThemeManager.shared.currentTheme == .dark {
            navigationController?.navigationBar.backgroundColor = UIColor.black
            view.backgroundColor = UIColor.black
        } else {
            navigationController?.navigationBar.backgroundColor = UIColor.white
            view.backgroundColor = UIColor.white
        }
        
    }



    
    func getProducts(completion: @escaping (Bool) -> Void) {
        APICalls.shared.getProducts(store: self.storeName ?? "") { success in
            for product in productsArray {
                let productOwner = product.productOwner
                if productOwner == newEmail {
                    self.handleProductsFetchResult(success: true)
                    break
                }
            }
            completion(true)
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
    
    func updateStoreHeader(storeName: String, storeOwner: String, storeNumber: String, storeAddress: String,storeDescription: String,storePrice: String, storeImage: String){
        if storeOwnerValue == newEmail {
            storeNameLbl.text = "Name: \(storeName)"
            storeNbLbl.text = "Phone: \(storeNumber)"
            locationLbl.text = "Address: \(storeAddress)"
            storeDescriptionLbl.text = "Description: \(storeDescription)"
            storePriceLbl.text = "Price: \(storePrice) $"
            storeNameLbl.isHidden = false
            storeNbLbl.isHidden = false
            locationLbl.isHidden = false
            addStoreBtn.isHidden = true
//            reviewsLbl.isHidden = false
            addProductsBtn.isHidden = false
            GFunction.shared.loadImageAsync(from: URL(string: (storeImage)), into: (self.coverImg)!)
        }else{
            addStoreBtn.isHidden = false
            storeNameLbl.isHidden = true
            storeNbLbl.isHidden = true
            locationLbl.isHidden = true
//            reviewsLbl.isHidden = true
            addProductsBtn.isHidden = true
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AddProductsNavID",
               let destinationVC = segue.destination as? AddProductsViewController {
                // Set the value you want to pass to the destination view controller
                destinationVC.storeName = storeName
            }else if segue.identifier == "ProductDetailsNavID",
                     let destinationVC = segue.destination as? ProductDetailsViewController {
                destinationVC.product = product
            }
        }
}

// MARK: - UITableViewDelegate

extension MyStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // Adjust the height to your desired value
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
        cell.storeLbl.text = productsArray[indexPath.row].condition
        let productGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(productsCellTapped(_:)))
        cell.addGestureRecognizer(productGestureRecognizer)
        
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
