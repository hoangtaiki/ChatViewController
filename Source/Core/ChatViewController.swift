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

open class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    open var minimumChatBarHeight: CGFloat = 80
    open var customKeyboardHeight: CGFloat = 0

    public var currentKeyboardType: KeyboardType = .none {
        willSet {
            lastKeyboardType = currentKeyboardType
        }
    }
    public var lastKeyboardType: KeyboardType = .none

    /// Tableview
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
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
    public var imagePickerView: ImagePickerView!

    /// Bottom constraint of ChatBarView and view
    public var chatBarBottomConstraint: NSLayoutConstraint!
    /// Height constraint for ChatBarView
    public var chatBarHeightConstraint: NSLayoutConstraint!
    /// Top contraint between ChatImagePicker and ChatBarView.bottomAnchor
    public var imagePickerTopContraint: NSLayoutConstraint!
    /// Height contraint of ImagePickerView
    public var imagePickerHeightContraint: NSLayoutConstraint!
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
        automaticallyAdjustsScrollViewInsets = false
        customKeyboardHeight = Utils.shared.getCacheKeyboardHeight()

        setupSubviews()
        observerKeyboardEvents()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        imagePickerHeightContraint.constant = customKeyboardHeight
        imagePickerView.collectionView.updateUI()
    }

    open func setupSubviews() {
        setupChatBar()
        initTableView()
        setupTypingIndicator()
        initImagePickerView()
    }

    /// Setup for ChatBarView
    open func setupChatBar() {
        chatBarView = ChatBarView()
        chatBarView.delegate = self
        chatBarView.maxChatBarHeight = 200
        chatBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatBarView)

        chatBarView.sendButton
            .configure {
                $0.layer.cornerRadius = 6
                $0.layer.borderWidth = 1
                $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                $0.setTitleColor(.white, for: .normal)
                $0.setTitleColor(.white, for: .highlighted)
                $0.size = CGSize(width: 50, height: 30)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
            }
            .onEnabled {
                $0.titleLabel?.textColor = .white
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.backgroundColor = UIColor(red: 45/255, green: 158/255, blue: 224/255, alpha: 1)
            }
            .onDisabled {
                $0.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
                $0.titleLabel?.textColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
                $0.backgroundColor = .white
            }

        chatBarView.galleryButton
            .configure {
                $0.size = CGSize(width: 28, height: 22)
            }
            .onEnabled {
                var image = UIImage.init(named: "ic_gallery", in: Bundle.chatBundle, compatibleWith: nil)
                if let tempImage = image?.withRenderingMode(.alwaysTemplate) {
                    image = tempImage
                    $0.image = image
                    $0.tintColor = UIColor.gray
                }
            }
        
        chatBarView.sendButton.addTarget(self, action: #selector(didPressSendButton(_:)), for: .touchUpInside)
        chatBarView.galleryButton.addTarget(self, action: #selector(didPressGalleryButton(_:)), for: .touchUpInside)
        chatBarView.bottomStackView.isHidden = false

        let items = [.flexibleSpace, chatBarView.galleryButton, chatBarView.sendButton]
        items.forEach { $0.tintColor = .lightGray }
        chatBarView.bottomStackView.spacing = 16
        chatBarView.setStackViewItems(items, forStack: .bottom, animated: true)

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
        chatBarView.textViewDidChange(chatBarView.textView)
        controlExpandableInputView(showExpandable: true, from: 0, to: 0)
    }
    
    /// Set hide/show for ChatBarView
    open func setChatBarHidden(_ hidden: Bool, animated: Bool) {
        if _isChatBarHidden == hidden { return }

        chatBarView.isHidden = hidden
        _isChatBarHidden = hidden

        let animations = { [weak self] in
            self?.chatBarHeightConstraint.constant = hidden ? 0 : (self?.chatBarView.textViewCurrentHeight ?? 0.0)
            self?.view.layoutIfNeeded()
        }

        let completion = { [weak self] (finished: Bool) in
            if hidden {
                //self?.dismissKeyboard(animated: true)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: animations, completion: completion)
        } else {
            animations()
            completion(false)
        }
    }

    deinit {
        removeObserverKeyboardEvents()
    }

}
