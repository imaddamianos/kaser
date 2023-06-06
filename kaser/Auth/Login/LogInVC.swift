//
//  LogInVC.swift
//  kaser
//
//  Created by imps on 9/20/21.
//

import UIKit
import FirebaseDatabase
import SkyFloatingLabelTextField
import SCLAlertView

class LogInVC: UIViewController, LogInViewProtocol {
    
    
    @IBOutlet var txtEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var txtPass: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var vwLogo: UIView!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet weak var rememberMe: UIButton!
    
    private let database = Database.database().reference()
    var presenter: LogInPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        database.child("something").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            print("Value: \(value)")
        })
        
        
    }
    
    @IBAction func rememberBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
           if sender.isSelected {
               // Toggle is ON
               sender.setBackgroundImage(UIImage(named: "check-circle-fill"), for: .normal)
               UserDefaults.standard.setValue(true, forKey: "isSaveSelected")
           } else {
               // Toggle is OFF
               sender.setBackgroundImage(UIImage(named: "check-circle"), for: .normal)
               UserDefaults.standard.setValue(false, forKey: "isSaveSelected")
           }
    }
    
    
    @IBAction func logInTapped(_ sender: Any) {
        if !txtEmail.text!.isEmpty &&  !txtPass.text!.isEmpty{
            if txtEmail.text!.isEmpty {
                SCLAlertView().showInfo("Notice", subTitle: "Enter an E-mail address")
            }else if txtPass.text!.isEmpty{
                SCLAlertView().showInfo("Notice", subTitle: "Enter a Password address")
            }else{
                if (UserDefaults.standard.bool(forKey: "isSaveSelected") == true){
                    UserDefaults.standard.setValue(txtEmail.text!, forKey: "email")
                    UserDefaults.standard.setValue(txtPass.text!, forKey: "password")
                }else{
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                }
                self.presenter.checkTxtField(email: txtEmail.text!, password: txtPass.text!) 
            }
        }else{
            SCLAlertView().showNotice("Notice", subTitle: "Please fill in the information below")
        }
    }
    @IBAction func signUpTapped(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
        
    }
    @IBAction func forgetPasswordTapped(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
        
    }
    
    func setupView(){
        
//#if DEBUG
//        self.txtEmail.text = "sa3louki@gmail.com"
//        self.txtPass.text = "imadimad"
//#endif\
        
        //check if email saved
        if UserDefaults.standard.bool(forKey: "isSaveSelected"){
            rememberMe.setBackgroundImage(UIImage(named: "check-circle-fill"), for: .normal)
        }else{
            rememberMe.setBackgroundImage(UIImage(named: "check-circle"), for: .normal)
        }
        hideKeyboard()
        self.presenter = LogInPresenter(view: self)
        //ui code
        vwLogo.cornerRadius(cornerRadius: vwLogo.layer.frame.height / 2)
        imgLogo.cornerRadius(cornerRadius: imgLogo.layer.frame.height / 2)
        
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let password = UserDefaults.standard.value(forKey: "password") as? String {
            // Both email and password are not nil
            self.txtEmail.text = email
            self.txtPass.text = password
            //logging in
//            self.presenter.checkTxtField(email: email, password: password)
        } else {
            // Either email or password is nil
            
            // Handle the case when email or password is nil, e.g., show an error message or take appropriate action
        }
        
    }
}

