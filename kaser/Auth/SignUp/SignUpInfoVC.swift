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

class SignUpInfoVC: UIViewController, SignUpInfoViewProtocol, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet var headerVw: UIView!
    @IBOutlet var imgProfiePic: UIImageView!
    @IBOutlet var btnAddImage: UIButton!
    @IBOutlet weak var userTypePickerView: UIPickerView!
    @IBOutlet var txtFirstName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtLastName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtMobile: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var locationBtn: DropDown!
    @IBOutlet var storeNameTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var infoLogo: UIImageView!
    @IBOutlet var infoTitle: UILabel!
    @IBOutlet var infoSubTitle: UILabel!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var DOBlbl: UILabel!
    @IBOutlet var calanderVw: UIDatePicker!
    @IBOutlet var agreeVw: UIStackView!
    @IBOutlet var txtUserName: SkyFloatingLabelTextFieldWithIcon!
    
    var presenter: SignUpInfoVcPresenter!
    var ref: DatabaseReference!
    var userType: String?
    var agreeSelected = true
    var imageURL = ""
    let userTypeArray = ["Choose an option ", "Buyer", "Seller"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
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
    @IBAction func signUpTapped(_ sender: Any) {
        if txtUserName.text!.isEmpty {
            SCLAlertView().showInfo("Notice", subTitle: "Enter a user name")
        }else if txtFirstName.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your First Name")
        }else if txtLastName.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your Last Name")
        }else if txtMobile.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your Mobile Number")
        }else if DOBlbl.text!.isEmpty{
            SCLAlertView().showInfo("Notice", subTitle: "Enter your date of Birth")
        }else{
        
        if !agreeSelected{
            let date = calanderVw.date.description
            
            self.presenter.checkUserName(userName: txtUserName.text!, type: userType!){success in
                if success{
                    if self.userType == "Buyer"{
                        self.presenter.addBuyer(userName: self.txtUserName.text!, firstname: self.txtFirstName.text!, lastName: self.txtLastName.text!, email: newEmail!, password: newPass!, mobile: self.txtMobile.text!, DOB: date, userType: self.userType!, image: self.imageURL)
                        
                    }else{
                        self.presenter.addSeller(userName: self.txtUserName.text!, firstname: self.txtFirstName.text!, lastName: self.txtLastName.text!, email: newEmail!, password: newPass!, mobile: self.txtMobile.text!, DOB: date, storeName: self.storeNameTxt.text!, location: ["lat":32, "long":34], userType: self.userType!, image: self.imageURL)
                    }
                }else{
                    performOn(.main){
                        //                    alertView.showError("User exict", subTitle: "User is already in use, choose another name")
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
        
        userTypePickerView.dataSource = self
        userTypePickerView.delegate = self
        #if DEBUG
        
        self.txtFirstName.text = "imad"
        self.txtLastName.text = "damianos"
        self.txtMobile.text = "70745269"
        self.storeNameTxt.text = "hello store"
        #endif
        hideKeyboard()
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
                     self.verify()
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
    
    
    func verify(){
        setupView()
    }
    func buyerView() {
        headerVw.backgroundColor = UIColor.originalColor
        locationBtn.borderColor = UIColor.originalColor
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
        locationBtn.isHidden = true
        backBtn.tintColor = UIColor.white
        infoTitle.textColor = UIColor.white
        infoSubTitle.textColor = UIColor.white
        signUpBtn.setTitleColor(UIColor.white, for: .normal)
        infoLogo.tintColor = UIColor.white
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        
    }
    
    func sellerView() {
        buyerView()
        locationBtn.isHidden = false
        storeNameTxt.isHidden = true
        headerVw.backgroundColor = UIColor.colorYellow
        locationBtn.borderColor = UIColor.colorYellow
        calanderVw.tintColor = UIColor.colorYellow
        signUpBtn.setBackgroundImage(UIImage(named: "sellerBtn"), for: .normal)
        backBtn.tintColor = UIColor.black
        infoTitle.textColor = UIColor.black
        infoSubTitle.textColor = UIColor.black
        signUpBtn.setTitleColor(UIColor.black, for: .normal)
        infoLogo.tintColor = UIColor.black
        backBtn.setImage(UIImage(named: "sellerBackBtn"), for: .normal)
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
        locationBtn.isHidden = true
        storeNameTxt.isHidden = true
        locationBtn.isHidden = true
        agreeVw.isHidden = true
        signUpBtn.isHidden = true
        
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
