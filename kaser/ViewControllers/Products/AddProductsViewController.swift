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
    @IBOutlet weak var priceTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var conditionPicker: UIPickerView!
    @IBOutlet weak var descriptionTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var productImg: UIImageView!
    var imageURL = ""
    var presenter: AddProductVcPresenter!
    var storeName: String?
    var condition: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    func setupView(){
        self.presenter = AddProductVcPresenter(view: self)
        addKeyboardObservers()
        setupKeyboardDismissRecognizer()
        productImg.cornerRadius(cornerRadius: productImg.bounds.height/2)
        conditionPicker.delegate = self
        
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
        
        if productImg.image == nil{
            GFunction.shared.showAlert("Product Image", message: "Please choose an image for your product", btnName: "OK") {
            }
            return
        }
        
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
        
        if priceTxt.text?.isEmpty ?? true {
            GFunction.shared.showAlert("Car Model address", message: "Please enter the price for this product", btnName: "OK") {
            }
            return
        }
        
        let selectedRow = conditionPicker.selectedRow(inComponent: 0) // Assuming one component
        condition = conditionOptions[selectedRow]
        if condition == "Select Condition" {
            GFunction.shared.showAlert("Product Condition", message: "Please enter the Product Condition", btnName: "OK") {
            }
            return
           }
        
        if descriptionTxt.text?.isEmpty ?? true {
            GFunction.shared.showAlert("Product description", message: "Please enter the product description", btnName: "OK") {
            }
            return
        }
        // Call the presenter method to add the store
        self.presenter.addProduct(productName: productNameTxt.text!, storeName: self.storeName!, brand: brandNameTxt.text!, price: priceTxt.text!, condition: condition!, description: descriptionTxt.text!, image: imageURL){ isSuccess in
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

extension AddProductsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conditionOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conditionOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Set the selected condition in the conditionTxt text field
        condition = conditionOptions[row]
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

