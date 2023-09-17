//
//  MyProductsTableViewCell.swift
//  kaser
//
//  Created by iMad on 14/06/2023.
//

import UIKit

class MyProductsTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var productVw: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var storeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productVw.backgroundColor = UIColor.colorFromHex(hex: 0x7C7E90)
        productVw.layer.cornerRadius = 10.0
        productVw.clipsToBounds = true
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
