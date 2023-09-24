//
//  ProductDetailsViewController.swift
//  kaser
//
//  Created by iMad on 14/09/2023.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addImageBtn: UIButton!
    
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkProductOwner()
        productName.text = product?.productName
        productDescription.text = product?.description
        brandLbl.text = product?.brand
        priceLbl.text = product?.car
        GFunction.shared.loadImageAsync(from: URL(string: product!.productImage), into: (productImg)!)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.backgroundColor = UIColor.originalColor
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
    }
    
    func checkProductOwner(){
        addImageBtn.isHidden = true
        if product?.productOwner == newEmail{
            addImageBtn.isHidden = false
        }
    }
    
}
