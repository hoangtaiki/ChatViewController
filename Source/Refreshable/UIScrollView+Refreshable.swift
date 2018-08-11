//
//  UIScrollView+Refreshable.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 8/10/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

private var headerRefreshKey: UInt8 = 1
public let headerRefreshDefaultHeight: CGFloat = 50

/// Infinity Scrolling
public extension UIScrollView {

    private var headerRefreshView: HeaderRefreshView? {
        get {
            return objc_getAssociatedObject(self, &headerRefreshKey) as? HeaderRefreshView
        }
        set {
            headerRefreshView?.removeFromSuperview()
            objc_setAssociatedObject(self, &headerRefreshKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Add load more view with default animator
    public func addLoadMore(action: @escaping (() -> ())) {
        let size = CGSize(width: self.frame.size.width, height: headerRefreshDefaultHeight)
        let frame = CGRect(origin: .zero, size: size)
        headerRefreshView = HeaderRefreshView(action: action, frame: frame)
        headerRefreshView?.autoresizingMask = [.flexibleWidth]

        addSubview(headerRefreshView!)
    }

    // Start load more
    public func startLoadMore() {
        headerRefreshView?.isLoading = true
    }

    // Stop load more
    public func stopLoadMore() {
        headerRefreshView?.isLoading = false
    }

    // Set enable/disable for loading more
    public func setLoadMoreEnable(_ enable: Bool) {
        headerRefreshView?.isEnabled = enable
    }
}
