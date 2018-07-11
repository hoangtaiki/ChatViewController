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

        tableView.reloadData { [unowned self] in
            self.tableView.scrollToLastCell()
        }
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
        tableView.keyboardDismissMode = .none
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

            guard let _ = image, let _ = url else {
                return
            }

            guard let strongSelf = self else {
                return
            }

            let fileInfoThree = FileInfo(id: UUID().uuidString,
                                         type: FileType.image,
                                         previewURL: URL(string: "https://i.imgur.com/guoLF69.jpg"),
                                         createdAt: Date(),
                                         width: 768,
                                         height: 1024)
            let imageMessageThree = Message(type: .file,
                                            sendByID: 2.description,
                                            createdAt: Date(),
                                            file: fileInfoThree,
                                            isOutgoingMessage: true)

            DispatchQueue.main.async {
                strongSelf.addMessage(imageMessageThree)
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
        let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
        let needReloadLastCell = viewModel.messages.count > 0

        tableView.insertNewCell(atIndexPath: indexPath, isNeedReloadLastItem: needReloadLastCell) { [unowned self] in
            self.tableView.scrollToLastCell()
        }
    }
}
