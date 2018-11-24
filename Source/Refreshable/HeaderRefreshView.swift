//
//  HeaderRefreshView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 8/10/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

public protocol HeaderRefreshDelegate {
    func headerRefreshAnimationDidStart(view: HeaderRefreshView)
    func headerRefreshAnimationDidEnd(view: HeaderRefreshView)
}

public class HeaderRefreshView: UIView {

    // Default is true. When you set false load more view will be hide
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                frame = CGRect(x: 0, y: scrollView.contentSize.height, width: frame.size.width, height: height)
            } else {
                frame = CGRect(x: 0, y: scrollView.contentSize.height, width: frame.size.width, height: 0)
            }
        }
    }

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }

    private var height: CGFloat
    private var scrollView: UIScrollView!
    private var contentOffsetObservation: NSKeyValueObservation?
    private var contentSizeObservation: NSKeyValueObservation?
    private var panStateObservation: NSKeyValueObservation?

    private var animator: HeaderRefreshDelegate
    private var action: (() -> ()) = {}


    convenience init(action: @escaping (() -> ()), frame: CGRect) {
        var bounds = frame
        bounds.origin.y = 0
        let animator = HeaderRefreshAnimator(frame: bounds)
        self.init(frame: frame, animator: animator)
        self.action = action
        addSubview(animator)
    }

    convenience init(action: @escaping (() -> ()), frame: CGRect, animator: HeaderRefreshDelegate) {
        self.init(frame: frame, animator: animator)
        self.action = action
    }

    public init(frame: CGRect, animator: HeaderRefreshDelegate) {
        self.height = frame.height
        self.animator = animator
        super.init(frame: frame)
        self.autoresizingMask = .flexibleWidth
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if newSuperview == nil {
            removeKeyValueObervation()
        } else {
            guard newSuperview is UIScrollView else { return }

            scrollView = newSuperview as? UIScrollView
            scrollView.alwaysBounceVertical = true

            addKeyValueObservations()
        }
    }

    deinit {
        removeKeyValueObervation()
    }
}

extension HeaderRefreshView {

    private func startAnimating() {
        animator.headerRefreshAnimationDidStart(view: self)

        let frameHeight = frame.height
        let contentSizeHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.height
        let contentInsetBottom = scrollView.contentInset.bottom

        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset.y = frameHeight + contentSizeHeight - scrollViewHeight + contentInsetBottom
            self.scrollView.contentInset.bottom += frameHeight
        }, completion: { _ in
            self.action()
        })
    }

    private func stopAnimating() {
        animator.headerRefreshAnimationDidEnd(view: self)

        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentInset.bottom -= self.frame.height
            self.scrollView.setContentOffset(self.scrollView.contentOffset, animated: false)
        })
    }


    private func addKeyValueObservations() {
        contentOffsetObservation = scrollView.observe(\.contentOffset) { [weak self] scrollView, _ in
            self?.handleContentOffsetChange()
        }

        contentSizeObservation = scrollView.observe(\.contentSize) { [weak self] scrollView, _ in
            self?.handleContentSizeChange()
        }
    }

    private func removeKeyValueObervation() {
        contentOffsetObservation?.invalidate()
        contentSizeObservation?.invalidate()

        contentOffsetObservation = nil
        contentSizeObservation = nil
    }

    private func handleContentOffsetChange() {
        if isLoading || !isEnabled { return }

        if scrollView.contentSize.height <= scrollView.bounds.height { return }
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom {
            isLoading = true
        }
    }

    private func handleContentSizeChange() {
        frame = CGRect(x: 0, y: scrollView.contentSize.height, width: frame.size.width, height: frame.size.height)
    }
}
