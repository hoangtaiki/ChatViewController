//
//  UITableView.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 6/18/18.
//

import UIKit

public extension UITableView {

    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func scrollToFirstCell() {
        if numberOfSections > 0 {
            if numberOfRows(inSection: 0) > 0 {
                scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }

    func scrollToLastCell(animated: Bool) {
        if numberOfSections > 0 {
            let nRows = numberOfRows(inSection: numberOfSections - 1)
            if nRows > 0 {
                scrollToRow(at: IndexPath(row: nRows - 1, section: numberOfSections - 1), at: .bottom, animated: animated)
            }
        }
    }

    func stopScrolling() {
        guard isDragging else {
            return
        }
        var offset = self.contentOffset
        offset.y -= 1.0
        setContentOffset(offset, animated: false)

        offset.y += 1.0
        setContentOffset(offset, animated: false)
    }

    func scrolledToBottom() -> Bool {
        return contentOffset.y >= (contentSize.height - bounds.size.height)
    }
}
