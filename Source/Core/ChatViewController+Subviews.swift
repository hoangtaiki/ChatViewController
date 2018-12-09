//
//  ChatViewController+Subviews.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 5/18/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension ChatViewController {

    // Observer keyboard events
    func observerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Remove observer keyboard events
    func removeObserverKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        keyboardControl(notification: notification, isShowing: true)

    }

    @objc func keyboardWillHide(notification: Notification) {
        keyboardControl(notification: notification, isShowing: false)
    }
}

/// Tableview
extension ChatViewController {

    /// Set up for TableView
    func initTableView() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.addTarget(self, action: #selector(handleTapTableView(recognizer:)))
        tableView.addGestureRecognizer(tap)
        tableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: typingIndicatorView.topAnchor, constant: -8)
        tableViewBottomConstraint.isActive = true
    }

    /// Hide all keyboard and then resignFirstResponse for TextView to call Keyboard appear
    @objc fileprivate func handleTapTableView(recognizer: UITapGestureRecognizer) {
        dismissKeyboard()
    }

    public func dismissKeyboard() {
        switch currentKeyboardType {
        case .default:
            chatBarView.textView.resignFirstResponderTimeAnimate = 0.25
            _ = chatBarView.textView.resignFirstResponder()
            currentKeyboardType = .none
        case .image:
            animateHideImagePicker()
            currentKeyboardType = .none
        default:
            break
        }
    }
}


/// ChatBarView
extension ChatViewController {

    public func showDefaultKeyboard() {
        switch currentKeyboardType {
        case .none:
            currentKeyboardType = .default
        case .image:
            chatBarView.textView.becomeFirstResponderTimeAnimate = 0
            currentKeyboardType = .default
            imagePickerView?.isHidden = true
        default:
            break
        }
    }

    public func didChangeBarHeight(from: CGFloat, to: CGFloat) {
        controlExpandableInputView(showExpandable: true, from: from, to: to)
    }

    /// Control
    func controlExpandableInputView(showExpandable: Bool, from: CGFloat, to: CGFloat) {
        let currentTextHeight = chatBarView.textViewCurrentHeight + chatBarView.getAdditionalHeight()

        UIView.animate(withDuration: 0.3, animations: {
            let textHeight = showExpandable ? currentTextHeight : self.minimumChatBarHeight
            self.chatBarHeightConstraint?.constant = textHeight
            self.chatBarView.textView.contentOffset = .zero
            self.view.layoutIfNeeded()
            self.chatBarView.textView.setContentOffset(.zero, animated: false)
        })

    }
    
    /// Animate show ChatBarView then setContentOffset for TableView
    /// Show keyboard from nothing
    // Handle keyboard show/hide notification to animation show ChatBarView
    func animateKeyboard(notification: Notification, isShowing: Bool) {
        var userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value

        let convertedFrame = view.convert(keyboardRect!, from: nil)
        var heightOffset = view.bounds.size.height - convertedFrame.origin.y
        let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        // The height offset we need update constraint for chat bar to make it always above keyboard
        if isShowing {
            if #available(iOS 11.0, *) {
                heightOffset -= view.safeAreaInsets.bottom
            }
        } else {
            heightOffset = 0
        }

        // In case showing image picker view and switch to default keyboard
        // If image picker and keyboard has same height so that we don't need
        // animate chatbarview
        if lastKeyboardType == .image && heightOffset == customKeyboardHeight {
            return
        }

        // In case showing default keyboard and user touch gallery button and need
        // to show image picker.
        if currentKeyboardType == .image && !isShowing {
            return
        }

        // Everytime keyboard show. We will check keyboard height change or not to update image picker view size
        if isShowing && configuration.imagePickerType != .actionSheet {
            updateHeightForImagePicker(keyboardHeight: heightOffset)
        }

        UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
            self.chatBarBottomConstraint?.constant = -heightOffset
            self.view.layoutIfNeeded()
        }, completion: nil)

        if isShowing {
            currentKeyboardType = .default
        }

    }
}

/// ImagePickerView
extension ChatViewController {

    /// Setup for ImagePicker
    func initImagePickerView() {
        imagePickerView = ImagePickerView()
        imagePickerView!.isHidden = true
        imagePickerView!.pickerDelegate = self
        imagePickerView!.parentViewController = self
        imagePickerView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagePickerView!)

        imagePickerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imagePickerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imagePickerTopContraint = imagePickerView!.topAnchor.constraint(equalTo: chatBarView.bottomAnchor)
        imagePickerTopContraint!.isActive = true
        imagePickerHeightContraint = imagePickerView!.heightAnchor.constraint(equalToConstant: customKeyboardHeight)
        imagePickerHeightContraint!.isActive = true
    }
    
    func handleShowImagePicker() {
        switch currentKeyboardType {
        case .image:
            return
        case .default:
            break
        case .none:
            animateShowImagePicker()
        }
    }

    /// Update image picker height. We always try make image picker has size same with keyboard
    /// So that we will has different layout for different height
    /// We will cache keyboard height and update everytime keyboard change height (show/hide predictive bar)
    ///
    /// - parameter: keyboardHeight: current keyboard height
    func updateHeightForImagePicker(keyboardHeight: CGFloat) {
        // If current keyboard height is equal with last cached keyboard we will not
        // update image picker height and layout
        if keyboardHeight == customKeyboardHeight {
            return
        }

        customKeyboardHeight = keyboardHeight

        /// Store keyboardheight into cache
        Utils.shared.cacheKeyboardHeight(customKeyboardHeight)

        DispatchQueue.main.async {
            /// Temporary update UI for ImagePicker
            self.imagePickerHeightContraint?.constant = self.customKeyboardHeight
            self.imagePickerView?.layoutSubviews()
            self.imagePickerView?.collectionView.updateUI()
        }
    }

    /// Animate show image picker
    ///
    /// -parameter isNeedScrollTable: Need update tableview content offset or not
    func animateShowImagePicker() {
        tableView.stopScrolling()
        imagePickerView?.isHidden = false
        imagePickerView?.collectionView.resetUI()

        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.chatBarBottomConstraint.constant = -self.customKeyboardHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func animateHideImagePicker() {
        tableView.stopScrolling()

        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.chatBarBottomConstraint.constant = 0
            self.imagePickerView?.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.imagePickerView?.isHidden = true
            self.imagePickerView?.alpha = 1.0
        })
    }
}


/// TypingIndicator
extension ChatViewController {

    /// Setup TypingIndicator
    func setupTypingIndicator() {
        view.addSubview(typingIndicatorView)
        typingIndicatorView.isHidden = true
        observation = typingIndicatorView.observe(\TypingIndicatorView.isVisible) { [weak self] object, change in
            self?.animateTypeIndicatorView()
        }

        typingIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        typingIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        typingIndicatorView.bottomAnchor.constraint(equalTo: chatBarView.topAnchor).isActive = true
        typingIndicatorHeightConstraint = typingIndicatorView.heightAnchor.constraint(equalToConstant: 0.0)
        typingIndicatorHeightConstraint?.isActive = true
    }

    func animateTypeIndicatorView() {
        let height = typingIndicatorView.isVisible ? typingIndicatorView.viewHeight : 0.0

        typingIndicatorHeightConstraint.constant = height

        if typingIndicatorView.isVisible {
            typingIndicatorView.isHidden = false
        }

        UIView.animate(withDuration: 0.3, animations: {
            if !self.typingIndicatorView.isVisible {
                self.typingIndicatorView.isHidden = true
            }
            self.view.layoutIfNeeded()
        })
    }
}
