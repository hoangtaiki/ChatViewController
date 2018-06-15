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
        let message = viewModel.messages[indexPath.row]
        let cellIdentifer = message.cellIdentifer()
        let user = viewModel.getUserFromID(message.sendByID)
        let style = viewModel.getRoundStyleForMessageAtIndex(indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer,
                                                 for: indexPath) as! MessageCell
        cell.bind(withMessage: viewModel.messages[indexPath.row], user: user, style: style)

        return cell
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let textCell = cell as! MessageCell
        textCell.layoutIfNeeded()
        textCell.updateUIWithStyle(viewModel.getRoundStyleForMessageAtIndex(indexPath.row))
    }

    func setupUI() {
        title = "Liliana"

        /// Tableview
        tableView.estimatedRowHeight = 88
        tableView.keyboardDismissMode = .interactive
        tableView.register(MessageTextCell.self, forCellReuseIdentifier: MessageTextCell.reuseIdentifier)
        tableView.register(MessageImageCell.self, forCellReuseIdentifier: MessageImageCell.reuseIdentifier)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "ic_typing"),
                            style: .plain,
                            target: self,
                            action: #selector(handleTypingButton))
        ]
    }

    func bindViewModel() {
        /// Image Picker Result closure
        imagePickerView.pickImageResult = { [weak self] image, url, error in
            if error != nil {
                return
            }

            guard let im = image, let _ = url else {
                return
            }

            guard let strongSelf = self else {
                return
            }

            let fileInfo = FileInfo(id: UUID().uuidString,
                                    type: FileType.image,
                                    previewURL: nil,
                                    createdAt: Date(),
                                    width: im.size.width,
                                    height: im.size.height,
                                    image: im)
            let message = Message(type: .file,
                                  sendByID: strongSelf.viewModel.currentUser.id,
                                  createdAt: Date(),
                                  file: fileInfo,
                                  isOutgoingMessage: true)

            DispatchQueue.main.async {
                strongSelf.addMessage(message)
                print("Pick image successfully")
            }
        }

    }

    override func didPressSendButton(_ sender: Any?) {
        let message = Message(type: .text, sendByID: viewModel.currentUser.id, createdAt: Date(), text: chatBarView.textView.text)
        addMessage(message)
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

extension MessageViewController {

    func addMessage(_ message: Message) {
        viewModel.messages.append(message)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: viewModel.messages.count - 1, section: 0)], with: .bottom)
        tableView.endUpdates()
    }
}
