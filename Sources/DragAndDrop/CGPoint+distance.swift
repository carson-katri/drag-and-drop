//
//  CGPoint+distance.swift
//  drag-and-drop
//
//  Created by Carson Katri on 8/27/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDistance = x - point.x
        let yDistance = y - point.y
        return CGFloat(sqrt(xDistance * xDistance + yDistance * yDistance))
    }
}
