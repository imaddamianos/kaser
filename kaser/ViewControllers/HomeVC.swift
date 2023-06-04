//
//  HomeVC.swift
//  kaser
//
//  Created by imps on 10/16/21.
//

import UIKit

class HomeVC: UIViewController {

    var presenter: HomeVcPresenter!
    
    @IBOutlet var reviewsLbl: UILabel!
    @IBOutlet var favoriteLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var userImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func sideMenuBtn(_ sender: Any) {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        GFunction.shared.showSuccess()
        
    }


}
