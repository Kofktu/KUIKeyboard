# KUIKeyboard

![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/KUIKeyboard.svg?style=flat)](http://cocoapods.org/?q=name%3AKUIKeyboard%20author%3AKofktu)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Keyboard Handler in iOS,
It also perfectly works with UIScrollViewKeyboardDismissMode.interactive.

![alt tag](Screenshot/Example.gif)

## Requirements

- iOS 8.0+
- Xcode 9.0
- Swift 4.0 (>= 1.5.0)
- Swift 3.0 ([1.0.0](https://github.com/Kofktu/KUIKeyboard/tree/1.0.0))

## Installation

#### CocoaPods
KUIKeyboard is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KUIKeyboard"
```

## Usage

#### KUIKeyboard
```Swift
import KUIKeyboard

var keyboard = KUIKeyboard()

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    keyboard.addObservers()
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    keyboard.removeObservers()
}

```

#### KUIKeyboardDelegate
```swift
keyboard.delegate = self

...

func keyboard(_ keyboard: KUIKeyboard, changed visibleHeight: CGFloat) {
  // Customize
}
```

#### Closure
```swift
keyboard.onChangedKeyboardHeight = { (visibleHeight) in
  // Customize        
}
```


## References
- RxKeyboard (https://github.com/RxSwiftCommunity/RxKeyboard)

## Authors

Taeun Kim (kofktu), <kofktu@gmail.com>

## License

KUIKeyboard is available under the ```MIT``` license. See the ```LICENSE``` file for more info.
