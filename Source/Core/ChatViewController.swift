//
//  ChatViewController.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 5/18/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

public enum KeyboardType {
    case image
    case `default`
    case none
}

open class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ImagePickerResultDelegate {

    open var minimumChatBarHeight: CGFloat = 50
    open var customKeyboardHeight: CGFloat = 0
    open var configuration: ChatViewConfiguration = ChatViewConfiguration.default {
        didSet {
            if configuration.chatBarStyle == .default {
                minimumChatBarHeight = 50
            } else if configuration.chatBarStyle == .slack {
                minimumChatBarHeight = 91
            }
        }
    }

    public var currentKeyboardType: KeyboardType = .none {
        willSet {
            lastKeyboardType = currentKeyboardType
        }

        didSet {
            // Show image picker
            if currentKeyboardType == .image {
                chatBarView.galleryButton.isSelected = true
            } else {
                // Already switch frim image picker
                if lastKeyboardType == .image {
                    chatBarView.galleryButton.isSelected = false
                }
            }
        }
    }
    
    /// Store last keyboard type. Initialize value is .none
    public var lastKeyboardType: KeyboardType = .none

    /// Tableview
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0

        return tableView
    }()

    @objc public lazy var typingIndicatorView: TypingIndicatorView = {
        let typingIndicator = TypingIndicatorView()
        typingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return typingIndicator
    }()

    /// ChatBarView
    open var chatBarView: ChatBarView!
    /// ImagePickerView
    public var imagePickerView: ImagePickerView?

    /// Bottom constraint of UITableView and TypingIdicator
    public var tableViewBottomConstraint: NSLayoutConstraint!
    /// Bottom constraint of ChatBarView and view
    public var chatBarBottomConstraint: NSLayoutConstraint!
    /// Height constraint for ChatBarView
    public var chatBarHeightConstraint: NSLayoutConstraint!
    /// Top contraint between ChatImagePicker and ChatBarView.bottomAnchor
    public var imagePickerTopContraint: NSLayoutConstraint?
    /// Height contraint of ImagePickerView
    public var imagePickerHeightContraint: NSLayoutConstraint?
    /// Observe `isVisible` key for TypingIndicatorView
    public var observation: NSKeyValueObservation?
    /// TypingIndicator height contraint
    public var typingIndicatorHeightConstraint: NSLayoutConstraint!

    /// YES if the text inputbar is hidden. Default is NO.
    open var isCharBarHidden: Bool {
        get {
            return _isChatBarHidden
        }
        set {
            setChatBarHidden(newValue, animated: false)
        }
    }
    private var _isChatBarHidden = false


    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        customKeyboardHeight = Utils.shared.getCacheKeyboardHeight()

        setupSubviews()
        observerKeyboardEvents()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        imagePickerHeightContraint?.constant = customKeyboardHeight
        imagePickerView?.collectionView.updateUI()
    }

    open func setupSubviews() {
        setupChatBar()
        setupTypingIndicator()
        initTableView()
        
        if configuration.imagePickerType != .actionSheet {
            initImagePickerView()
        }
    }

    /// Setup for ChatBarView
    open func setupChatBar() {
        chatBarView = ChatBarView()
        chatBarView.textView.delegate = self
        chatBarView.maxChatBarHeight = configuration.maxChatBarHeight
        chatBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatBarView)

        // Setup constraint for chat bar
        chatBarHeightConstraint = chatBarView.heightAnchor.constraint(equalToConstant: minimumChatBarHeight)
        chatBarHeightConstraint?.isActive = true
        if #available(iOS 11.0, *) {
            chatBarBottomConstraint = chatBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            chatBarBottomConstraint = chatBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        chatBarBottomConstraint?.isActive = true
        chatBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chatBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // Setup chatbar style
        switch configuration.chatBarStyle {
        case .default:
            defaultChatBarStyle()
        case .slack:
            chatSlackBarStyle()
        case .other:
            break
        }
    }

    /// Keyboard
    open func keyboardControl(notification: Notification, isShowing: Bool) {
        animateKeyboard(notification: notification, isShowing: isShowing)
    }

    /// TableViewDataSource, TableViewDelegate
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    /// Send Button
    @objc open func didPressSendButton(_ sender: Any?) {
        chatBarView.textView.text = ""

        chatBarView.textViewCurrentHeight = minimumChatBarHeight - chatBarView.getAdditionalHeight()
        textViewDidChange(chatBarView.textView)
        controlExpandableInputView(showExpandable: true, from: 0, to: 0)
    }
    
    /// Gallery button
    @objc open func didPressGalleryButton(_ sender: Any?) {
        switch currentKeyboardType {
        case .none:
            currentKeyboardType = .image
            animateShowImagePicker()
        case .default:
            currentKeyboardType = .image
            chatBarView.textView.resignFirstResponderTimeAnimate = 0.0
            _ = chatBarView.textView.resignFirstResponder()
            guard let impkView = imagePickerView else {
                return
            }
            impkView.isHidden = false
            view.bringSubviewToFront(impkView)
        default:
            break
        }
    }
    
    /// Set hide/show for ChatBarView
    open func setChatBarHidden(_ hidden: Bool, animated: Bool) {
        if _isChatBarHidden == hidden { return }
        _isChatBarHidden = hidden

        if _isChatBarHidden {
            hideChatBar(animated: animated)
        } else {
            showChatView(animated: animated)
        }
    }

    // Hide chat bar
    open func hideChatBar(animated: Bool) {
        let animations = { [weak self] in
            self?.chatBarHeightConstraint.constant = 0
            self?.chatBarView.alpha = 0.0
            self?.view.layoutIfNeeded()
        }
        
        // Hide chat bar after animation finish
        let completion: (Bool) -> Void = { [weak self] (finished) in
            self?.chatBarView.isHidden = true
        }
        
        // We need also dismiss keyboard in case we are typing or select an image
        dismissKeyboard()
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: animations, completion: completion)
        } else {
            animations()
            completion(true)
        }
    }
    
    /// Show chat bar again
    open func showChatView(animated: Bool) {
        // Show chat bar before animating change height
        chatBarView.isHidden = false
        chatBarView.alpha = 0.0
        
        var chatBarHeight = chatBarView.textViewCurrentHeight + chatBarView.getAdditionalHeight()
        if chatBarView.textViewCurrentHeight == 0 {
            chatBarHeight = minimumChatBarHeight
        }
        let animations = { [weak self] in
            self?.chatBarHeightConstraint.constant = chatBarHeight
            self?.chatBarView.alpha = 1.0
            self?.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    /// Delegate for TextView inside ChatBarView
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        // Handle text change to expand chat bar view
        let contentHeight = textView.contentSize.height
        if contentHeight < chatBarView.maxTextViewHeight && chatBarView.textViewCurrentHeight != contentHeight {
            let oldHeight = chatBarView.textViewCurrentHeight
            chatBarView.textViewCurrentHeight = contentHeight
            if oldHeight != 0 {
                didChangeBarHeight(from: oldHeight, to: contentHeight)
            }
        }
        
        // Handle enable/disable hide/show send button
        switch configuration.chatBarStyle {
        case .default:
            UIView.animate(withDuration: 0.15) {
                self.chatBarView.rightStackView.isHidden = textView.text.isEmpty
            }
        case .slack:
            chatBarView.sendButton.isEnabled = !textView.text.isEmpty
        case .other:
            break
        }
    }
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        showDefaultKeyboard()
        
        UIView.setAnimationsEnabled(false)
        let range = NSMakeRange(textView.text.count - 1, 1)
        textView.scrollRangeToVisible(range)
        UIView.setAnimationsEnabled(true)
        return true
    }
    
    open func didSelectImage(url: URL?) {
        
    }
    
    open func didSelectVideo(url: URL?) {
        
    }
    
    deinit {
        removeObserverKeyboardEvents()
    }

}

