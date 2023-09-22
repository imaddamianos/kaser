//
//  SignUpInfoVC.swift
//  kaser
//
//  Created by imps on 9/24/21.
//

import UIKit
import iOSDropDown
import SkyFloatingLabelTextField
import SCLAlertView
import Firebase
import FirebaseStorage
import CoreLocation
import MapKit

class SignUpInfoVC: UIViewController, SignUpInfoViewProtocol, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet var headerVw: UIView!
    @IBOutlet var imgProfiePic: UIImageView!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    @IBOutlet var txtFirstName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtLastName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtMobile: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var storeNameTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var infoLogo: UIImageView!
    @IBOutlet var infoTitle: UILabel!
    @IBOutlet var infoSubTitle: UILabel!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var DOBlbl: UILabel!
    @IBOutlet var calanderVw: UIDatePicker!
    @IBOutlet var agreeVw: UIStackView!
    @IBOutlet var txtUserName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var locationCheck: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var mapViewLocation: MKMapView!
    @IBOutlet weak var scrollViewVw: UIScrollView!
    @IBOutlet weak var mapStack: UIStackView!
    var presenter: SignUpInfoVcPresenter!
    var ref: DatabaseReference!
    var userType: String?
    var agreeSelected = true
    var imageURL = ""
    let userTypeArray = ["Choose an option ", "Buyer", "Seller"]
    let locationManager = CLLocationManager()
    var latitude: String?
    var longitude: String?
    var dateOfBirth: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func agreeBtnTapped(_ sender: Any) {
        
        
        if agreeSelected == true{
            agreeBtn.setBackgroundImage(UIImage(named: "check-circle-fill"), for: .normal)
            agreeSelected = false
        }else{
            agreeSelected = true
            agreeBtn.setBackgroundImage(UIImage(named: "check-circle"), for: .normal)
            
        }
    }
    @IBAction func locationBtnTapped(_ sender: Any) {
        // Start updating the user's location
        locationManager.startUpdatingLocation()

    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if imgProfiePic.image == nil{
            SCLAlertView().showInfo("Notice", subTitle: "Enter a profile picture")
        }else if txtUserName.text!.isEmpty {
            SCLAlertView().showInfo("Notice", subTitle: "Enter a user name")
        }else if txtFirstName.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your First Name")
        }else if txtLastName.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your Last Name")
        }else if txtMobile.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your Mobile Number")
        }else if DOBlbl.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your date of Birth")
        }else if dateOfBirth.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your date of Birthday")
        } else{
        
        if !agreeSelected{
            self.presenter.checkUserName(userName: txtUserName.text!, type: userType!){success in
                if success{
                    if self.userType == "Buyer"{
                        self.presenter.addBuyer(userName: self.txtUserName.text!, firstname: self.txtFirstName.text!, lastName: self.txtLastName.text!, email: newEmail!, password: newPass!, mobile: self.txtMobile.text!, location: [self.latitude:self.longitude],LocationName: self.locationLbl.text ?? "", DOB: self.dateOfBirth, userType: self.userType!, image: self.imageURL)
                    }else{
                        if self.latitude == nil || self.latitude!.isEmpty && self.longitude == nil || self.longitude!.isEmpty {
                            SCLAlertView().showInfo("Notice", subTitle: "Location is missing")
                        }
                        self.presenter.addSeller(userName: self.txtUserName.text!, firstname: self.txtFirstName.text!, lastName: self.txtLastName.text!, email: newEmail!, password: newPass!, mobile: self.txtMobile.text!, DOB: self.dateOfBirth, storeName: self.storeNameTxt.text!, location: [self.latitude:self.longitude], LocationName: self.locationLbl.text ?? "", userType: self.userType!, image: self.imageURL)
                    }
                }else{
                    performOn(.main){
                alertView.showError("User exict", subTitle: "User is already in use, choose another name")
                    }
                }
            }
            
            
            //            }
        }else{
            GFunction.shared.showAlert("Review Our Terms", message: "Please read and agree on terms & conditions", btnName: "OK") {
                
            }
        }
    }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
        

    }
    @IBAction func addImageBtn(_ sender: Any) {
        print("add image")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
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
                    self.imgProfiePic.image = image
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
    
    func setupView(){
        
        calanderVw.datePickerMode = .date
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(datePickerValueChanged(_:)))
        calanderVw.addGestureRecognizer(tapGesture)
        calanderVw.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        userTypePickerView.dataSource = self
        userTypePickerView.delegate = self
        #if DEBUG
        
        self.txtFirstName.text = "imad"
        self.txtLastName.text = "damianos"
        self.txtMobile.text = "70745269"
        self.storeNameTxt.text = "hello store"
        #endif
              addKeyboardObservers()
              setupKeyboardDismissRecognizer()
        agreeBtn.setBackgroundImage(UIImage(named: "check-circle"), for: .normal)
        firebaseRef.currentUser?.reload(completion: { (error) in
                    if error == nil{
                        if let email = newEmail {
                            firebaseRef.signIn(withEmail: email, password: newPass!) { (user, error) in
                                if let error = error {
                                    print("\(error.localizedDescription)")
                                    return
                                }
                            }
                        } else {
                            print("Email can't be empty")
                        }

                        print(firebaseRef.currentUser?.email as Any)
                        if firebaseRef.currentUser?.isEmailVerified == true {
                            print("email verified")
                        } else {
                            print("email not verified")
                 let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false // if you dont want the close button use false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Verify") {
                        print("button tapped")
                        self.setupView()
                    }
                alertView.showInfo("Verify", subTitle: "Please go to your inbox and click the link to verify")
                        }
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                })
        
        self.presenter = SignUpInfoVcPresenter(view: self)
        initialView()
        imgProfiePic.cornerRadius(cornerRadius: imgProfiePic.frame.width / 2)

    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth = dateFormatter.string(from: sender.date)
        
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
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imgProfiePic.image = image
            }
            
        })
        task.resume()
    }
    
    func buyerView() {
        headerVw.backgroundColor = UIColor.colorFromHex(hex: 0x7C7E90)
        calanderVw.tintColor = UIColor.originalColor
        signUpBtn.setBackgroundImage(UIImage(named: "btnLayout"), for: .normal)
        txtUserName.isHidden = false
        txtFirstName.isHidden = false
        txtLastName.isHidden = false
        txtMobile.isHidden = false
        DOBlbl.isHidden = false
        calanderVw.isHidden = false
        agreeVw.isHidden = false
        signUpBtn.isHidden = false
        storeNameTxt.isHidden = true
        mapStack.isHidden = false
        imageStack.isHidden = false
        signUpBtn.setTitleColor(UIColor.white, for: .normal)
        infoLogo.tintColor = UIColor.white
        backBtn.setImage(UIImage(named: "back"), for: .normal)
    }
    
    func sellerView() {
        buyerView()
        storeNameTxt.isHidden = true
        headerVw.backgroundColor = UIColor.colorFromHex(hex: 0x7C7E90)
        calanderVw.tintColor = UIColor.colorYellow
        signUpBtn.setBackgroundImage(UIImage(named: "sellerBtn"), for: .normal)
        signUpBtn.setTitleColor(UIColor.black, for: .normal)
        infoLogo.tintColor = UIColor.black
        backBtn.setImage(UIImage(named: "sellerBackBtn"), for: .normal)
        mapStack.isHidden = false
        imageStack.isHidden = false
    }
    
    func initialView() {
        headerVw.backgroundColor = UIColor.originalColor
        txtUserName.isHidden = true
        txtFirstName.isHidden = true
        txtLastName.isHidden = true
        txtMobile.isHidden = true
        DOBlbl.isHidden = true
        calanderVw.isHidden = true
        storeNameTxt.isHidden = true
        storeNameTxt.isHidden = true
        agreeVw.isHidden = true
        signUpBtn.isHidden = true
        mapStack.isHidden = true
        imageStack.isHidden = true
    }
}
extension SignUpInfoVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        userTypeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypeArray[row] // Return content for each row
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedText = userTypeArray[row]
        if selectedText == "Buyer" {
            userType = selectedText
            self.buyerView()
        }else if selectedText == "Seller" {
            userType = selectedText
            self.sellerView()
        }else{
            self.initialView()
        }
    }
}
