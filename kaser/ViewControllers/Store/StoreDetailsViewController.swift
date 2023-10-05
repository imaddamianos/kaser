//
//  StoreDetailsViewController.swift
//  kaser
//
//  Created by iMad on 22/08/2023.
//

import UIKit

class StoreDetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeNbLbl: UILabel!
    @IBOutlet weak var productsTbl: UITableView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var storeDescription: UILabel!
    @IBOutlet weak var editStoreBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    var store: Store?
    var product: Product?
    var chatID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        checkProductOwner()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.backgroundColor = UIColor.originalColor
        storeName.text = store?.storeName
        storeNbLbl.text = store?.phone
        addressLbl.text = store?.LocationName
        phoneLbl.text = store?.phone
        deliveryLbl.text = store!.delivery + "$"
        storeDescription.text = store?.description
        GFunction.shared.loadImageAsync(from: URL(string: store!.storeImage), into: (storeImg)!)
        productsTbl.dataSource = self
        productsTbl.delegate = self
        productsTbl.register(MyProductsTableViewCell.nib, forCellReuseIdentifier: MyProductsTableViewCell.identifier)
        getProducts()
    }
    
    func getProducts(){
        APICalls.shared.getProducts(store: store?.storeName ?? "") { success in
                self.productsTbl.reloadData()
        }
    }
    
    func checkProductOwner(){
        editStoreBtn.isHidden = true
        chatBtn.isHidden = false
        editStoreBtn.isUserInteractionEnabled = false
        if store?.storeOwner == newEmail{
            editStoreBtn.isHidden = false
            chatBtn.isHidden = true
            editStoreBtn.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func editStoreBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "MyStoreNavID", sender: self)
    }
    
    @IBAction func chatBtnTapped(_ sender: Any) {
        // Call the createChat function when a button is tapped, for instance
        self.chatID = createChat(userType: (userDetails?.userType)!, user1ID: (userDetails?.UserName!)!, user2ID: store!.storeName)
        self.performSegue(withIdentifier: "ChatSellerNavID", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "MyStoreNavID",
               let destinationVC = segue.destination as? MyStoreViewController {
                // Set the value you want to pass to the destination view controller
                destinationVC.store = store
            }else if segue.identifier == "ProductDetailsNavID",
                     let destinationVC = segue.destination as? ProductDetailsViewController {
                destinationVC.product = product
            }else if segue.identifier == "ChatSellerNavID",
                     let destinationVC = segue.destination as? ChatViewController {
                destinationVC.chatID = self.chatID!
                destinationVC.currentUser = userDetails
            }
        }
    
    @objc func productsCellTapped(_ sender: UITapGestureRecognizer) {
        // Handle cell tap here
        if let cell = sender.view as? UITableViewCell {
            if let indexPath = productsTbl.indexPath(for: cell) {
                let product = productsArray[indexPath.row]
                self.product = product
                self.performSegue(withIdentifier: "ProductDetailsNavID", sender: self)
                
            }
        }
    }
}

// MARK: - UITableView

extension StoreDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // Adjust the height to your desired value
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyProductsTableViewCell.identifier, for: indexPath) as? MyProductsTableViewCell else { fatalError("xib doesn't exist") }
        let productGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(productsCellTapped(_:)))
        cell.addGestureRecognizer(productGestureRecognizer)
        cell.titleLabel.text = productsArray[indexPath.row].productName
        cell.priceLbl.text = productsArray[indexPath.row].productOwner
        cell.locationLbl.text = productsArray[indexPath.row].brand
        cell.descriptionLbl.text = productsArray[indexPath.row].description
        cell.storeLbl.text = productsArray[indexPath.row].condition
        
        if let cachedImage = imageCache.object(forKey: productsArray[indexPath.row].productImage as NSString) {
            // If the image is already cached, use it
            cell.iconImageView.image = cachedImage
        } else {
            // Image not cached, fetch asynchronously
            GFunction.shared.loadImageAsync(from: URL(string: (productsArray[indexPath.row].productImage)), into: (cell.iconImageView)!)
        }
        
        return cell
    }
}
