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
    var numberUserTypings = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextCell.reuseIdentifier,
                                                 for: indexPath) as! MessageTextCell
        let message = viewModel.messages[indexPath.row]
        let user = viewModel.getUserFromID(message.sendByID)
        let style = viewModel.getRoundStyleForMessageAtIndex(indexPath.row)
    
        cell.bind(withMessage: viewModel.messages[indexPath.row], user: user, style: style)

        return cell
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let textCell = cell as! MessageTextCell
        textCell.layoutIfNeeded()
        textCell.updateUIWithStyle(viewModel.getRoundStyleForMessageAtIndex(indexPath.row))
    }

    func setupUI() {
        title = "Liliana"

        /// Tableview
        tableView.estimatedRowHeight = 88
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(MessageTextCell.self, forCellReuseIdentifier: MessageTextCell.reuseIdentifier)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "ic_typing"),
                            style: .plain,
                            target: self,
                            action: #selector(handleTypingButton))
        ]
    }

    func bindViewModel() {
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

    @objc func handleTypingButton() {

        switch numberUserTypings {
        case 0, 1, 2:
            var user: User
            switch numberUserTypings {
            case 0:
                user = User(id: "1", name: "Harry", image: #imageLiteral(resourceName: "ic_boy"))
            case 1:
                user = User(id: "2", name: "Bob", image: #imageLiteral(resourceName: "ic_boy"))
            default:
                user = User(id: "3", name: "Liliana", image: #imageLiteral(resourceName: "ic_girl"))
            }
            viewModel.users.append(user)
            typingIndicatorView.insertUser(user)
            numberUserTypings += 1
        default:
            for user in viewModel.users {
                typingIndicatorView.removeUser(user)
            }
            numberUserTypings = 0
            break
        }
    }
}

