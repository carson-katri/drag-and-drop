//
//  CGRect+center.swift
//  drag-and-drop
//
//  Created by Carson Katri on 8/27/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import CoreGraphics

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
