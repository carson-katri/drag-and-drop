//
//  DragDropManager.swift
//  drag-and-drop
//
//  Created by Carson Katri on 8/27/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import SwiftUI

public class DragDropManager: ObservableObject {
    @Published public var dragViews: [UUID : (Any, UUID?)] = [:]
    @Published public var dropViews: [UUID : (CGRect, (UUID, Any) -> Void)] = [:]
    
    public init() {
        
    }
    
    func addDragView(_ uuid: UUID, data: Any, droppedAt: UUID? = nil) {
        print("Registered \(uuid)")
        dragViews[uuid] = (data, droppedAt)
    }
    
    func addDropView(_ uuid: UUID, rect: CGRect, onDrop: @escaping (UUID, Any) -> Void) {
        print("Registered \(uuid)")
        dropViews[uuid] = (rect, onDrop)
    }
    
    func canDrop(on dropView: UUID) -> Bool {
        dragViews.filter { $0.value.1 == dropView }.count < 1
    }
    
    func drop(view dragView: UUID, on dropView: UUID) -> (uuid: UUID, rect: CGRect)? {
        var droppedOn: (uuid: UUID, rect: CGRect)? = nil
        if let prev = dragViews[dragView] {
            if canDrop(on: dropView) {
                dragViews[dragView] = (prev.0, dropView)
                if let dropOn = dropViews.first(where: { $0.key == dropView }) {
                    dropOn.1.1(dragView, prev.0)
                    droppedOn = (uuid: dropOn.key, rect: dropOn.value.0)
                }
            }
        }
        return droppedOn
    }
    
    func closest(to location: CGPoint) -> (rect: CGRect, uuid: UUID)? {
        var closest: (rect: CGRect, uuid: UUID)? = nil
        for view in dropViews {
            if let prev = closest {
                if view.value.0.center.distance(to: location) > prev.rect.center.distance(to: location) {
                    continue
                }
            }
            closest = (rect: view.value.0, uuid: view.key)
        }
        return closest
    }
    
    public func dropData(for dropView: UUID) -> Any? {
        dragViews.first { $0.value.1 == dropView }?.value.0
    }
}
