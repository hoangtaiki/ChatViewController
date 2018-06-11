//
//  MessageTextCell.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/8/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

class MessageTextCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!

    static var reuseIdentifier = "MessageTextCell"

    static func nib() -> UINib {
        return UINib.init(nibName: reuseIdentifier, bundle: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        messageLabel.text = ""
    }

    func bind(withMessage message: Message) {
        messageLabel.text = message.text
    }

}
