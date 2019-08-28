//
//  View+draggable+droppable.swift
//  drag-and-drop
//
//  Created by Carson Katri on 8/27/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import SwiftUI

public extension View {
    func draggable(_ uuid: UUID = UUID(), data: Any, resize: Bool = false) -> some View {
        DragView(uuid: uuid, data) {
            self
        }
    }
    
    func droppable(_ uuid: UUID = UUID()) -> some View {
        DropView(uuid) { _ in
            self
        }
    }
    
    internal func rect(_ callback: @escaping (CGRect) -> Void) -> some View {
        self.background(GeometryReader { geometry in
            self.getRect(geometry) { callback($0) }
        })
    }
    
    private func getRect(_ geometry: GeometryProxy, callback: (CGRect) -> Void) -> some View {
        callback(geometry.frame(in: .global))
        return Rectangle().foregroundColor(.clear)
    }
}
