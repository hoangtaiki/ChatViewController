//
//  PlaceholderTextView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

open class PlaceholderTextView: UITextView {

    // MARK: - Properties
    public var resignFirstResponderTimeAnimate: TimeInterval = 0.25
    public var becomeFirstResponderTimeAnimate: TimeInterval = 0.25

    override open var text: String! {
        didSet {
            textDidChange()
        }
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    /// A UILabel that holds the InputTextView's placeholder text
    open var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Aa"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// The placeholder text that appears when there is no text
    open var placeholder: String? = "Aa" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    /// The placeholderLabel's textColor
    open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    /// The UIEdgeInsets the placeholderLabel has within the InputTextView
    open var placeholderLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4) {
        didSet {
            updatePlaceholderLabelConstraints()
        }
    }

    /// The font of the InputTextView. When set the placeholderLabel's font is also updated
    open override var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }

    /// The textAlignment of the InputTextView. When set the placeholderLabel's textAlignment is also updated
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    /// The textContainerInset of the InputTextView. When set the placeholderLabelInsets is also updated
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderLabelInsets = textContainerInset
        }
    }

    open override var scrollIndicatorInsets: UIEdgeInsets {
        didSet {
            // When .zero a rendering issue can occur
            if scrollIndicatorInsets == .zero {
                scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                                     left: .leastNonzeroMagnitude,
                                                     bottom: .leastNonzeroMagnitude,
                                                     right: .leastNonzeroMagnitude)
            }
        }
    }

    /// The constraints of the placeholderLabel
    private var placeholderLabelConstraintSet: LayoutConstraintSet?


    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open override func becomeFirstResponder() -> Bool {
        if !canBecomeFirstResponder { return false }

        UIView.animate(withDuration: becomeFirstResponderTimeAnimate, animations: {
            super.becomeFirstResponder()
        })

        return true

    }

    // Override resignFirstResponder to set animation duration to zero
    open override func resignFirstResponder() -> Bool {
        if !canResignFirstResponder { return false }

        UIView.animate(withDuration: resignFirstResponderTimeAnimate, animations: {
            super.resignFirstResponder()
        })

        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}

extension PlaceholderTextView {

    /// Sets up the default properties
    fileprivate func setup() {
        isEditable = true
        isSelectable = true
        isScrollEnabled = true
        scrollsToTop = false
        isDirectionalLockEnabled = true
        backgroundColor = .clear
        layoutManager.allowsNonContiguousLayout = false
        translatesAutoresizingMaskIntoConstraints = false

        font = UIFont.preferredFont(forTextStyle: .body)
        scrollIndicatorInsets = UIEdgeInsets(top: .leastNonzeroMagnitude,
                                             left: .leastNonzeroMagnitude,
                                             bottom: .leastNonzeroMagnitude,
                                             right: .leastNonzeroMagnitude)

        setupPlaceholderLabel()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }

    /// Adds the placeholderLabel to the view and sets up its initial constraints
    fileprivate func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        placeholderLabelConstraintSet = LayoutConstraintSet(
            top: placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: placeholderLabelInsets.top),
            bottom: placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -placeholderLabelInsets.bottom),
            leading: placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: placeholderLabelInsets.left),
            trailing: placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -placeholderLabelInsets.right)
        )
        placeholderLabelConstraintSet?.top?.priority = .defaultLow - 1
        placeholderLabelConstraintSet?.bottom?.priority = .defaultLow - 1
        placeholderLabelConstraintSet?.activate()
    }

    /// Updates the placeholderLabels constraint constants to match the placeholderLabelInsets
    fileprivate func updatePlaceholderLabelConstraints() {
        placeholderLabelConstraintSet?.top?.constant = placeholderLabelInsets.top
        placeholderLabelConstraintSet?.bottom?.constant = -placeholderLabelInsets.bottom
        placeholderLabelConstraintSet?.leading?.constant = placeholderLabelInsets.left
        placeholderLabelConstraintSet?.trailing?.constant = -placeholderLabelInsets.right
    }
}
