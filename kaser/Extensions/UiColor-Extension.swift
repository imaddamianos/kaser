//
//  UiColor-Extension.swift
//  kaser
//
//  Created by imps on 10/16/21.
//

import Foundation

extension UIColor {
    class func colorFromHex(hex: Int) -> UIColor { return UIColor(red: (CGFloat((hex & 0xFF0000) >> 16)) / 255.0, green: (CGFloat((hex & 0xFF00) >> 8)) / 255.0, blue: (CGFloat(hex & 0xFF)) / 255.0, alpha: 1.0)
    }
    
    static var colorBlack: UIColor { return  UIColor.colorFromHex(hex: 0x000000) }
    static var colorWhite: UIColor { return  UIColor.colorFromHex(hex: 0xffffff) }
    static var colorYellow: UIColor { return  UIColor.colorFromHex(hex: 0xd9d358) }
    static var colorOriginGreen: UIColor { return  UIColor.colorFromHex(hex: 0x3c3f5a) }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.colorBlack
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
