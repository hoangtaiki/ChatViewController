//
//  MessageCell.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/14/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
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

    var contentTranform: CGAffineTransform!
    var topAnchorContentView: NSLayoutConstraint!
    var bottomAnchorContentView: NSLayoutConstraint!

    var contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 108)
    let spaceBetweenTwoGroup: CGFloat = 8
    let spaceInsideGroup: CGFloat = 3

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .white

        /// RoundView: Background of Content
        roundedView = UIView()
        roundedView.backgroundColor = .gray
        roundedView.translatesAutoresizingMaskIntoConstraints = false

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
        avatarContainerView.widthAnchor.constraint(equalToConstant: 32).isActive = true

        avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFit
        avatarContainerView.addSubview(avatarImageView)

        avatarImageView.topAnchor.constraint(equalTo: avatarContainerView.topAnchor).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: avatarContainerView.bottomAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: avatarContainerView.leadingAnchor).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: avatarContainerView.trailingAnchor).isActive = true

        /// Group of avatarContainerView and roundedView
        let innerStackView = UIStackView(arrangedSubviews: [avatarContainerView, roundedView])
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
        outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -contentInset.right).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = nil
    }

    func bind(withMessage message: Message, user: User, style: RoundedViewType) {
        avatarImageView.image = user.image

        tranformUIWithMessage(message)
        updateLayoutForGroupMessage(style: style)
    }

    func updateUIWithStyle(_ style: RoundedViewType) {
        roundViewWithStyle(style)
        showHideUIWithStyle(style)
    }

    func tranformUIWithMessage(_ message: Message) {
        if message.isOutgoingMessage {
            layoutForOutgoingMessage()
            contentTranform = CGAffineTransform(scaleX: -1, y: 1)
            statusLabel.textAlignment = .right
        } else {
            layoutForIncomingMessage()
            contentTranform = CGAffineTransform.identity
            statusLabel.textAlignment = .left
        }
        contentView.transform = contentTranform
        statusLabel.transform = contentTranform
        avatarImageView.transform = contentTranform
    }
}

extension MessageCell {

    fileprivate func layoutForIncomingMessage() {
        statusStackView.isHidden = true
        statusSpaceView.isHidden = false
        avatarContainerView.isHidden = false
    }

    fileprivate func layoutForOutgoingMessage() {
        statusStackView.isHidden  = true
        statusSpaceView.isHidden = true
        avatarContainerView.isHidden = true
    }

    fileprivate func roundViewWithStyle( _ style: RoundedViewType) {
        layoutIfNeeded()

        let bounds = roundedView.bounds
        let roundRadius: (tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat) = getRoundRadiusForStyle(style)
        let path = UIBezierPath(roundedRect: bounds,
                                topLeftRadius: roundRadius.tl,
                                topRightRadius: roundRadius.tr,
                                bottomLeftRadius: roundRadius.bl,
                                bottomRightRadius: roundRadius.br)
        path.lineJoinStyle = .round

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath

        roundedView.layer.mask = maskLayer
    }

    fileprivate func getRoundRadiusForStyle(_ style: RoundedViewType) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch style {
        case .topGroup:
            return (16, 16, 4, 16)
        case .centerGroup:
            return (4, 16, 4, 16)
        case .bottomGroup:
            return (4, 16, 16, 16)
        case .single:
            return (16, 16, 16, 16)
        }
    }

    fileprivate func showHideUIWithStyle(_ style: RoundedViewType) {
        // Only show avatar for .bottomGroup and .single
        switch style {
        case .bottomGroup, .single:
            avatarImageView.isHidden = false
        default:
            avatarImageView.isHidden = true
        }
    }

    func updateLayoutForGroupMessage(style: RoundedViewType) {
        switch style {
        case .topGroup:
            bottomAnchorContentView.constant = -spaceInsideGroup
        case .centerGroup:
            topAnchorContentView.constant = spaceInsideGroup
            bottomAnchorContentView.constant = -spaceInsideGroup
        case .bottomGroup:
            topAnchorContentView.constant = spaceInsideGroup
        default: break
        }
    }
}
