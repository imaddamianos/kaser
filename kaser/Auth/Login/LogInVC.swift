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
    @IBAction func logInTapped(_ sender: Any) {
        if !txtEmail.text!.isEmpty &&  !txtPass.text!.isEmpty{
            if txtEmail.text!.isEmpty {
                SCLAlertView().showInfo("Notice", subTitle: "Enter an E-mail address")
            }else if txtPass.text!.isEmpty{
                SCLAlertView().showInfo("Notice", subTitle: "Enter a Password address")
            }else{
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
        
        #if DEBUG
        self.txtEmail.text = "sa3louki@gmail.com"
        self.txtPass.text = "imadimad"
        #endif
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
        self.presenter = LogInPresenter(view: self)
        vwLogo.cornerRadius(cornerRadius: vwLogo.layer.frame.height / 2)
        imgLogo.cornerRadius(cornerRadius: imgLogo.layer.frame.height / 2)
    }
    
    @objc private func hideKeyboard() {
            view.endEditing(true)
        }


}

