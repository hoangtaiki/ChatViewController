//
//  UIScrollView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 5/18/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension UIScrollView {

    ///  YES if the scrollView's offset is at the very top.
    public var isAtTop: Bool {
        get { return contentOffset.y == 0.0 ? true : false }
    }

    ///  YES if the scrollView's offset is at the very bottom.
    public var isAtBottom: Bool {
        get {
            let bottomOffset = contentSize.height - bounds.size.height
            return contentOffset.y == bottomOffset ? true : false
        }
    }

    ///  YES if the scrollView can scroll from it's current offset position to the bottom.
    public var canScrollToBottom: Bool {
        get { return contentSize.height > bounds.size.height ? true : false }
    }


    /// Sets the content offset to the top.
    ///
    /// - parameter animated: animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
    public func scrollToTopAnimated(_ animated: Bool) {
        if !isAtTop {
            let bottomOffset = CGPoint.zero
            setContentOffset(bottomOffset, animated: animated)
        }
    }

    /// Sets the content offset to the bottom.
    ///
    /// - parameter animated: animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
    public func scrollToBottomAnimated(_ animated: Bool) {
        if canScrollToBottom && !isAtBottom {
            let bottomOffset = CGPoint(x: 0.0, y: contentSize.height - bounds.size.height)
            setContentOffset(bottomOffset, animated: animated)
        }
    }

    /// Stops scrolling, if it was scrolling.
    public func stopScrolling() {
        guard isDragging else {
            return
        }
        var offset = self.contentOffset
        offset.y -= 1.0
        setContentOffset(offset, animated: false)

        offset.y += 1.0
        setContentOffset(offset, animated: false)
    }
}
