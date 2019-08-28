# Drag and Drop

Simple drag and drop for SwiftUI

![Sample GIF](Resources/SampleGIF.gif)

## Installation
You can install via the Swift Package Manager:

`File > Swift Packages > Add Package Dependency...`, then paste in `https://github.com/carson-katri/drag-and-drop`

## Usage

First, add the `DragDropManager` environment object:
```swift
ContentView().environmentObject(DragDropManager())
```

Example:
```swift
VStack {
  Text("Drop Here")
    .droppable()
  Text("Drag Me")
    .draggable(data: myDropData)
}
```

You can also get the data from the drag view like so:
```swift
VStack {
  DropView { data in
    Text(data as? String ?? "Drop Here")
  }
  Text("Drag Me")
    .draggable(data: "Hello World")
}
```

You can also make the `DragView` directly:
```swift
DragView(myDropData) {
  Text("Drag Me")
}
```

Another capability is resizing the `DragView` to fit in the `DropView` automatically:
```swift
Text("Drag Me")
  .draggable(data: "Hello World", resize: true)
```
