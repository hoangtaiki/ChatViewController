//
//  ChatViewController+Keyboard.swift
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
        tableView.scrollToBottomAnimated(false)
        keyboardControl(notification: notification, isShowing: true)
    }

    @objc func keyboardWillHide(notification: Notification) {
        keyboardControl(notification: notification, isShowing: false)
    }

    func hideAllKeyboard() {
        hideCustomKeyboard()
        chatBarView.resignKeyboard()
    }

    // Handle keyboard show/hide notification to animation show ChatBarView
    func animateKeyboard(notification: Notification, isShowing: Bool) {
        var userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value

        let convertedFrame = view.convert(keyboardRect!, from: nil)
        let heightOffset = view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        tableView.stopScrolling()
        chatBarBottomConstraint?.constant = -heightOffset

        UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
            if isShowing {
                self.tableView.scrollToBottomAnimated(false)
            }
        }, completion: nil)
    }

    // Dismisses the keyboard from any first responder in the window.
    func dismissKeyboard(animated: Bool) {
        if !chatBarView.textView.isFirstResponder && chatBarHeightConstraint.constant > 0.0 {
            view.window?.endEditing(false)
        }

        if !animated {
            UIView.performWithoutAnimation {
                chatBarView.textView.resignFirstResponder()
            }
        } else {
            chatBarView.textView.resignFirstResponder()
        }
    }

    // Hide all custom keyboard
    fileprivate func hideCustomKeyboard() {
        tableView.stopScrolling()
        chatBarBottomConstraint?.constant = 0

        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}

extension ChatViewController {

    /// Control
    func controlExpandableInputView(showExpandable: Bool) {
        let currentTextHeight = chatBarView.textViewCurrentHeight + chatBarView.getAdditionalHeight()

        UIView.animate(withDuration: 0.3, animations: {
            let textHeight = showExpandable ? currentTextHeight : self.minimumChatBarHeight
            self.chatBarHeightConstraint?.constant = textHeight
            self.chatBarView.textView.contentOffset = .zero
            self.view.layoutIfNeeded()
            self.tableView.scrollToBottomAnimated(true)
            self.chatBarView.textView.setContentOffset(.zero, animated: false)
        })
    }

}
