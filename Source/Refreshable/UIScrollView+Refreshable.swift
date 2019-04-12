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
private var footerRefreshKey: UInt8 = 0
public let footerRefreshDefaultHeight: CGFloat = 50


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
    func addLoadMore(action: @escaping (() -> ())) {
        let size = CGSize(width: self.frame.size.width, height: headerRefreshDefaultHeight)
        let frame = CGRect(origin: .zero, size: size)
        headerRefreshView = HeaderRefreshView(action: action, frame: frame)
        headerRefreshView?.autoresizingMask = [.flexibleWidth]

        addSubview(headerRefreshView!)
    }

    // Start load more
    func startLoadMore() {
        headerRefreshView?.isLoading = true
    }

    // Stop load more
    func stopLoadMore() {
        headerRefreshView?.isLoading = false
    }

    // Set enable/disable for loading more
    func setLoadMoreEnable(_ enable: Bool) {
        headerRefreshView?.isEnabled = enable
    }
}


/// Pull To Refresh
public extension UIScrollView {

    private var footerRefreshView: FooterRefreshView? {
        get {
            return objc_getAssociatedObject(self, &footerRefreshKey) as? FooterRefreshView
        }
        set {
            footerRefreshView?.removeFromSuperview()
            objc_setAssociatedObject(self, &footerRefreshKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // Add pull to refresh view with default animator
    func addFooterRefresh(action: @escaping (() -> ())) {
        let origin = CGPoint(x: 0, y: -footerRefreshDefaultHeight)
        let size = CGSize(width: self.frame.size.width, height: footerRefreshDefaultHeight)
        let frame = CGRect(origin: origin, size: size)
        footerRefreshView = FooterRefreshView(action: action, frame: frame)

        addSubview(footerRefreshView!)
    }

    // Start pull to refresh
    func startFooterRefresh() {
        footerRefreshView?.isLoading = true
    }

    // Stop pull to refresh
    func stopFooterRefresh() {
        footerRefreshView?.isLoading = false
    }
}
