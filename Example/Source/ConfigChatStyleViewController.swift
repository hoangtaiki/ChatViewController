//
//  ConfigChatStyleViewController.swift
//  iOS Example
//
//  Created by Hoangtaiki on 8/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import ChatViewController

class ConfigChatStyleViewController: UIViewController {

    @IBOutlet weak var chatBarStyleButton: UIButton!
    @IBOutlet weak var imagePickerTypeButton: UIButton!
    @IBOutlet weak var bubbleImageStyleButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!

    var chatBarStyle: ChatBarStyle = .default {
        didSet {
            chatBarStyleButton.setTitle(chatBarStyle.description, for: .normal)
        }
    }
    var imagePickerType: ImagePickerType = .insideChatBar {
        didSet {
            imagePickerTypeButton.setTitle(imagePickerType.description, for: .normal)
        }
    }
    var bubbleImageStyle: BubbleStyle = .facebook {
        didSet {
            bubbleImageStyleButton.setTitle(bubbleImageStyle.description, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Config Chat Style"

        chatBarStyleButton.setTitle(chatBarStyle.description, for: .normal)
        imagePickerTypeButton.setTitle(imagePickerType.description, for: .normal)
        bubbleImageStyleButton.setTitle(bubbleImageStyle.description, for: .normal)

        setUpButtonActions()
    }

    func setUpButtonActions() {
        chatBarStyleButton.addTarget(self, action: #selector(chatBarStyleTap(_:)), for: .touchUpInside)
        imagePickerTypeButton.addTarget(self, action: #selector(imagePickerTypeTap(_:)), for: .touchUpInside)
        bubbleImageStyleButton.addTarget(self, action: #selector(bubbleImageStyleTap(_:)), for: .touchUpInside)
        proceedButton.addTarget(self, action: #selector(proceedButtonTap(_:)), for: .touchUpInside)
    }

    @objc func chatBarStyleTap(_ sender: UIButton) {
        let sheet = UIAlertController(title: "Choose a style",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Default", style: .default, handler: { [weak self] _ in
            self?.chatBarStyle = .default
        }))
        sheet.addAction(UIAlertAction(title: "Slack", style: .default, handler: { [weak self] _ in
            self?.chatBarStyle = .slack
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(sheet, animated: true, completion: nil)
    }

    @objc func imagePickerTypeTap(_ sender: UIButton) {
        let sheet = UIAlertController(title: "Choose a type",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Default", style: .default, handler: { [weak self] _ in
            self?.imagePickerType = .insideChatBar
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(sheet, animated: true, completion: nil)
    }

    @objc func bubbleImageStyleTap(_ sender: UIButton) {
        let sheet = UIAlertController(title: "Choose a style",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Default", style: .default, handler: { [weak self] _ in
            self?.bubbleImageStyle = .facebook
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(sheet, animated: true, completion: nil)
    }

    @objc func proceedButtonTap(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let messageVC = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        messageVC.chatBarStyle = chatBarStyle

        navigationController?.pushViewController(messageVC, animated: true)
    }
}
