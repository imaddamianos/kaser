//
//  ProductDetailsViewController.swift
//  kaser
//
//  Created by iMad on 14/09/2023.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productName.text = product?.productName
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
