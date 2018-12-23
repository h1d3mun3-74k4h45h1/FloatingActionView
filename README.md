# FloatingActionView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Example

![iPhone Image](https://github.com/hidemune-takahashi/FloatingActionView/raw/images/Example%20Screen%20Shot.png)

```swift
let view = FloatingActionView()
view.menuButtonIconColor = UIColor.green
view.addAction(FloatingActionViewAction(actionColor: UIColor.blue,
actionImage: nil,
hintText: "Action 1",
handler: { (action) in
print("Action 1 Tapped")
}))
view.addAction(FloatingActionViewAction(actionColor: UIColor.purple,
actionImage: nil,
hintText: "Action 2",
handler: { (action) in
print("Action 2 Tapped")
}))
```

## How to use

1. make "Cartfile" to project root when not exists "Cartile" on project root.
2. Adding following line to Cartfile.
```
github "hidemune-takahashi/FloatingActionView"
```
3. Execute following command
```
carthage update --platform ios
```

## Key-Feature
- easy to create FloatingActionView.
- Full-Custmizable FloatingActionView icon and action view.
