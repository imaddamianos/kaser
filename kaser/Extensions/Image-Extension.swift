//
//  Image-Extension.swift
//  kaser
//
//  Created by imad on 9/11/22.
//

import Foundation

extension UIImage {

    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
    
        self.init(data: imageData)
    }

}
