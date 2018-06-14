//
//  MessageTextCell.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/8/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import ChatViewController

class MessageTextCell: MessageCell {

    static var reuseIdentifier = "MessageTextCell"

    var messageLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        messageLabel = UILabel()
        roundedView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 8).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -8).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: 8).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor, constant: -8).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        messageLabel.text = ""
    }

    override func bind(withMessage message: Message, user: User, style: RoundedViewType) {
        messageLabel.text = message.text
        avatarImageView.image = user.image

        tranformUIWithMessage(message)
        updateLayoutForGroupMessage(style: style)
    }

    override func tranformUIWithMessage(_ message: Message) {
        super.tranformUIWithMessage(message)

        messageLabel.transform = contentTranform
    }

}
