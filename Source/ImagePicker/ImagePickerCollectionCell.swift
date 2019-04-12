//
//  ImagePickerCollectionCell.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

public final class ImagePickerCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = "ImagePickerCollectionCell"

    public var imageView: UIImageView!
    public var iconVideo: UIImageView!
    public var videoDurationLabel: UILabel!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        iconVideo.isHidden = true
        videoDurationLabel.isHidden = true
    }

    public func bindVideoDuration(duration: Double) {
        iconVideo.isHidden = false
        videoDurationLabel.isHidden = false
        
        let text = String(format:"%d:%02d:%02d",
                          Int(duration/3600),
                          Int((duration/60).truncatingRemainder(dividingBy: 60)),
                          Int(duration.truncatingRemainder(dividingBy: 60)))
        videoDurationLabel.text = text
    }
    
    private func setupUI() {
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        iconVideo = UIImageView()
        iconVideo.clipsToBounds = true
        iconVideo.contentMode = .scaleAspectFit
        iconVideo.translatesAutoresizingMaskIntoConstraints = false
        iconVideo.image = UIImage(named: "ic_video", in: Bundle.chatBundle, compatibleWith: nil)
        iconVideo.isHidden = true
        iconVideo.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconVideo.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)

        videoDurationLabel = UILabel()
        videoDurationLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        videoDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        videoDurationLabel.textColor = .white
        videoDurationLabel.text = "0:00:00"
        videoDurationLabel.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [videoDurationLabel, iconVideo])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 3
        addSubview(stackView)
        
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
    }
}
