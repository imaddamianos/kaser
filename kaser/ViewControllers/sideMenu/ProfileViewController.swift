//
//  ProfileViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/9/21.
//

import UIKit
import SkyFloatingLabelTextField
import MapKit
import SCLAlertView


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var firstNameTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mobileNbr: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var calanderVw: UIDatePicker!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var mapStack: UIStackView!
    @IBOutlet weak var locationCheck: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationView: MKMapView!
    var dateOfBirth: String = ""
    var latitude: String?
    var longitude: String?
    var imageURL = ""
    let locationManager = CLLocationManager()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        if userImg.image == nil{
            SCLAlertView().showInfo("Notice", subTitle: "Enter a profile picture")
        }else if userName.text!.isEmpty {
            SCLAlertView().showInfo("Notice", subTitle: "Enter a user name")
        }else if firstNameTxt.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your First Name")
        }else if mobileNbr.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your Mobile Number")
        }else if dateOfBirth.isEmpty{
            dateOfBirth = (userDetails?.dob)!
        }else{
            if self.latitude == nil || self.latitude!.isEmpty && self.longitude == nil || self.longitude!.isEmpty {

                SCLAlertView().showInfo("Notice", subTitle: "Location is missing")
                return
            }
            
            APICalls.shared.modifyInfo(userName: userName.text!, userType: (userDetails?.userType)!, email: firstNameTxt.text!, mobile: mobileNbr.text!, DateOfBirth: dateOfBirth, location: [self.latitude:self.longitude] , image: self.imageURL){ (isSuccess) in
                if !isSuccess { return }
                SCLAlertView().showInfo("Alert", subTitle: "Profile Updated")
            }
    }

        
    }
    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    func setupView(){
        applyTheme(View: self) { backgroundColor in
            self.view.backgroundColor = backgroundColor
            if ThemeManager.shared.currentTheme == .dark {
                self.userName.textColor = UIColor.white
                self.firstNameTxt.textColor = UIColor.white
                self.mobileNbr.textColor = UIColor.white
                self.locationLbl.textColor = UIColor.white
                self.calanderVw.backgroundColor = UIColor.white
            }else{
                self.userName.textColor = UIColor.black
                self.firstNameTxt.textColor = UIColor.black
                self.mobileNbr.textColor = UIColor.black
                self.locationLbl.textColor = UIColor.black
                self.calanderVw.backgroundColor = UIColor.clear
            }
        }
        GFunction.shared.addLoader("")
        addKeyboardObservers()
        setupKeyboardDismissRecognizer()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        calanderVw.datePickerMode = .date
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(datePickerValueChanged(_:)))
        calanderVw.addGestureRecognizer(tapGesture)
        calanderVw.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        userImg.cornerRadius(cornerRadius: userImg.frame.width / 2)
        APICalls.shared.getUserInfo(name: "") { [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            
            if isSuccess {
                DispatchQueue.main.async {
                    
                    strongSelf.userName.text = userDetails?.UserName
                    strongSelf.firstNameTxt.text = userDetails?.email
                    strongSelf.mobileNbr.text = userDetails?.mobile
                    strongSelf.imageURL = (userDetails?.image)!
                    // date
                    strongSelf.dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = strongSelf.dateFormatter.date(from: (userDetails?.dob)!) {
                        strongSelf.calanderVw.date = date
                           }
                    
                    //location
                    if let jsonData = userDetails?.location!.data(using: .utf8) {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] {
                                if let latitudeString = json.keys.first, let longitudeString = json.values.first {
                                    if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
                                        
                                        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        let annotation = MKPointAnnotation()
                                        annotation.coordinate = coordinates
                                        strongSelf.locationView.addAnnotation(annotation)

                                        // Set the map's visible region to focus on the annotation
                                        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                        strongSelf.locationView.setRegion(region, animated: true)
                                    }
                                }
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                    if userDetails?.userType == "Buyer"{
                        UIColor.originalColor = UIColor.colorFromHex(hex: 0x3c3f5a)
                    }else{
                        UIColor.originalColor = UIColor.colorFromHex(hex: 0x36b7bf)
                        strongSelf.updateBtn.setBackgroundImage(UIImage(named: "sellerBtn"), for: .normal)
                    }
                    
                    GFunction.shared.loadImageAsync(from: URL(string: (userDetails?.image)!), into: (self?.userImg)!)
                    GFunction.shared.removeLoader()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
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
        locationView.setRegion(region, animated: true)

            // Create a new annotation with the user's location
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            // Reverse geocode to get the location name
            let locationName = getLocationNameFromCoordinates(latitude: latitude, longitude: longitude)
            annotation.title = locationName
            
        locationView.addAnnotation(annotation)
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        self.dateOfBirth = dateFormatter.string(from: sender.date)

      }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        GFunction.shared.addLoader("Uploading")
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        imageRef.putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            imageRef.downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                return
                }
                let urlString = url.absoluteString
                performOn(.main){
                    self.imageURL = urlString
                    self.userImg.image = image
                }
                picker.dismiss(animated: false, completion: nil)
                GFunction.shared.removeLoader()
                print("download url: \(urlString)")
                UserDefaults.standard.setValue(urlString, forKey: "url")
            })
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: false, completion: nil)
    }
}
