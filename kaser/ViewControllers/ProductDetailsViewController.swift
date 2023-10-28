//
//  ProductDetailsViewController.swift
//  kaser
//
//  Created by iMad on 14/09/2023.
//

import UIKit
import SkyFloatingLabelTextField


class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: SkyFloatingLabelTextField!
    @IBOutlet weak var productDescription: SkyFloatingLabelTextField!
    @IBOutlet weak var brandLbl: SkyFloatingLabelTextField!
    @IBOutlet weak var conditionLbl: SkyFloatingLabelTextField!
    @IBOutlet weak var priceLbl: SkyFloatingLabelTextField!
    @IBOutlet weak var editBtn: UIButton!
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObservers()
        setupKeyboardDismissRecognizer()
        productName.isUserInteractionEnabled = false
        productDescription.isUserInteractionEnabled = false
        brandLbl.isUserInteractionEnabled = false
        conditionLbl.isUserInteractionEnabled = false
        priceLbl.isUserInteractionEnabled = false

        checkProductOwner()
        productName.text = product?.productName
        productDescription.text = product?.description
        brandLbl.text = product?.brand
//        priceLbl.text = product?.car
        priceLbl.text = product?.Price
        conditionLbl.text = product?.condition
        GFunction.shared.loadImageAsync(from: URL(string: product!.productImage), into: (productImg)!)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.backgroundColor = UIColor.originalColor
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @IBAction func editProductTapped(_ sender: Any) {
        productName.isUserInteractionEnabled = true
        productDescription.isUserInteractionEnabled = true
        brandLbl.isUserInteractionEnabled = true
        conditionLbl.isUserInteractionEnabled = true
        priceLbl.isUserInteractionEnabled = true
        changeToEdit(textField: productName)
        changeToEdit(textField: productDescription)
        changeToEdit(textField: brandLbl)
        changeToEdit(textField: conditionLbl)
        changeToEdit(textField: priceLbl)
    }
    
    func changeToEdit(textField: SkyFloatingLabelTextField){
        if editBtn.titleLabel?.text == "Update"{
            textField.isUserInteractionEnabled = false
            textField.isUserInteractionEnabled = false
            textField.isUserInteractionEnabled = false
            textField.isUserInteractionEnabled = false
            textField.isUserInteractionEnabled = false
            textField.lineColor = UIColor.clear
            editBtn.setTitle("Edit Product", for: .normal)
            APICalls.shared.modifyProductInfo(storeName:"",productName: productName.text!, productDescription: productDescription.text!, brand: brandLbl.text!, price: priceLbl.text!, condition: conditionLbl.text!){ (isSuccess) in
                if !isSuccess { return }
            }
        }else{
            textField.isUserInteractionEnabled = true
            textField.isUserInteractionEnabled = true
            textField.isUserInteractionEnabled = true
            textField.isUserInteractionEnabled = true
            textField.isUserInteractionEnabled = true
            textField.lineColor = UIColor.black
            editBtn.setTitle("Update", for: .normal)
        }

    }
    
    func checkProductOwner(){
        editBtn.isHidden = true
        if product?.productOwner == newEmail{
            editBtn.isHidden = false
        }
    }
    
}
