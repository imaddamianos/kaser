//
//  ProfileViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by imps on 2/9/21.
//

import UIKit
import SkyFloatingLabelTextField

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTxt: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var mobileNbr: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var storeName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var calanderVw: UIDatePicker!
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
                    strongSelf.emailTxt.text = userDetails?.email
                    strongSelf.mobileNbr.text = userDetails?.mobile
                    
                    if let imageUrl = URL(string: (userDetails?.image)!){
                        let image = try? UIImage(withContentsOfUrl: imageUrl)
                        performOn(.main) {
                            self?.userImg.image = image
                            GFunction.shared.removeLoader()
                        }
                    }
                    
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
