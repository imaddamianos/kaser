//
//  MyStoreViewController.swift
//  kaser
//
//  Created by iMad on 11/06/2023.
//

import UIKit
import Floaty

class MyStoreViewController: UIViewController, FloatyDelegate {

    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeNbLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var reviewsLbl: UILabel!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!

    @IBOutlet weak var myProductsTbl: UITableView!
    @IBOutlet weak var coverImg: UIImageView!

    var floaty: Floaty!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureFloaty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        positionFloatyButton()
    }

    func setupView() {
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }

    func configureFloaty() {
        floaty = Floaty()
        floaty.fabDelegate = self

        floaty.addItem("createContact", icon: UIImage(named: "contact")) { item in
            // Handle the "createContact" action
            print("Create Contact tapped")
        }

        floaty.addItem("copyNumber", icon: UIImage(named: "email")) { item in
            // Handle the "copyNumber" action
            print("Copy Number tapped")
        }

        // Add more items as needed...

        floaty.buttonColor = UIColor.systemBlue
        floaty.plusColor = UIColor.white
        floaty.overlayColor = UIColor.black.withAlphaComponent(0.3)

        self.view.addSubview(floaty) // Add Floaty to the view hierarchy
    }

    func positionFloatyButton() {
        let floatyButtonSize = floaty.frame.size
        let xOffset = (view.frame.width - floatyButtonSize.width) / 2
        let yOffset = view.frame.height - floatyButtonSize.height - 100

        floaty.frame.origin = CGPoint(x: xOffset, y: yOffset)
    }

    // MARK: - FloatyDelegate

    func clicked(on item: FloatyItem) {
        // Handle item selection events here
        print("Floaty item clicked: \(item.title)")
    }
}
