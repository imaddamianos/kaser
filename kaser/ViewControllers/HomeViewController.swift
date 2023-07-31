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
    var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GFunction.shared.addLoader()
        // Menu Button Tint Color
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        setupView()
    }
    
    func setupView(){
        featuredCollView.dataSource = self
        featuredCollView.delegate = self
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
            sideMenu = GFunction.shared.sideMenuItems()
            if userDetails?.userType == "Buyer"{
                UIColor.originalColor = UIColor.colorFromHex(hex: 0x3c3f5a)

            }else if userDetails?.userType == "Seller"{
                UIColor.originalColor = UIColor.colorFromHex(hex: 0xd9d358)
            }
            StrongSelf.headerView.backgroundColor = UIColor.originalColor
            if let imageUrl = URL(string: (userDetails?.image)!){
                let image = try? UIImage(withContentsOfUrl: imageUrl)
                performOn(.main) {
                    StrongSelf.userImg.image = image
                }
            }
            StrongSelf.nameLbl.text = userDetails?.name
            GFunction.shared.removeLoader()
               
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
    
}

// MARK: - UITableViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the desired size for the item at the specified indexPath
        return CGSize(width: 200, height: 200)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier, for: indexPath) as! FeatureCollectionViewCell
            let product = storesArray[indexPath.row]
            cell.phoneNb.text = product.storeName
            cell.carModel.text = product.delivery
            cell.location.text = product.phone
            cell.views.text = product.address
            
            if let cachedImage = imageCache.object(forKey: product.storeImage as NSString) {
                // If the image is already cached, use it
                cell.featureCoverImg.image = cachedImage
            } else {
                // Image not cached, fetch asynchronously
                if let imageUrl = URL(string: product.storeImage) {
                    DispatchQueue.global().async {
                        do {
                            let imageData = try Data(contentsOf: imageUrl)
                            if let image = UIImage(data: imageData) {
                                // Cache the downloaded image
                                self.imageCache.setObject(image, forKey: product.storeImage as NSString)
                                DispatchQueue.main.async {
                                    // Display the downloaded image
                                    cell.featureCoverImg.image = image
                                }
                            }
                        } catch {
                            print("Failed to fetch image from URL: \(error)")
                        }
                    }
                }
            }
            
            return cell
        }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
