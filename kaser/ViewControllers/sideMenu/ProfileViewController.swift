//
//  ProfileViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/9/21.
//

import UIKit
import SkyFloatingLabelTextField
import MapKit


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
    
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        
        
    }
    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    func setupView(){
        GFunction.shared.addLoader("")
        userImg.cornerRadius(cornerRadius: userImg.frame.width / 2)
        APICalls.shared.getUserInfo(name: "") { [weak self] (isSuccess) in
            guard let strongSelf = self else {
                return
            }
            
            if isSuccess {
                DispatchQueue.main.async {
                    
                    strongSelf.userName.text = userDetails?.name
                    strongSelf.firstNameTxt.text = userDetails?.email
                    strongSelf.mobileNbr.text = userDetails?.mobile
//                    strongSelf.locationView =
                    
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
                    // date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date = dateFormatter.date(from: userDetails?.dob ?? "") {
                        strongSelf.calanderVw.date = date
                    }
                    
                    if userDetails?.userType == "Buyer"{
                        UIColor.originalColor = UIColor.colorFromHex(hex: 0x3c3f5a)
                    }else{
                        UIColor.originalColor = UIColor.colorFromHex(hex: 0x36b7bf)
                        strongSelf.updateBtn.setBackgroundImage(UIImage(named: "sellerBtn"), for: .normal)
                    }
                    strongSelf.navigationController?.navigationBar.barTintColor = UIColor.originalColor
                    
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
