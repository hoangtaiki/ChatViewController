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
    let messageLabelContentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        messageLabel = UILabel()
        roundedView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: roundedView.topAnchor,
                                          constant: messageLabelContentInset.top).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor,
                                             constant: -messageLabelContentInset.bottom).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor,
                                              constant: messageLabelContentInset.left).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor,
                                               constant: -messageLabelContentInset.right).isActive = true

        let maxMessageLabelWidth = maxContentWidth - messageLabelContentInset.left - messageLabelContentInset.right
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxMessageLabelWidth).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        messageLabel.text = ""
        messageLabel.textColor  = .black
    }

    override func bind(withMessage message: Message, user: User) {
        messageLabel.text = message.text
        avatarImageView.setImage(with: user.avatarURL)

        tranformUI(message.isOutgoing)
    }

    override func tranformUI(_ isOutgoingMessage: Bool) {
        super.tranformUI(isOutgoingMessage)

        messageLabel.transform = contentTranform
    }

    override func updateUIWithBubbleStyle(_ bubbleStyle: BubbleStyle, isOutgoingMessage: Bool) {
        super.updateUIWithBubbleStyle(bubbleStyle, isOutgoingMessage: isOutgoingMessage)
        
        if isOutgoingMessage && bubbleStyle == .facebook {
            messageLabel.textColor = .white
        }
    }
}
