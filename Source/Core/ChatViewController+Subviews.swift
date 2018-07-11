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
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // Remove observer keyboard events
    func removeObserverKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: chatBarView.topAnchor).isActive = true
    }

    /// Hide all keyboard and then resignFirstResponse for TextView to call Keyboard appear
    @objc fileprivate func handleTapTableView(recognizer: UITapGestureRecognizer) {
        switch currentKeyboardType {
        case .default:
            chatBarView.textView.resignFirstResponderTimeAnimate = 0.25
            _ = chatBarView.textView.resignFirstResponder()
            currentKeyboardType = .none
        case .image:
            animateHideImagePicker(isNeedScrollTable: true)
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
            imagePickerView.isHidden = true
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
        let delta = from - to

        UIView.animate(withDuration: 0.3, animations: {
            let textHeight = showExpandable ? currentTextHeight : self.minimumChatBarHeight
            self.chatBarHeightConstraint?.constant = textHeight
            self.chatBarView.textView.contentOffset = .zero
            self.view.layoutIfNeeded()
            self.chatBarView.textView.setContentOffset(.zero, animated: false)
            self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y - delta)
        })
    }
    
    /// Animate show ChatBarView then setContentOffset for TableView
    /// Show keyboard from nothing
    // Handle keyboard show/hide notification to animation show ChatBarView
    func animateKeyboard(notification: Notification, isShowing: Bool) {
        var userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value

        let convertedFrame = view.convert(keyboardRect!, from: nil)
        var heightOffset = view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let beginFrameY = beginFrame?.origin.y ?? 0
        let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        var delta = abs(endFrameY - beginFrameY)

        let contentOffset = tableView.contentOffset.y

        if lastKeyboardType == .image && heightOffset == customKeyboardHeight {
            return
        }

        if currentKeyboardType == .image && !isShowing {
            return
        }

        // If chat bar is hidding and table is scrolled to bottom
        // We don't need change table contentOffset
        if #available(iOS 11.0, *) {
            delta -= view.safeAreaInsets.bottom
        }

        // When keyboard hide if keyboard height more than current content offset
        // We will assign detail by contentOffset
        if !isShowing && delta > contentOffset {
            delta = contentOffset
        }

        // Check value to detect direction of motion
        if beginFrameY > endFrameY {
            delta = -delta
        }

        // Everytime keyboard show. We will check keyboard height change or not to update image picker view size
        if isShowing {
            updateHeightForImagePicker(keyboardHeight: heightOffset)
        }

        // The height offset we need update constraint for chat bar to make it always above keyboard
        if isShowing {
            if #available(iOS 11.0, *) {
                heightOffset -= view.safeAreaInsets.bottom
            }
        } else {
            heightOffset = 0
        }

        UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
            self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y - delta)
            self.chatBarBottomConstraint?.constant = -heightOffset
            self.view.layoutIfNeeded()
        }, completion: nil)

        if isShowing {
            currentKeyboardType = .default
        }

    }
}

/// ImagePickerView
extension ChatViewController: ChatBarViewDelegate {

    /// Setup for ImagePicker
    func initImagePickerView() {
        imagePickerView = ImagePickerView()
        imagePickerView.isHidden = true
        imagePickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagePickerView)

        imagePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imagePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imagePickerTopContraint = imagePickerView.topAnchor.constraint(equalTo: chatBarView.bottomAnchor)
        imagePickerTopContraint.isActive = true
        imagePickerHeightContraint = imagePickerView.heightAnchor.constraint(equalToConstant: customKeyboardHeight)
        imagePickerHeightContraint.isActive = true
    }

    /// Gallery button
    @objc open func didPressGalleryButton(_ sender: Any?) {
        switch currentKeyboardType {
        case .none:
            currentKeyboardType = .image
            animateShowImagePicker(isNeedScrollTable: true)
        case .default:
            currentKeyboardType = .image
            imagePickerView.isHidden = false
            chatBarView.textView.resignFirstResponderTimeAnimate = 0.0
            _ = chatBarView.textView.resignFirstResponder()
            view.bringSubview(toFront: imagePickerView)
        //animateShowImagePicker(isNeedScrollTable: false)
        default:
            break
        }
        //chatBarView.textView.resignFirstResponder()
        //chatBarView.textView.isHidden = false

    }
    
    func handleShowImagePicker() {
        switch currentKeyboardType {
        case .image:
            return
        case .default:
            break
        case .none:
            animateShowImagePicker(isNeedScrollTable: true)
        }
    }
    
    func updateHeightForImagePicker(keyboardHeight: CGFloat) {
        var imagePickerContainerHeight = keyboardHeight
        var tempHeight: CGFloat

        if #available(iOS 11.0, *) {
            imagePickerContainerHeight -= view.safeAreaInsets.bottom
            tempHeight = imagePickerContainerHeight + view.safeAreaInsets.bottom
        } else {
            tempHeight = imagePickerContainerHeight
        }

        if tempHeight == customKeyboardHeight {
            return
        }

        customKeyboardHeight = tempHeight

        /// Store keyboardheight into cache
        Utils.shared.cacheKeyboardHeight(customKeyboardHeight)

        DispatchQueue.main.async {
            /// Temporary update UI for ImagePicker
            self.imagePickerHeightContraint.constant = self.customKeyboardHeight
            self.imagePickerView.layoutSubviews()
            self.imagePickerView.collectionView.updateUI()
        }
    }

    func animateShowImagePicker(isNeedScrollTable: Bool) {
        tableView.stopScrolling()
        imagePickerView.isHidden = false
        imagePickerView.collectionView.resetUI()

        var heightAnimate: CGFloat
        if #available(iOS 11.0, *) {
            heightAnimate = -self.customKeyboardHeight + self.view.safeAreaInsets.bottom
        } else {
            heightAnimate = -self.customKeyboardHeight
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.chatBarBottomConstraint.constant = -self.customKeyboardHeight
            if isNeedScrollTable {
                self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y - heightAnimate)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func animateHideImagePicker(isNeedScrollTable: Bool) {
        tableView.stopScrolling()
        var tableViewOffsetChange: CGFloat
        var heightAnimate: CGFloat


        if #available(iOS 11.0, *) {
            heightAnimate = self.view.safeAreaInsets.bottom
            tableViewOffsetChange = -self.customKeyboardHeight + self.view.safeAreaInsets.bottom
        } else {
            heightAnimate = 0
            tableViewOffsetChange = -self.customKeyboardHeight
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.chatBarBottomConstraint.constant = heightAnimate
            if isNeedScrollTable {
                self.tableView.contentOffset = CGPoint(x: 0, y: self.tableView.contentOffset.y + tableViewOffsetChange)
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.imagePickerView.isHidden = true
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

extension ChatViewController {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = Int(tableView.frame.size.height)
        let contentYoffset = tableView.contentOffset.y
        let distanceFromBottom = tableView.contentSize.height - contentYoffset

        /// We need round distanceFromBottom to fix issue with iPhoneX
        if Int(distanceFromBottom) <= height {
            isAtBottomTable = true
        } else {
            isAtBottomTable = false
        }
    }
}
