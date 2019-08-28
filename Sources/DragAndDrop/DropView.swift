//
//  DropView.swift
//  drag-and-drop
//
//  Created by Carson Katri on 8/27/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import SwiftUI

public struct DropView<Content: View>: View {
    public let uuid: UUID
    public let onDrop: (UUID, Any) -> Void
    public let content: (Any?) -> Content
    
    @EnvironmentObject public var manager: DragDropManager
    @State private var rect: CGRect? = nil
    @State private var registered: Bool = false
    
    public init(_ uuid: UUID = UUID(), onDrop: @escaping (UUID, Any) -> Void = { _, _ in }, _ content: @escaping (Any?) -> Content) {
        self.uuid = uuid
        self.onDrop = onDrop
        self.content = content
    }
    
    public var body: some View {
        if !registered, let rect = rect {
            print(rect)
            DispatchQueue.main.async {
                self.registered = true
                self.manager.addDropView(self.uuid, rect: rect, onDrop: self.onDrop)
            }
        }
        return content(self.manager.dropData(for: uuid))
            .rect { rect in
                if self.rect == nil {
                    DispatchQueue.main.async {
                        self.rect = rect
                    }
                }
            }
    }
    
    
}

struct DropView_Previews: PreviewProvider {
    static var previews: some View {
        DropView { _ in
            Text("Drop Here")
        }
    }
}
