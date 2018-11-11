//
//  MessageCell+Facebook.swift
//  iOS Example
//
//  Created by Hoangtaiki on 11/11/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension MessageCell {
    
    /// Mask `roundedView` by an CAShapeLayer with a rectangle
    func roundViewWithStyle( _ style: RoundedViewType) {
        layoutIfNeeded()
        
        let bounds = roundedView.bounds
        let roundRadius: (tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat) = getRoundRadiusForStyle(style)
        let path = UIBezierPath(roundedRect: bounds,
                                topLeftRadius: roundRadius.tl,
                                topRightRadius: roundRadius.tr,
                                bottomLeftRadius: roundRadius.bl,
                                bottomRightRadius: roundRadius.br)
        path.lineJoinStyle = .round
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        
        roundedView.layer.mask = maskLayer
    }
    
    /// Get radius value for four corners
    func getRoundRadiusForStyle(_ style: RoundedViewType) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch style {
        case .topGroup:
            return (16, 16, 4, 16)
        case .centerGroup:
            return (4, 16, 4, 16)
        case .bottomGroup:
            return (4, 16, 16, 16)
        case .single:
            return (16, 16, 16, 16)
        }
    }
    
    /// Update space between message inside a group.
    /// Message in group should be closer
    func updateLayoutForGroupMessage(style: RoundedViewType) {
        switch style {
        case .topGroup:
            bottomAnchorContentView.constant = -spaceInsideGroup
        case .centerGroup:
            topAnchorContentView.constant = spaceInsideGroup
            bottomAnchorContentView.constant = -spaceInsideGroup
        case .bottomGroup:
            topAnchorContentView.constant = spaceInsideGroup
        default:
            topAnchorContentView.constant = contentInset.top
            bottomAnchorContentView.constant = -contentInset.bottom
        }
    }
}
