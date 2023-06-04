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
        // Initialization code
    }
    @IBAction func favIcon(_ sender: Any) {
        
    }
    
}