extension ChatViewController {

    private func chatSlackBarStyle() {
        chatBarView.sendButton
            .configure { [weak self] in
                $0.size = CGSize(width: 50, height: 30)
                $0.layer.cornerRadius = 6
                $0.layer.borderWidth = 1
                $0.layer.borderColor = self?.configuration.sendButtonDeSelectedColor.cgColor
                $0.titleLabel?.textColor = self?.configuration.sendButtonDeSelectedColor
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
            }
            .onEnabled { [weak self] in
                $0.titleLabel?.textColor = .white
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.backgroundColor = self?.configuration.sendButtonSelectedColor
            }
            .onDisabled { [weak self] in
                $0.backgroundColor = .white
                $0.layer.borderColor = self?.configuration.sendButtonDeSelectedColor.cgColor
                $0.titleLabel?.textColor = self?.configuration.sendButtonDeSelectedColor
        }

        chatBarView.galleryButton
            .configure { [weak self] in
                $0.size = CGSize(width: 32, height: 38)
                var image = UIImage(named: "ic_gallery", in: Bundle.chatBundle, compatibleWith: nil)
                if let tempImage = image?.withRenderingMode(.alwaysTemplate) {
                    image = tempImage
                    $0.image = image
                    $0.tintColor = self?.configuration.galleryButtonDeSelectedColor
                }
            }
            .onSelected {
                $0.image = UIImage(named: "ic_gallery_selected", in: Bundle.chatBundle, compatibleWith: nil)
            }
            .onDeselected { [weak self] in
                var image = UIImage(named: "ic_gallery", in: Bundle.chatBundle, compatibleWith: nil)
                if let tempImage = image?.withRenderingMode(.alwaysTemplate) {
                    image = tempImage
                    $0.image = image
                    $0.tintColor = self?.configuration.galleryButtonDeSelectedColor
                }
        }

        chatBarView.sendButton.addTarget(self, action: #selector(didPressSendButton(_:)), for: .touchUpInside)
        chatBarView.galleryButton.addTarget(self, action: #selector(didPressGalleryButton(_:)), for: .touchUpInside)
        chatBarView.bottomStackView.isHidden = false
        chatBarView.leftStackView.isHidden = true
        chatBarView.rightStackView.isHidden = true

        let items = [.flexibleSpace, chatBarView.galleryButton, chatBarView.sendButton]
        chatBarView.bottomStackView.spacing = 16
        chatBarView.setStackViewItems(items, forStack: .bottom, animated: true)
    }

    private func defaultChatBarStyle() {
        // Hide send button default (we will hide right stack view)
        chatBarView.rightStackView.isHidden = true
        chatBarView.backgroundColor = configuration.chatBarBackgroundColor
        chatBarView.textView.backgroundColor = .white

        // Set up border for textview
        chatBarView.textView.layer.cornerRadius = 6
        chatBarView.textView.layer.borderWidth = 1
        chatBarView.textView.layer.borderColor = configuration.textInputBarBorderColor.cgColor
        chatBarView.centerStackView.spacing = 8
        chatBarView.sendButton
            .configure { [weak self] in
                $0.setTitleColor(self?.configuration.sendButtonSelectedColor, for: .normal)
                $0.size = CGSize(width: 40, height: 38)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
            }
        chatBarView.sendButton.isEnabled = true

        chatBarView.galleryButton
            .configure { [weak self] in
                $0.size = CGSize(width: 32, height: 38)
                var image = UIImage(named: "ic_gallery", in: Bundle.chatBundle, compatibleWith: nil)
                if let tempImage = image?.withRenderingMode(.alwaysTemplate) {
                    image = tempImage
                    $0.image = image
                    $0.tintColor = self?.configuration.galleryButtonDeSelectedColor
                }
            }
            .onSelected {
                $0.image = UIImage(named: "ic_gallery_selected", in: Bundle.chatBundle, compatibleWith: nil)
            }
            .onDeselected { [weak self] in
                var image = UIImage(named: "ic_gallery", in: Bundle.chatBundle, compatibleWith: nil)
                if let tempImage = image?.withRenderingMode(.alwaysTemplate) {
                    image = tempImage
                    $0.image = image
                    $0.tintColor = self?.configuration.galleryButtonDeSelectedColor
                }
        }

        chatBarView.sendButton.addTarget(self, action: #selector(didPressSendButton(_:)), for: .touchUpInside)
        chatBarView.galleryButton.addTarget(self, action: #selector(didPressGalleryButton(_:)), for: .touchUpInside)

        chatBarView.setStackViewItems([chatBarView.galleryButton], forStack: .left, animated: false)
        chatBarView.setStackViewItems([chatBarView.sendButton], forStack: .right, animated: false)
    }
}
