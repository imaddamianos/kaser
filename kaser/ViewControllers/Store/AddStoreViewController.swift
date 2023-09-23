//
//  AddStoreViewController.swift
//  kaser
//
//  Created by iMad on 12/06/2023.
//

import UIKit
import SkyFloatingLabelTextField
import MapKit

class AddStoreViewController: UIViewController, CLLocationManagerDelegate, AddStoreViewProtocol {
    
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeName: SkyFloatingLabelTextField!
    @IBOutlet weak var storePhone: SkyFloatingLabelTextField!
//    @IBOutlet weak var storeAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var storeDelivery: SkyFloatingLabelTextField!
    @IBOutlet weak var storeDescription: SkyFloatingLabelTextField!
    @IBOutlet weak var locationCheck: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var mapViewLocation: MKMapView!
    let locationManager = CLLocationManager()
    var latitude: String?
    var longitude: String?
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.presenter = AddStoreVcPresenter(view: self)
        addKeyboardObservers()
        setupKeyboardDismissRecognizer()
        storeImg.cornerRadius(cornerRadius: storeImg.bounds.height/2)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
    @IBAction func locationBtnTapped(_ sender: Any) {
        // Start updating the user's location
        locationManager.startUpdatingLocation()

    }

    @IBAction func addStoreTapped(_ sender: Any) {
        
        
        if storeImg.image == nil{
            GFunction.shared.showAlert("Store Image", message: "Please choose an image for your store", btnName: "OK") {
            }
            return
        }
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
          
          if locationLbl.text?.isEmpty ?? true {
              GFunction.shared.showAlert("Store address", message: "Click on Location", btnName: "OK") {

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
          self.presenter.addStore(storeName: storeName.text!, phone: storePhone.text!, address: [self.latitude:self.longitude], delivery: storeDelivery.text!, description: storeDescription.text!, image: imageURL)
    }
    
    @IBAction func addImageBtn(_ sender: Any) {
        performOn(.main){
            storeNamePath = self.storeName.text
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }

            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.longitude = String(longitude)
            self.latitude = String(latitude)

            // Create a CLLocationCoordinate2D instance with the coordinates
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // Create an MKCoordinateRegion centered around the coordinates
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapViewLocation.setRegion(region, animated: true)

            // Create a new annotation with the user's location
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            // Reverse geocode to get the location name
            let locationName = getLocationNameFromCoordinates(latitude: latitude, longitude: longitude)
            annotation.title = locationName
            
            mapViewLocation.addAnnotation(annotation)
        }

        // Reverse geocoding function
        func getLocationNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let geocoder = CLGeocoder()

            var locationName = ""

            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    // You can access various components of the placemark
                    if let name = placemark.name {
                        self.locationLbl.text = name
                        locationName = name
                    }
                }
            }

            return locationName
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
