//
//  UIBezierPath.swift
//  iOS Example
//
//  Created by Hoangtaiki on 6/13/18.
//  Copyright © 2018 toprating. All rights reserved.
//

import UIKit

extension UIBezierPath {

    public convenience init(roundedRect rect: CGRect,
                            topLeftRadius: CGFloat?,
                            topRightRadius: CGFloat?,
                            bottomLeftRadius: CGFloat?,
                            bottomRightRadius: CGFloat?) {
        self.init()

        assert(((bottomLeftRadius ?? 0) + (bottomRightRadius ?? 0)) <= rect.size.width)
        assert(((topLeftRadius ?? 0) + (topRightRadius ?? 0)) <= rect.size.width)
        assert(((topLeftRadius ?? 0) + (bottomLeftRadius ?? 0)) <= rect.size.height)
        assert(((topRightRadius ?? 0) + (bottomRightRadius ?? 0)) <= rect.size.height)

        // corner centers
        let tl = CGPoint(x: rect.minX + (topLeftRadius ?? 0), y: rect.minY + (topLeftRadius ?? 0))
        let tr = CGPoint(x: rect.maxX - (topRightRadius ?? 0), y: rect.minY + (topRightRadius ?? 0))
        let bl = CGPoint(x: rect.minX + (bottomLeftRadius ?? 0), y: rect.maxY - (bottomLeftRadius ?? 0))
        let br = CGPoint(x: rect.maxX - (bottomRightRadius ?? 0), y: rect.maxY - (bottomRightRadius ?? 0))

        //let topMidpoint = CGPoint(rect.midX, rect.minY)
        let topMidpoint = CGPoint(x: rect.midX, y: rect.minY)

        makeClockwiseShape: do {
            self.move(to: topMidpoint)

            if let topRightRadius = topRightRadius {
                self.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
                self.addArc(withCenter: tr, radius: topRightRadius, startAngle: -CGFloat.pi * 0.5, endAngle: 0, clockwise: true)
            }
            else {
                self.addLine(to: tr)
            }

            if let bottomRightRadius = bottomRightRadius {
                self.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
                self.addArc(withCenter: br, radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat.pi * 0.5, clockwise: true)
            }
            else {
                self.addLine(to: br)
            }

            if let bottomLeftRadius = bottomLeftRadius {
                self.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
                self.addArc(withCenter: bl, radius: bottomLeftRadius, startAngle: CGFloat.pi * 0.5, endAngle: CGFloat.pi, clockwise: true)
            }
            else {
                self.addLine(to: bl)
            }

            if let topLeftRadius = topLeftRadius {
                self.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
                self.addArc(withCenter: tl, radius: topLeftRadius, startAngle: CGFloat.pi, endAngle: -CGFloat.pi * 0.5, clockwise: true)
            }
            else {
                self.addLine(to: tl)
            }

            self.close()
        }
    }
}
