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
    func roundViewWithStyle( _ style: RoundedViewType, bubbleStyle: BubbleStyle) {
        layoutIfNeeded()
        
        let bounds = roundedView.bounds
        let roundRadius: (tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat) = getRoundRadiusForStyle(style, bubbleStyle: bubbleStyle)
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
    func getRoundRadiusForStyle(_ style: RoundedViewType, bubbleStyle: BubbleStyle) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        // For instagram
        if bubbleStyle == .instagram {
            return (16, 16, 16, 16)
        }
        
        // For facebook bubble style
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
    func updateLayoutForGroupMessage(style: RoundedViewType, bubbleStyle: BubbleStyle) {
        // For instagram
        if bubbleStyle == .instagram {
            topAnchorContentView.constant = instaContentInset.top
            bottomAnchorContentView.constant = -instaContentInset.bottom
        } else {
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
}
