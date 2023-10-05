//
//  ChatTableViewCell.swift
//  kaser
//
//  Created by iMad on 02/10/2023.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
