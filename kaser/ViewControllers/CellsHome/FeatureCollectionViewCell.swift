//
//  FeatureCollectionViewCell.swift
//  kaser
//
//  Created by imad on 9/10/22.
//

import UIKit

class FeatureCollectionViewCell: UICollectionViewCell {
    
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var favIcon: UIButton!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var phoneNb: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet var featureCoverImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
    }
    @IBAction func favIcon(_ sender: Any) {
        
    }
    
}
