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

        viewModel.firstLoadData { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
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
        cell.transform = tableView.transform
        cell.bind(withMessage: viewModel.messages[indexPath.row], user: user, style: style)

        return cell
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let textCell = cell as! MessageCell
        textCell.layoutIfNeeded()
        textCell.updateUIWithStyle(viewModel.getRoundStyleForMessageAtIndex(indexPath.row))
    }

    override func didPressSendButton(_ sender: Any?) {
        guard let currentUser = viewModel.currentUser else {
            return
        }

        let message = Message(id: UUID().uuidString, sendByID: currentUser.id,
                              createdAt: Date(), text: chatBarView.textView.text)
        addMessage(message)
        super.didPressSendButton(sender)
    }

}

extension MessageViewController {

    fileprivate func setupUI() {
        title = "Liliana"
        addBackBarButton()

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

        // Add function load more for table view
        tableView.addLoadMore { [weak self] in
            self?.viewModel.loadMoreData(completion: { indexPaths in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.tableView.beginUpdates()
                    // We will reload the last row before we add new message to display right bubblr type
                    let firstRow = indexPaths.first
                    let lastRow = IndexPath(row: firstRow!.row - 1, section: 0)
                    self?.tableView.reloadRows(at: [lastRow], with: .none)
                    self?.tableView.insertRows(at: indexPaths, with: .bottom)
                    self?.tableView.endUpdates()
                    self?.tableView.stopLoadMore()
                    self?.updateLoadMoreAble()
                }
            })
        }

        // Add function refresh for table view
        tableView.addFooterRefresh { [weak self] in
            self?.viewModel.firstLoadData {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.tableView.reloadData()
                    self?.tableView.stopFooterRefresh()
                    // After reload we should enable load more function
                    self?.tableView.setLoadMoreEnable(true)
                }
            }
        }
    }

    fileprivate func bindViewModel() {
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

    fileprivate func updateUI() {
        tableView.reloadData { [weak self] in
            self?.viewModel.isRefreshing = false
        }
    }

    fileprivate func addMessage(_ message: Message) {
        viewModel.messages.insert(message, at: 0)
        let needReloadLastCell = viewModel.messages.count > 0

        tableView.insertNewCell(atIndexPath: IndexPath(row: 0, section: 0), isNeedReloadLastItem: needReloadLastCell)
    }

    @objc fileprivate func handleTypingButton() {

        switch numberUserTypings {
        case 0, 1, 2:
            var user: User
            switch numberUserTypings {
            case 0:
                user = User(id: 1, name: "Harry")
            case 1:
                user = User(id: 2, name: "Bob")
            default:
                user = User(id: 3, name: "Liliana")
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

    fileprivate func updateLoadMoreAble() {
        tableView.setLoadMoreEnable(viewModel.pagination?.hasMore() ?? false)
    }
}
