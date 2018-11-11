//
//  ChatBarView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 5/18/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import PlaceholderUITextView

open class ChatBarView: UIView {

    /// Height of TextView
    public var textViewCurrentHeight: CGFloat = 0

    /// Maximum height of TextView
    public var maxTextViewHeight: CGFloat {
        get {
            return maxChatBarHeight - getAdditionalHeight()
        }
    }
    /// Maximum height of ChatBar. When it reaches to maximum.
    /// The TextView will not continue expand
    public var maxChatBarHeight: CGFloat = 0

    /// Leading constraint constant value for leftStackView
    open var leadingConstant: CGFloat = 6.0
    /// Trailing constraint constant value for rightStackView
    open var trailingConstant: CGFloat = 6.0
    /// Top constraint constant value for topStackView
    open var topConstant: CGFloat = 6.0
    /// Bottom constraint constant value for bottomStackView
    open var bottomConstant: CGFloat = 6.0

    open lazy var textView: PlaceholderUITextView = {
        let textView = PlaceholderUITextView()
        textView.placeholder = "Type a message"
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.returnKeyType = .send
        textView.isHidden = false
        textView.enablesReturnKeyAutomatically = true
        return textView
    }()

    open var sendButton: ChatButton = {
        let sendButton = ChatButton()
        sendButton.isEnabled = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        return sendButton
    }()

    open var galleryButton: ChatButton = {
        let galleryButton = ChatButton()
        galleryButton.isEnabled = true
        var image = UIImage(named: "ic_gallery", in: Bundle.chatBundle, compatibleWith: nil)
        let tempImage = image!.withRenderingMode(.alwaysTemplate)
        image = tempImage
        galleryButton.image = image
        galleryButton.tintColor = UIColor.gray
        return galleryButton
    }()

    public var stackView = UIStackView()
    public var centerStackView = UIStackView()

    public var topBorderLine = UIView()
    public var leftStackView = ChatStackView(axis: .horizontal, spacing: 0)
    public var rightStackView = ChatStackView(axis: .horizontal, spacing: 0)
    public var topStackView = ChatStackView(axis: .horizontal, spacing: 0)
    public var bottomStackView = ChatStackView(axis: .horizontal, spacing: 0)

    fileprivate var topBorderLayoutSet: LayoutConstraintSet?
    fileprivate var centerStackViewLayoutSet: LayoutConstraintSet?

    // The InputBarItems
    public private(set) var leftStackViewItems: [ChatButton] = []
    public private(set) var rightStackViewItems: [ChatButton] = []
    public private(set) var bottomStackViewItems: [ChatButton] = []
    public var items: [ChatButton] {
        return [leftStackViewItems, rightStackViewItems, bottomStackViewItems].flatMap { $0 }
    }

    /// The fixed heightAnchor constant of the seperateLine
    public var seperateLineHeight: CGFloat = 1.0 {
        didSet {
            topBorderLayoutSet?.height?.constant = seperateLineHeight
        }
    }

