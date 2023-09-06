//
//  CarsCollectionViewCell.swift
//  kaser
//
//  Created by iMad on 06/09/2023.
//

import UIKit

class CarsCollectionViewCell: UICollectionViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var carsLbl: UILabel!
    @IBOutlet weak var carsImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }

}
