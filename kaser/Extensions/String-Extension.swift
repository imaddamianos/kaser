//
//  String-Extension.swift
//  kaser
//
//  Created by imad on 9/11/22.
//

import Foundation


extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
