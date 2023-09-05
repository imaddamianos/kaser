//
//  ProductsCollectionViewCell.swift
//  kaser
//
//  Created by iMad on 05/09/2023.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var brandCarLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
