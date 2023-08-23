//
//  StoreDetailsViewController.swift
//  kaser
//
//  Created by iMad on 22/08/2023.
//

import UIKit

class StoreDetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeNbLbl: UILabel!
    @IBOutlet weak var productsTbl: UITableView!
    var store: Store?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        navigationController?.setNavigationBarHidden(false, animated: false)
        storeName.text = store?.storeName
        storeNbLbl.text = store?.phone
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