    public override init(frame: CGRect) {
        super.init(frame : frame)
        setUI()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    public convenience init() {
        self.init(frame: .zero)
        setUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }

    open func setStackViewItems(_ items: [ChatButton], forStack position: ChatStackView.Position, animated: Bool) {
        func setNewItems() {
            switch position {
            case .left:
                leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                leftStackViewItems = items
                leftStackViewItems.forEach {
                    leftStackView.addArrangedSubview($0)
                }
                guard superview != nil else { return }
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                rightStackViewItems = items
                rightStackViewItems.forEach {
                    rightStackView.addArrangedSubview($0)
                }
                guard superview != nil else { return }
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                bottomStackViewItems = items
                bottomStackViewItems.forEach {
                    bottomStackView.addArrangedSubview($0)
                }
                guard superview != nil else { return }
                bottomStackView.layoutIfNeeded()
            case .top: break
            }
            invalidateIntrinsicContentSize()
        }

        performLayout(animated) {
            setNewItems()
        }
    }

    /// Perform layout change with animations
    public func performLayout(_ animated: Bool, _ animations: @escaping () -> Void) {
        deactivateConstraints()
        if animated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: animations)
            }
        } else {
            UIView.performWithoutAnimation { animations() }
        }
        activateConstraints()
    }

    public func layoutStackViews(_ positions: [ChatStackView.Position] = [.left, .right, .bottom, .top]) {
        guard superview != nil else { return }

        for position in positions {
            switch position {
            case .left:
                leftStackView.setNeedsLayout()
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.setNeedsLayout()
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.setNeedsLayout()
                bottomStackView.layoutIfNeeded()
            case .top:
                break
            }
        }
    }

    public func getAdditionalHeight() -> CGFloat {
        var height: CGFloat = seperateLineHeight + topConstant + bottomConstant
        if !topStackView.isHidden {
            height = height + stackView.spacing + topStackView.bounds.height
        }

        if !bottomStackView.isHidden {
            height = height + stackView.spacing + bottomStackView.bounds.height
        }

        return height
    }

}

extension ChatBarView {

    fileprivate func setUI() {
        backgroundColor = .white
        textView.keyboardType = .default
        clipsToBounds = true
        topBorderLine.backgroundColor = UIColor.lightGray
        topBorderLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topBorderLine)

        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        centerStackView.alignment = .fill
        centerStackView.distribution = .fill
        centerStackView.axis = .horizontal
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        centerStackView.addArrangedSubview(leftStackView)
        centerStackView.addArrangedSubview(textView)
        centerStackView.addArrangedSubview(rightStackView)

        bottomStackView.alignment = .center
        topStackView.alignment = .center

        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(centerStackView)
        stackView.addArrangedSubview(bottomStackView)

        // Default hide all StackViews
        topStackView.isHidden = true
        bottomStackView.isHidden = true

        setupConstraints()
    }

    /// Sets up the initial constraints of each subview
    fileprivate func setupConstraints() {
        // LayoutConstraint for topBorderLine
        topBorderLayoutSet = LayoutConstraintSet(
            top: topBorderLine.topAnchor.constraint(equalTo: topAnchor),
            leading: topBorderLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailing: topBorderLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            height: topBorderLine.heightAnchor.constraint(equalToConstant: seperateLineHeight)
        )

        centerStackViewLayoutSet = LayoutConstraintSet(
            top: stackView.topAnchor.constraint(equalTo: topBorderLine.bottomAnchor, constant: topConstant),
            bottom: stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomConstant),
            leading: stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant),
            trailing: stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingConstant)
        )
        
        centerStackViewLayoutSet?.top?.priority = .defaultHigh
        centerStackViewLayoutSet?.bottom?.priority = .defaultHigh
        centerStackViewLayoutSet?.leading?.priority = .defaultHigh
        centerStackViewLayoutSet?.trailing?.priority = .defaultHigh
        
        topBorderLayoutSet?.top?.priority = .defaultHigh
        topBorderLayoutSet?.leading?.priority = .defaultHigh
        topBorderLayoutSet?.trailing?.priority = .defaultHigh
        topBorderLayoutSet?.height?.priority = .defaultHigh

        textView.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
        textView.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)

        activateConstraints()
    }

    /// Activates the NSLayoutConstraintSet's
    fileprivate func activateConstraints() {
        topBorderLayoutSet?.activate()
        centerStackViewLayoutSet?.activate()
    }

    /// Deactivates the NSLayoutConstraintSet's
    fileprivate func deactivateConstraints() {
        topBorderLayoutSet?.deactivate()
        centerStackViewLayoutSet?.deactivate()
    }

    fileprivate func textViewHeightForLines(_ numberOfLines: Int) -> CGFloat {
        var height = textView.intrinsicContentSize.height
        if let font = textView.font {
            height -= font.lineHeight
            height += CGFloat(roundf(Float(font.lineHeight) * Float(numberOfLines)))
        }

        return height
    }
}
