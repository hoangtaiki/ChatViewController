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
    
    public func insertNewCell(atIndexPath indexPath: IndexPath, isNeedReloadLastItem: Bool, completion: (() -> ())) {
        beginUpdates()
        insertRows(at: [indexPath], with: .bottom)
        if isNeedReloadLastItem {
            let lastIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
            reloadRows(at: [lastIndexPath], with: .none)
        }
        endUpdates()

        completion()
    }

    public func scrollToFirstCell() {
        if numberOfSections > 0 {
            if numberOfRows(inSection: 0) > 0 {
                scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }

    public func scrollToLastCell() {
        if numberOfSections > 0 {
            let nRows = numberOfRows(inSection: numberOfSections - 1)
            if nRows > 0 {
                scrollToRow(at: IndexPath(row: nRows - 1, section: numberOfSections - 1), at: .bottom, animated: true)
            }
        }
    }

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

    public func scrolledToBottom() -> Bool {
        return contentOffset.y >= (contentSize.height - bounds.size.height)
    }


    
}
