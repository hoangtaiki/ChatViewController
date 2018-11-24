//
//  HeaderRefreshAnimator.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 8/10/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

open class HeaderRefreshAnimator: UIView, HeaderRefreshDelegate {

    public let spinner = UIActivityIndicatorView(style: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleWidth

        addSubview(spinner)
        spinner.isHidden = true
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        spinner.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
    }

    open func headerRefreshAnimationDidStart(view: HeaderRefreshView) {
        spinner.isHidden = false
        spinner.startAnimating()
    }

    open func headerRefreshAnimationDidEnd(view: HeaderRefreshView) {
        spinner.isHidden = true
        spinner.stopAnimating()

    }
}
