//
//  MessageImageCell.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/14/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit
import Kingfisher
import ChatViewController

class MessageImageCell: MessageCell {

    static var reuseIdentifier = "MessageImageCell"

    var attachImageView: UIImageView!
    var widthAnchorImageView: NSLayoutConstraint!
    var heightAnchorImageView: NSLayoutConstraint!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        attachImageView = UIImageView()
        attachImageView.contentMode = .scaleAspectFill
        attachImageView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        attachImageView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.addSubview(attachImageView)

        attachImageView.topAnchor.constraint(equalTo: roundedView.topAnchor).isActive = true
        attachImageView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor).isActive = true
        attachImageView.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor).isActive = true
        attachImageView.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor).isActive = true

        widthAnchorImageView = attachImageView.widthAnchor.constraint(equalToConstant: 100)
        widthAnchorImageView.isActive = true
        heightAnchorImageView = attachImageView.heightAnchor.constraint(equalToConstant: 100)
        heightAnchorImageView.priority = UILayoutPriority(999)
        heightAnchorImageView.isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        attachImageView.image = nil
        attachImageView.backgroundColor = .red
    }

    override func bind(withMessage message: Message, user: User) {
        attachImageView.setImage(with: message.file?.previewURL)
        avatarImageView.setImage(with: user.avatarURL)

        updateImage(width: message.file!.width, height: message.file!.height)
        tranformUI(message.isOutgoing)
    }

    override func tranformUI(_ isOutgoingMessage: Bool) {
        super.tranformUI(isOutgoingMessage)

        attachImageView.transform = contentTranform
    }

}

extension MessageImageCell {

    /// Display the image with the aspect ratio that corresponds to the actual size of the image.
    fileprivate func updateImage(width: CGFloat, height: CGFloat) {
        let proportionalSize: (width: CGFloat, height: CGFloat) = calculateProportionalSize(width: width, height: height)

        widthAnchorImageView.constant = proportionalSize.width
        heightAnchorImageView.constant = proportionalSize.height
    }

    /// Calculate proportional size with same aspect ratio
    fileprivate func calculateProportionalSize(width: CGFloat, height: CGFloat) -> (CGFloat, CGFloat) {
        var imageResizeHeight: CGFloat
        var imageResizeWidth = maxContentWidth
        let imageRatio = height / width

        if width > height {
            imageResizeHeight = CGFloat(Int(imageResizeWidth * imageRatio))
        } else {
            imageResizeHeight = imageResizeWidth
            imageResizeWidth = CGFloat(Int(imageResizeWidth / imageRatio))
        }

        return (imageResizeWidth, imageResizeHeight)
    }
}
