//
//  Kingfisher.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/15/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import Kingfisher

extension UIImageView {

    func setImage(with resource: URL?, placeholder: UIImage? = nil) {
        let optionInfo: KingfisherOptionsInfo = [
            .transition(.fade(0.25)),
            .cacheOriginalImage
        ]

        kf.setImage(with: resource, placeholder: placeholder, options: optionInfo)
    }
}
