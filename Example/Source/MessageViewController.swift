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

    var viewModel: MessageViewModel!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! MessageCell
        let style = viewModel.getRoundStyleForMessageAtIndex(indexPath.row)

        cell.transform = tableView.transform
        cell.bind(withMessage: viewModel.messages[indexPath.row], user: user)
        cell.updateUIWithBubbleStyle(viewModel.bubbleStyle, isOutgoingMessage: message.isOutgoing)

        // Update style for
        switch viewModel.bubbleStyle {
        case .facebook:
            cell.updateLayoutForGroupMessage(style: style)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let chatCell = cell as! MessageCell
        let style = viewModel.getRoundStyleForMessageAtIndex(indexPath.row)

        chatCell.layoutIfNeeded()
        
        // Update UI for cell
        chatCell.showHideUIWithStyle(style, bubbleStyle: viewModel.bubbleStyle)
        chatCell.updateAvatarPosition(bubbleStyle: viewModel.bubbleStyle)

        // Update style for
        switch viewModel.bubbleStyle {
        case .facebook:
            chatCell.roundViewWithStyle(style)
        }
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

        // Set buttons
        let typingButton = UIButton(type: .custom)
        typingButton.setImage(UIImage(named: "ic_typing"), for: .normal)
        typingButton.addTarget(self, action:#selector(handleTypingButton), for:.touchUpInside)
        typingButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let typingButtonBarItem = UIBarButtonItem(customView: typingButton)
        
        let hideChatBarButton = UIButton(type: .custom)
        hideChatBarButton.setImage(UIImage(named: "ic_keyboard"), for: .normal)
        hideChatBarButton.addTarget(self, action:#selector(handleShowHideChatBar), for:.touchUpInside)
        hideChatBarButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let hideChatBarButtonItem = UIBarButtonItem(customView: hideChatBarButton)
        
        navigationItem.rightBarButtonItems = [typingButtonBarItem, hideChatBarButtonItem]

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

        // Insert new message cell
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.endUpdates()
        
        // Check if we have more than one message
        switch viewModel.bubbleStyle {
        case .facebook:
            if viewModel.messages.count <= 1 { return }
            reloadLastMessageCell()

        }
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
    
    @objc fileprivate func handleShowHideChatBar() {
        setChatBarHidden(!isCharBarHidden, animated: true)
    }

    fileprivate func updateLoadMoreAble() {
        tableView.setLoadMoreEnable(viewModel.pagination?.hasMore() ?? false)
    }
    
    fileprivate func reloadLastMessageCell() {
        tableView.beginUpdates()
        let lastIndexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: lastIndexPath) as! MessageCell
        let style = viewModel.getRoundStyleForMessageAtIndex(lastIndexPath.row)
        cell.updateLayoutForGroupMessage(style: style)
        cell.roundViewWithStyle(style)
        tableView.endUpdates()
    }
}
