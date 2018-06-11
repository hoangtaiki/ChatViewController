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
        tableView.bottomAnchor.constraint(equalTo: chatBarView.topAnchor).isActive = true
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
}

extension ChatViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}
