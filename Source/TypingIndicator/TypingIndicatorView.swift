//
//  TypingIndicatorView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/12/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

public class TypingIndicatorView: UIView {

    /// The color of the text. Default is grayColor
    open var textColor: UIColor = .gray

    /// The font of the text. Default is system font, 12 pts
    open var textFont: UIFont = .systemFont(ofSize: 12)

    /// Label edge inset
    open var labelEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }

    /// Height of view
    var viewHeight: CGFloat {
        return textFont.lineHeight + labelEdgeInsets.top + labelEdgeInsets.bottom
    }

    @objc dynamic var isVisible: Bool = false

    /// The text label used to display the typing indicator content
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.contentMode = .topLeft
        textLabel.isUserInteractionEnabled = false
        return textLabel
    }()

    private var users: [Userable] = []
    private var labelConstraintSet: LayoutConstraintSet?

    private var attributedString: NSAttributedString? {
        var attributedString: NSMutableAttributedString?
        let fontSize = textFont.pointSize

        switch users.count {
        case 0:
            attributedString = nil
        case 1:
            attributedString = NSMutableAttributedString()
                .bold(users[0].displayName, fontSize: fontSize, textColor: textColor)
                .normal(" is typing", fontSize: fontSize, textColor: textColor)
        case 2:
            attributedString = NSMutableAttributedString()
                .bold(users[0].displayName, fontSize: fontSize, textColor: textColor)
                .normal(" and ", fontSize: fontSize, textColor: textColor)
                .bold(users[1].displayName, fontSize: fontSize, textColor: textColor)
                .normal(" are typing", fontSize: fontSize, textColor: textColor)
        default:
            attributedString = NSMutableAttributedString()
                .normal("Several people are typing", fontSize: fontSize, textColor: textColor)
        }

        return attributedString
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(textLabel)
        labelConstraintSet = LayoutConstraintSet(
            top: textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            bottom: textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            leading: textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: labelEdgeInsets.left),
            trailing: textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -labelEdgeInsets.right)
            ).activate()
    }

    // Insert an typing's user
    open func insertUser(_ user: Userable) {
        if users.contains(where: { $0.idNumber == user.idNumber }) { return }

        users.append(user)
        textLabel.attributedText = attributedString
        isVisible = true
    }

    // Remove an typing's user
    open func removeUser(_ user: Userable) {
        guard let index = users.firstIndex(where: { $0.idNumber == user.idNumber }) else {
            return
        }

        users.remove(at: index)

        if users.count > 0 {
            textLabel.attributedText = attributedString
        } else {
            isVisible = false
        }
    }

}
