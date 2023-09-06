//
//  ViewController.swift
//
//  Created by imps on 2/§/21.
//

import UIKit

class HomeViewController: UIViewController, HomeVcProtocol {
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var reviewsLbl: UILabel!
    @IBOutlet var favoriteLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet weak var featuredCollView: UICollectionView!
    @IBOutlet weak var productsCollView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    var presenter: HomeVcPresenter!
    var store: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GFunction.shared.addLoader()
        // Menu Button Tint Color
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
        callInfo()
    }
    
    func setupView(){
        searchbar.backgroundImage = UIImage()
        featuredCollView.register(FeatureCollectionViewCell.nib, forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier)
        productsCollView.register(ProductsCollectionViewCell.nib, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        self.presenter = HomeVcPresenter(view: self)
        userImg.cornerRadius(cornerRadius: userImg.frame.width / 2)
    }

    
    func callInfo(){
        GFunction.shared.addLoader("")
        APICalls.shared.getUserInfo(name: newEmail!){[weak self] (isSuccess) in
            guard let StrongSelf = self else{
                return
            }
            if !isSuccess { return }
            StrongSelf.headerView.backgroundColor = UIColor.originalColor
            GFunction.shared.loadImageAsync(from: URL(string: (userDetails?.image)!), into: (StrongSelf.userImg)!)
            StrongSelf.nameLbl.text = userDetails?.UserName
            GFunction.shared.removeLoader()
                sideMenu = GFunction.shared.sideMenuItems(userType: (userDetails?.userType)!)
    
        
        APICalls.shared.getStores() {[weak self] (isSuccess) in
            guard let StrongSelf = self else{
                return
            }
            if !isSuccess { return }
            StrongSelf.featuredCollView.reloadData()
            }
        }
        // Once stores are fetched, fetch all products
        APICalls.shared.getAllProducts() {[weak self] (isSuccess) in
            guard let StrongSelf = self else{
                return
            }
            if (isSuccess == nil) { return }
            StrongSelf.productsCollView.reloadData()
            GFunction.shared.removeLoader()
        }
    }
    
    @IBAction func sideMenuBtn(_ sender: Any) {
        revealViewController()?.revealSideMenu()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "StoreDetailsNavID",
               let destinationVC = segue.destination as? StoreDetailsViewController {
                // Set the value you want to pass to the destination view controller
                destinationVC.store = store
            }
        }
    
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == featuredCollView {
            return storesArray.count
        }else{
            return productsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == featuredCollView {
            let totalWidth = featuredCollView.bounds.width + featuredCollView.bounds.width
            let totalHeight = max(featuredCollView.bounds.height, featuredCollView.bounds.height)
            return CGSize(width: totalWidth/3, height: totalHeight)
            
        }else{
            let totalWidth = productsCollView.bounds.width
            let totalHeight = productsCollView.bounds.height
            return CGSize(width: totalWidth/2.2, height: totalHeight/1.1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //stores collection
        if collectionView == featuredCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier, for: indexPath) as! FeatureCollectionViewCell
            let product = storesArray[indexPath.row]
            cell.phoneNb.text = product.phone
            cell.carModel.text = product.storeName
            cell.location.text = product.address
            cell.views.text = product.delivery
            cell.backgroundColor = UIColor.originalColor
            // Add a tap gesture recognizer to the cell
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            if let cachedImage = imageCache.object(forKey: product.storeImage as NSString) {
                // If the image is already cached, use it
                cell.featureCoverImg.image = cachedImage
            } else {
                // Image not cached, fetch asynchronously
                GFunction.shared.loadImageAsync(from: URL(string: (product.storeImage)), into: (cell.featureCoverImg)!)
            }
            
            return cell
            //products collection
        }else if collectionView == productsCollView {
            // Handle productsCollView cells
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
            let product = productsArray[indexPath.row]
            cell.productNameLbl.text = product.productName
            cell.brandCarLbl.text = product.brand
            cell.conditionLbl.text = product.condition
            cell.backgroundColor = UIColor.originalColor
            
            if let cachedImage = imageCache.object(forKey: product.productImage as NSString) {
                // If the image is already cached, use it
                cell.productImg.image = cachedImage
            } else {
                // Image not cached, fetch asynchronously
                GFunction.shared.loadImageAsync(from: URL(string: (product.productImage)), into: (cell.productImg)!)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
        }
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        // Handle cell tap here
        if let cell = sender.view as? UICollectionViewCell {
            if let indexPath = featuredCollView.indexPath(for: cell) {
                let store = storesArray[indexPath.row]
                self.store = store
                print("store name: \(store)")
                self.performSegue(withIdentifier: "StoreDetailsNavID", sender: self)
                
            }
        }
    }

}
