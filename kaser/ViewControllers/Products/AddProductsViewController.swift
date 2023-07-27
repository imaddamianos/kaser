//
//  AddProductsViewController.swift
//  kaser
//
//  Created by iMad on 23/07/2023.
//

import UIKit
import SkyFloatingLabelTextField

class AddProductsViewController: UIViewController, AddProductViewProtocol {
    @IBOutlet weak var productNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var brandNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var carModelTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var conditionTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var descriptionTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var productImg: UIImageView!
    var imageURL = ""
    var presenter: AddProductVcPresenter!
    var storeName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    func setupView(){
        self.presenter = AddProductVcPresenter(view: self)
        hideKeyboard()
        productImg.cornerRadius(cornerRadius: productImg.bounds.height/2)
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        print("add image")
        productNamePath = productNameTxt.text
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    @IBAction func addProductTapped(_ sender: Any) {
        
        // Check if any field is empty
        if productNameTxt.text?.isEmpty ?? true {
            GFunction.shared.showAlert("Product Name", message: "Please enter the product Name", btnName: "OK") {
                
            }
            return
        }
        
        if brandNameTxt.text?.isEmpty ?? true {
            GFunction.shared.showAlert("Brand Name", message: "Please enter the brand name of the prodcut", btnName: "OK") {
                
            }
            return
        }
        
        if carModelTxt.text?.isEmpty ?? true {
            GFunction.shared.showAlert("Car Model address", message: "Please enter the Car Model for this product", btnName: "OK") {
                
            }
            return
        }
        
        if conditionTxt.text?.isEmpty ?? true {
            GFunction.shared.showAlert("Condition Type", message: "Please enter the condition type of the product", btnName: "OK") {
                
            }
            return
        }
        
        if descriptionTxt.text?.isEmpty ?? true {
            GFunction.shared.showAlert("Product description", message: "Please enter the product description", btnName: "OK") {
                
            }
            
            return
        }
        // Call the presenter method to add the store
        self.presenter.addProduct(productName: productNameTxt.text!, storeName: self.storeName!, brand: brandNameTxt.text!, car: carModelTxt.text!, condition: conditionTxt.text!, description: descriptionTxt.text!, image: imageURL){ isSuccess in
            if isSuccess {
                // Handle successful completion here
                print("Product added successfully.")
                // Inside your view controller, assuming you have a reference to the previousViewController
                self.navigationController?.popViewController(animated: true)

            } else {
                // Handle failure here
                print("Failed to add product.")
            }
        }
        
        
    }
}

extension AddProductsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        GFunction.shared.addLoader("Uploading")
        guard let image = info[.editedImage] as? UIImage,
              let productNamePath = productNamePath else {
            // Handle the case where either image or productNamePath is nil
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        // Assuming you have initialized storageRef appropriately
        let imageProductRef = storageRef.child("image/Products/\(productNamePath).png")
        
        guard let imageData = image.pngData() else {
            // Handle the case where imageData is nil
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        // Upload the image data to Firebase Storage
        imageProductRef.putData(imageData, metadata: nil) { (_, error) in
            picker.dismiss(animated: true, completion: nil)
            if let error = error {
                // Handle the error during image upload
                print("Failed to upload image: \(error.localizedDescription)")
            } else {
                // Image upload successful, perform any additional actions here
                print("Image uploaded successfully")
                imageProductRef.downloadURL(completion: {url, error in
                    guard let url = url, error == nil else{
                        return
                    }
                    let urlString = url.absoluteString
                    performOn(.main){
                        self.imageURL = urlString
                        self.productImg.image = image
                    }
                    picker.dismiss(animated: false, completion: nil)
                    GFunction.shared.removeLoader()
                    print("download url: \(urlString)")
                    UserDefaults.standard.setValue(urlString, forKey: "url")
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
