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
    var store: Store?

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
        if store?.storeOwner == newEmail{
            editStoreBtn.isHidden = false
        }
    }
    
    @IBAction func editStoreBtnTapped(_ sender: Any) {
        
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
        //            cell.iconImageView.image = productsArray[indexPath.row].productImage
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
