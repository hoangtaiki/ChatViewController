//
//  UIViewController.swift
//  iOS Example
//
//  Created by Hoangtaiki on 8/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension UIViewController {

    public func addBackBarButton() {
        let image = UIImage(named: "ic_nav_back")
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(tappedOnBackBarButton(sender:)))
        navigationItem.leftBarButtonItem = button
    }

    @objc open func tappedOnBackBarButton(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}
