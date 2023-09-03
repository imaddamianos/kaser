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
    @IBOutlet weak var mostViewedCollView: UICollectionView!
    @IBOutlet weak var newCollView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
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
    }
    
    func setupView(){
        featuredCollView.dataSource = self
        featuredCollView.delegate = self
        featuredCollView.isUserInteractionEnabled = true
        featuredCollView.register(FeatureCollectionViewCell.nib, forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier)
        self.presenter = HomeVcPresenter(view: self)
        userImg.cornerRadius(cornerRadius: userImg.frame.width / 2)
        callInfo()
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
        }
        
        APICalls.shared.getStores() {[weak self] (isSuccess) in
            guard let StrongSelf = self else{
                return
            }
            if !isSuccess { return }
            StrongSelf.featuredCollView.reloadData()
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
        return storesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the desired size for the item at the specified indexPath
        return CGSize(width: 300, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
