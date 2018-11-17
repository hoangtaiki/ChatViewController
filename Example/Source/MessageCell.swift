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

/// Incoming and outgoing message is is divided into different blocks
/// A Block is a continuous sequence message from sender or receiver.
enum PositionInBlock {
    case top
    case center
    case bottom
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
    var instaContentInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 0)
    let spaceBetweenTwoGroup: CGFloat = 8
    let spaceInsideGroup: CGFloat = 3
    let maxContentWidth: CGFloat = UIScreen.main.bounds.size.width * 0.6

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .white

        /// RoundView: Background of Content
        roundedView = UIView()
        roundedView.clipsToBounds = true
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
        case .instagram:
            innerStackView.alignment = .top
        }
    }

    /// Update UI depend on RoundedViewType and BubbleStyle
    /// With Facebook Messenger they only show avatar for .bottomGroup and .single
    func showHideUIWithBubbleStyle(_ bubbleStyle: BubbleStyle, positionInBlock: PositionInBlock) {
        switch (bubbleStyle, positionInBlock) {
        case (.facebook, .bottom), (_, .single), (.instagram, .top):
            avatarImageView.isHidden = false
        case (.facebook, .top), (_, .center), (.instagram, .bottom):
            avatarImageView.isHidden = true
        }
    }
    
    func updateUIWithBubbleStyle(_ bubbleStyle: BubbleStyle, isOutgoingMessage: Bool) {
        let fbIncomingBubbleColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 0.88)
        let fbOutgoingBubbleColor = UIColor(red: 179/255, green: 145/255, blue: 181/255, alpha: 0.66)
        let instaBorderIncomingBubbleColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        let instaOutgoingBubbleColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)

        if isOutgoingMessage {
            switch bubbleStyle {
            case .facebook:
                roundedView.backgroundColor = fbOutgoingBubbleColor
            case .instagram:
                roundedView.backgroundColor = instaOutgoingBubbleColor
                roundedView.layer.borderWidth = 0
                roundedView.layer.cornerRadius = 16
                roundedView.layer.borderColor = UIColor.clear.cgColor
            }
        } else {
            switch bubbleStyle {
            case .facebook:
                roundedView.backgroundColor = fbIncomingBubbleColor
            case .instagram:
                roundedView.layer.borderWidth = 1
                roundedView.layer.borderColor = instaBorderIncomingBubbleColor.cgColor
                roundedView.layer.cornerRadius = 16
                roundedView.backgroundColor = .clear
            }
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
    }

    /// Layout for Outgoing message
    /// With Incoming message we don't want to show status, avatar
    fileprivate func layoutForOutgoingMessage() {
        statusStackView.isHidden  = true
        statusSpaceView.isHidden = true
        avatarContainerView.isHidden = true
    }
    
    /// Mask `roundedView` by an CAShapeLayer with a rectangle
    func roundViewWithBubbleStyle(_ bubbleStyle: BubbleStyle, positionInBlock: PositionInBlock) {
        let bounds = roundedView.bounds
        var roundRadius: (tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat)
        roundRadius = getRoundRadiusForBubbleStyle(bubbleStyle, positionInBlock: positionInBlock)
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
    
    /// Get radius value for four corners
    func getRoundRadiusForBubbleStyle(_ bubbleStyle: BubbleStyle, positionInBlock: PositionInBlock) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch bubbleStyle {
        // For instagram
        case .instagram:
            return (16, 16, 16, 16)
            
        // For facebook bubble style
        case .facebook:
            switch positionInBlock {
            case .top:
                return (16, 16, 4, 16)
            case .center:
                return (4, 16, 4, 16)
            case .bottom:
                return (4, 16, 16, 16)
            case .single:
                return (16, 16, 16, 16)
            }
        }
    }
    
    /// Update space between message inside a group.
    func updateLayoutForBubbleStyle(_ bubbleStyle: BubbleStyle, positionInBlock: PositionInBlock) {
        switch bubbleStyle {
        case .instagram:
            topAnchorContentView.constant = instaContentInset.top
            bottomAnchorContentView.constant = -instaContentInset.bottom
            
        // For Facebook
        // Message in group should be closer
        case .facebook:
            switch positionInBlock {
            case .top:
                bottomAnchorContentView.constant = -spaceInsideGroup
            case .center:
                topAnchorContentView.constant = spaceInsideGroup
                bottomAnchorContentView.constant = -spaceInsideGroup
            case .bottom:
                topAnchorContentView.constant = spaceInsideGroup
            default:
                topAnchorContentView.constant = contentInset.top
                bottomAnchorContentView.constant = -contentInset.bottom
            }
        }
    }
}
