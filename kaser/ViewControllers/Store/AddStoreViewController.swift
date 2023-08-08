//
//  AddStoreViewController.swift
//  kaser
//
//  Created by iMad on 12/06/2023.
//

import UIKit
import SkyFloatingLabelTextField

class AddStoreViewController: UIViewController, AddStoreViewProtocol {
    
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeName: SkyFloatingLabelTextField!
    @IBOutlet weak var storePhone: SkyFloatingLabelTextField!
    @IBOutlet weak var storeAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var storeDelivery: SkyFloatingLabelTextField!
    @IBOutlet weak var storeDescription: SkyFloatingLabelTextField!
    var imageURL = ""
    var presenter: AddStoreVcPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
        setStoreDetails()
    }
    
    func setupView(){
        self.presenter = AddStoreVcPresenter(view: self)
        addKeyboardObservers()
        setupKeyboardDismissRecognizer()
        storeImg.cornerRadius(cornerRadius: storeImg.bounds.height/2)
        
    }
    
    func showUserImage(){
//        vwImage.addGestureRecognizer(gesture)
        
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else{
            return
        }
       let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _,error in
            guard let data = data, error == nil else{
                return
            }
           performOn(.main){
                let image = UIImage(data: data)
                self.storeImg.image = image
            }
            
        })
        task.resume()
    }
    
    func setStoreDetails(){
        
    }

    @IBAction func addStoreTapped(_ sender: Any) {
        
        // Check if any field is empty
          if storeName.text?.isEmpty ?? true {
              GFunction.shared.showAlert("Store Name", message: "Please enter the store Name", btnName: "OK") {

              }
              return
          }
          
          if storePhone.text?.isEmpty ?? true {
              GFunction.shared.showAlert("Store phone", message: "Please enter the Store phone number", btnName: "OK") {

              }
              return
          }
          
          if storeAddress.text?.isEmpty ?? true {
              GFunction.shared.showAlert("Store address", message: "Please enter the Store address", btnName: "OK") {

              }
              return
          }
          
          if storeDelivery.text?.isEmpty ?? true {
              GFunction.shared.showAlert("Store delivery", message: "Please enter the Store delivery price", btnName: "OK") {

              }
              return
          }
          
          if storeDescription.text?.isEmpty ?? true {
              GFunction.shared.showAlert("Store description", message: "Please enter the Store description", btnName: "OK") {

              }
              
              return
          }
          // Call the presenter method to add the store
          self.presenter.addStore(storeName: storeName.text!, phone: storePhone.text!, address: storeAddress.text!, delivery: storeDelivery.text!, description: storeDescription.text!, image: imageURL)
    }
    
    @IBAction func addImageBtn(_ sender: Any) {
        print("add image")
        storeNamePath = storeName.text
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

}

extension AddStoreViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        GFunction.shared.addLoader("Uploading")
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        imageStoreRef.putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            imageStoreRef.downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                return
                }
                let urlString = url.absoluteString
                performOn(.main){
                    self.imageURL = urlString
                    self.storeImg.image = image
                }
                picker.dismiss(animated: false, completion: nil)
                GFunction.shared.removeLoader()
                print("download url: \(urlString)")
                UserDefaults.standard.setValue(urlString, forKey: "url")
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
