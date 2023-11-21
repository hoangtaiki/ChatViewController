//
//  NSMutableAttributedString+Extensions.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/12/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    @discardableResult
    func bold(_ text: String,
              fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize,
              textColor: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(boldString)
        return self
    }

    @discardableResult
    func medium(_ text: String,
                fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize,
                textColor: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium),
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let mediumString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(mediumString)
        return self
    }

    @discardableResult
    func italic(_ text: String,
                fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize,
                textColor: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let italicString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(italicString)
        return self
    }

    @discardableResult
    func normal(_ text: String,
                fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize,
                textColor: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let normal =  NSMutableAttributedString(string: text, attributes: attrs)
        self.append(normal)
        return self
    }

}

extension NSAttributedString {

    func replacingCharacters(in range: NSRange,
                             with attributedString: NSAttributedString) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.replaceCharacters(in: range, with: attributedString)
        return mutableAttributedString
    }

    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let mutableAttributedString = NSMutableAttributedString(attributedString: lhs)
        mutableAttributedString.append(rhs)
        lhs = mutableAttributedString
    }

    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: lhs)
        mutableAttributedString.append(rhs)
        return NSAttributedString(attributedString: mutableAttributedString)
    }

}
