//
//  MessageCell.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/14/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import Kingfisher
import ChatViewController

enum RoundedViewType {
    case topGroup
    case centerGroup
    case bottomGroup
    case single
}

class MessageCell: UITableViewCell {

    var roundedView: UIView!
    var statusLabel: UILabel!
    var avatarContainerView: UIView!
    var avatarImageView: UIImageView!
    var statusSpaceView: UIView!
    var statusStackView: UIStackView!
    var innerStackView: UIStackView!

    var contentTranform: CGAffineTransform!
    var topAnchorContentView: NSLayoutConstraint!
    var bottomAnchorContentView: NSLayoutConstraint!

    var contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
    let spaceBetweenTwoGroup: CGFloat = 8
    let spaceInsideGroup: CGFloat = 3
    let maxContentWidth: CGFloat = UIScreen.main.bounds.size.width * 0.6
    let incomingMessageBubbleColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 0.88)
    let outgoingMessageBubbleColor = UIColor(red: 179/255, green: 145/255, blue: 181/255, alpha: 0.66)

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .white

        /// RoundView: Background of Content
        roundedView = UIView()
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        /// Height >= round Corner Radius * 2
        let roundedViewHeightConstraint = roundedView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        roundedViewHeightConstraint.priority = .defaultHigh
        roundedViewHeightConstraint.isActive = true

        /// Status
        statusLabel = UILabel()
        statusLabel.text = "Seen"
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = .gray
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        statusSpaceView = UIView()
        statusSpaceView.translatesAutoresizingMaskIntoConstraints = false
        statusSpaceView.widthAnchor.constraint(equalToConstant: 32).isActive = true

        statusStackView = UIStackView(arrangedSubviews: [statusSpaceView, statusLabel])
        statusStackView.spacing = 8
        statusStackView.axis = .horizontal
        statusStackView.alignment = .fill
        statusStackView.translatesAutoresizingMaskIntoConstraints = false

        /// Avatar
        avatarContainerView = UIView()
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        let avatarWidthConstraint = avatarContainerView.widthAnchor.constraint(equalToConstant: 32)
        avatarWidthConstraint.isActive = true
        avatarWidthConstraint.priority = .defaultHigh + 1
        let avatarHeightConstraint = avatarContainerView.heightAnchor.constraint(equalToConstant: 32)
        avatarHeightConstraint.isActive = true
        avatarHeightConstraint.priority = .defaultHigh + 1

        avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFit
        avatarContainerView.addSubview(avatarImageView)

        avatarImageView.topAnchor.constraint(equalTo: avatarContainerView.topAnchor).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: avatarContainerView.bottomAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: avatarContainerView.leadingAnchor).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor).isActive = true

        /// Group of avatarContainerView and roundedView
        innerStackView = UIStackView(arrangedSubviews: [avatarContainerView, roundedView])
        innerStackView.spacing = 8
        innerStackView.axis = .horizontal
        innerStackView.alignment = .bottom
        innerStackView.translatesAutoresizingMaskIntoConstraints = false

        let outerStackView = UIStackView.init(arrangedSubviews: [innerStackView, statusStackView])
        outerStackView.spacing = 6
        outerStackView.axis = .vertical
        outerStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(outerStackView)
        topAnchorContentView = outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                                   constant: contentInset.top)
        topAnchorContentView.isActive = true
        bottomAnchorContentView = outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                         constant: -contentInset.bottom)
        bottomAnchorContentView.isActive = true
        outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: contentInset.left).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = nil
    }

    func bind(withMessage message: Message, user: User) {
        avatarImageView.setImage(with: user.avatarURL)

        tranformUI(message.isOutgoing)
    }

    /// Update avatar position corresponds with bubble style
    func updateAvatarPosition(bubbleStyle: BubbleStyle) {
        // With facebook style. Avatar image is aligned to bubble's bottom
        switch bubbleStyle {
        case .facebook:
            innerStackView.alignment = .bottom
        }
    }

    /// Update UI depend on RoundedViewType and BubbleStyle
    /// With Facebook Messenger they only show avatar for .bottomGroup and .single
    func showHideUIWithStyle(_ style: RoundedViewType, bubbleStyle: BubbleStyle) {
        switch (style, bubbleStyle) {
        case (.bottomGroup, .facebook), (.single, _):
            avatarImageView.isHidden = false
        case (.topGroup, .facebook), (.centerGroup, _):
            avatarImageView.isHidden = true
        }
    }
    
    func tranformUI(_ isOutgoingMessage: Bool) {
        if isOutgoingMessage {
            layoutForOutgoingMessage()
            contentTranform = CGAffineTransform(scaleX: -1, y: -1)
            statusLabel.textAlignment = .right
        } else {
            layoutForIncomingMessage()
            contentTranform = CGAffineTransform(scaleX: 1, y: -1)
            statusLabel.textAlignment = .left
        }
        contentView.transform = contentTranform
        statusLabel.transform = contentTranform
        avatarImageView.transform = contentTranform
    }
}

extension MessageCell {

    /// Layout for Incoming message
    /// With Incoming message we don't want to show status
    fileprivate func layoutForIncomingMessage() {
        statusStackView.isHidden = true
        statusSpaceView.isHidden = false
        avatarContainerView.isHidden = false
        roundedView.backgroundColor = incomingMessageBubbleColor
    }

    /// Layout for Outgoing message
    /// With Incoming message we don't want to show status, avatar
    fileprivate func layoutForOutgoingMessage() {
        statusStackView.isHidden  = true
        statusSpaceView.isHidden = true
        avatarContainerView.isHidden = true
        roundedView.backgroundColor = outgoingMessageBubbleColor
    }
}
