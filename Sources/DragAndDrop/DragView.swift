//
//  DragView.swift
//  drag-and-drop
//
//  Created by Carson Katri on 8/27/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import SwiftUI

public struct DragView<Content: View>: View {
    public let uuid: UUID
    public let dropData: Any
    public let resize: Bool
    public let content: () -> Content
    
    @State private var dragPos: CGPoint = .zero
    @State private var scale: CGFloat = 1
    @State private var rect: CGRect? = nil
    @State private var dragging: Bool = false
    
    @State private var registered: Bool = false
    
    @EnvironmentObject var manager: DragDropManager
    
    public init(uuid: UUID = UUID(), _ dropData: Any, resize: Bool = false, @ViewBuilder _ content: @escaping () -> Content) {
        self.uuid = uuid
        self.dropData = dropData
        self.resize = resize
        self.content = content
    }
    
    public var body: some View {
        if !registered {
            DispatchQueue.main.async {
                self.registered = true
                self.manager.addDragView(self.uuid, data: self.dropData)
                print("Registered")
            }
        }
        return content()
            .scaleEffect(!dragging ? scale : 1)
            .offset(CGSize(width: dragPos.x, height: dragPos.y))
            .gesture(DragGesture(coordinateSpace: .global).onChanged { drag in
                if let start = self.rect?.center {
                    let location = drag.location
                    self.dragPos = CGPoint(x: location.x - start.x, y: location.y - start.y)
                }
                if !self.dragging {
                    self.dragging = true
                }
            }.onEnded { drag in
                self.dragging = false
                // Set the drop data for the closest DropView
                if let dropView = self.manager.closest(to: drag.location) {
                    let dropOn = self.manager.drop(view: self.uuid, on: dropView.uuid)
                    if let startRect = self.rect {
                        let start = startRect.center
                        var location = dropView.rect.center
                        var scale = dropView.rect.width / startRect.width
                        if dropOn == nil {
                            location = start
                            scale = 1
                            if let prevOn = self.manager.dragViews[self.uuid]?.1 {
                                if let prevLocation = self.manager.dropViews[prevOn]?.0 {
                                    location = prevLocation.center
                                    scale = prevLocation.width / startRect.width
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.dragPos = CGPoint(x: location.x - start.x, y: location.y - start.y)
                            self.scale = scale
                        }
                    }
                }
            })
            .rect { rect in
                if self.rect == nil {
                    DispatchQueue.main.async {
                        self.rect = rect
                    }
                }
            }
    }
}

struct DragView_Previews: PreviewProvider {
    static var previews: some View {
        DragView("Hello World") {
            Text("Drag Me")
        }
    }
}
