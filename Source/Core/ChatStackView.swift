//
//  ChatStackView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 5/18/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

open class ChatStackView: UIStackView {

    /// The stack view position in the InputBarAccessoryView
    ///
    /// - left: Left Stack View
    /// - right: Bottom Stack View
    /// - bottom: Left Stack View
    /// - top: Top Stack View
    public enum Position {
        case left, right, bottom, top
    }

    // MARK: Initialization

    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup

    /// Sets up the default properties
    open func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fill
        alignment = .bottom
    }

}
