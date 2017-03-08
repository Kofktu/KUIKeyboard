# KUIKeyboard
Keyboard Handler in iOS, 
It also perfectly works with UIScrollViewKeyboardDismissMode.interactive.

## Requirements

- iOS 8.0+
- Xcode 8.0

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

#### CocoaPods
KUIActionSheet is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KUIKeyboard"
```

## Usage

#### KUIKeyboard
```Swift 
import KUIKeyboard

var keyboard = KUIKeyboard()

keyboard.delegate = self
keyboard.onChangedKeyboardHeight = { [weak self] (visibleHeight) in
  // Customize        
}

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    keyboard.addObservers()
}
    
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    keyboard.removeObservers()
}

```

## References
- RxKeyboard (https://github.com/RxSwiftCommunity/RxKeyboard)

## Authors

Taeun Kim (kofktu), <kofktu@gmail.com>

## License

KUIKeyboard is available under the ```MIT``` license. See the ```LICENSE``` file for more info.
