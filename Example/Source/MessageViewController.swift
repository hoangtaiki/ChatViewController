//
//  ViewController.swift
//  iOS Example
//
//  Created by Hoangtaiki on 5/17/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import ChatViewController

class MessageViewController: ChatViewController {

    var viewModel = MessageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextCell.reuseIdentifier, for: indexPath) as! MessageTextCell
        cell.bind(withMessage: viewModel.messages[indexPath.row])

        return cell
    }

    func setupUI() {
        tableView.estimatedRowHeight = 88
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.register(MessageTextCell.nib(), forCellReuseIdentifier: MessageTextCell.reuseIdentifier)

        /// Image Picker Result closure
        imagePickerView.pickImageResult = { image, url, error in
            if error != nil {
                return
            }

            guard let _ = image, let _ = url else {
                return
            }

            print("Pick image successfully")
        }
    }

    override func didPressSendButton(_ sender: Any?) {
        let message = Message(type: .text, sendByID: "", createdAt: Date(), text: chatBarView.textView.text)
        viewModel.messages.append(message)
        tableView.insertRows(at: [IndexPath(row: viewModel.messages.count - 1, section: 0)], with: .bottom)
        super.didPressSendButton(sender)
    }
}

