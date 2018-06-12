//
//  ChatViewController+Subviews.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 5/18/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension ChatViewController {

    /// Set up for TableView
    func initTableView() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.delegate = self
        tap.addTarget(self, action: #selector(handleTapTableView(recognizer:)))
        tableView.addGestureRecognizer(tap)

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: typingIndicatorView.topAnchor).isActive = true
    }

    /// Add tap gesture on ChatBarView to resignFirstResponse for TextView
    fileprivate func addTapGestureIntoChatBar() {
        let textView: UITextView = chatBarView.textView
        let tap = UITapGestureRecognizer()
        textView.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(handleTapTextView(recognizer:)))
    }

    /// Hide all keyboard and then resignFirstResponse for TextView to call Keyboard appear
    @objc fileprivate func handleTapTableView(recognizer: UITapGestureRecognizer) {
        hideAllKeyboard()
    }

    /// Tap on tableview to hide keyboard
    @objc fileprivate func handleTapTextView(recognizer: UITapGestureRecognizer) {
        let textView: UITextView = chatBarView.textView
        textView.inputView = nil
        textView.becomeFirstResponder()
        textView.reloadInputViews()
    }


    /// Setup for ImagePicker
    func initImagePickerView() {
        imagePickerView = ImagePickerView()
        imagePickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagePickerView)

        imagePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imagePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imagePickerTopContraint = imagePickerView.topAnchor.constraint(equalTo: chatBarView.bottomAnchor)
        imagePickerTopContraint.isActive = true
        imagePickerView.heightAnchor.constraint(equalToConstant: customKeyboardHeight).isActive = true
    }

    func animateShowImagePicker() {
        tableView.stopScrolling()
        view.bringSubview(toFront: imagePickerView)

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                let heightOffset = self.imagePickerView.frame.size.height
                self.chatBarBottomConstraint.constant = -heightOffset

                self.view.layoutIfNeeded()
                self.tableView.scrollToBottomAnimated(false)
        },
            completion: { bool in
        })
    }


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
            self.tableView.scrollToBottomAnimated(true)
        })
    }


}

extension ChatViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}
