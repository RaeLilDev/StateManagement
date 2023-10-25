//
//  String+Extension.swift
//  StateManagement
//
//  Created by Ye linn htet on 10/25/23.
//

import Foundation
import UIKit

extension String {
    func highlightString() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        return attributedString
    }
}
