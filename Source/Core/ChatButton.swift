//
//  ChatButton.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 5/18/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

public class ChatButton: UIButton {
    
    public enum Spacing {
        case fixed(CGFloat)
        case flexible
        case none
    }
    
    public typealias ChatButtonAction = ((ChatButton) -> Void)
    
    /// Determind spacing. Depend on ContentHuggingPriority
    open var spacing: Spacing = .none {
        didSet {
            switch spacing {
            case .flexible:
                setContentHuggingPriority(.defaultLow, for: .horizontal)
            case .fixed:
                setContentHuggingPriority(.required, for: .horizontal)
            case .none:
                setContentHuggingPriority(.defaultHigh, for: .horizontal)
            }
        }
    }
    
    public static var flexibleSpace: ChatButton {
        let item = ChatButton()
        item.size = .zero
        item.spacing = .flexible
        return item
    }
    
    public static func fixedSpace(_ width: CGFloat) -> ChatButton {
        let item = ChatButton()
        item.size = .zero
        item.spacing = .fixed(width)
        return item
    }
    
    open var size: CGSize? = CGSize(width: 20, height: 20) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Used to setup your own initial properties
    ///
    /// - Parameter item: A reference to Self
    /// - Returns: Self
    @discardableResult
    open func configure(_ item: ChatButtonAction) -> Self {
        item(self)
        return self
    }
    
    /// The title for the UIControlState
    open var title: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    /// The image for the UIControlState
    open var image: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = size ?? super.intrinsicContentSize
        switch spacing {
        case .fixed(let width):
            contentSize.width += width
        case .flexible, .none:
            break
        }
        return contentSize
    }
    
    /// Calls the onEnabledAction or onDisabledAction when set
    open override var isEnabled: Bool {
        didSet {
            if isEnabled {
                onEnabledAction?(self)
            } else {
                onDisabledAction?(self)
            }
        }
    }
    
    open override var isSelected: Bool {
        didSet {
            if isSelected {
                onSelectedAction?(self)
            } else {
                onDeselectedAction?(self)
            }
        }
    }
    
    private var onTouchUpInsideAction: ChatButtonAction?
    private var onSelectedAction: ChatButtonAction?
    private var onDeselectedAction: ChatButtonAction?
    private var onEnabledAction: ChatButtonAction?
    private var onDisabledAction: ChatButtonAction?
    
    open func setup() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        adjustsImageWhenHighlighted = false
        translatesAutoresizingMaskIntoConstraints = false
        
        setTitleColor(.lightGray, for: .disabled)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        addTarget(self, action: #selector(ChatButton.touchUpInsideAction), for: .touchUpInside)
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @objc open func touchUpInsideAction() {
        onTouchUpInsideAction?(self)
    }
    
    /// Set the onTouchUpInsideAction
    @discardableResult
    open func onTouchUpInside(_ action: @escaping ChatButtonAction) -> Self {
        onTouchUpInsideAction = action
        return self
    }
    
    /// Set the onSelectedAction
    @discardableResult
    open func onSelected(_ action: @escaping ChatButtonAction) -> Self {
        onSelectedAction = action
        return self
    }
    
    /// Set the onDeselectedAction
    @discardableResult
    open func onDeselected(_ action: @escaping ChatButtonAction) -> Self {
        onDeselectedAction = action
        return self
    }
    
    /// Set the onEnabledAction
    @discardableResult
    open func onEnabled(_ action: @escaping ChatButtonAction) -> Self {
        onEnabledAction = action
        return self
    }
    
    /// Set the onDisabledAction
    @discardableResult
    open func onDisabled(_ action: @escaping ChatButtonAction) -> Self {
        onDisabledAction = action
        return self
    }
    
}
