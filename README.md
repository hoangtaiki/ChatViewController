<img src="/images/presenter.jpg" width="100%">

[![Version](https://img.shields.io/cocoapods/v/ChatViewController.svg?style=flat)](http://cocoapods.org/pods/ChatViewController)
[![License](https://img.shields.io/cocoapods/l/ChatViewController.svg?style=flat)](http://cocoapods.org/pods/ChatViewController)
[![Platform](https://img.shields.io/cocoapods/p/ChatViewController.svg?style=flat)](http://cocoapods.org/pods/ChatViewController)
![Language](https://img.shields.io/badge/Language-%20swift%20%20-blue.svg)
[![Build Status](https://travis-ci.org/hoangtaiki/ChatViewController.svg)](https://travis-ci.org/hoangtaiki/ChatViewController)


ChatViewController is a library designed to simplify the development of UI for such a trivial task as chat. It has flexible possibilities for styling, customizing. It is also contains example for Facebook Messager and Instagram Chat.

- [Features](#features)
- [Compatibility](#compatibility)
- [Migration Guides](#migration-guides)
- [Installation](#installation)
- [Usage](/Documentation/Usage.md)
	- [Subclassing](/Documentation/Usage.md#subclassing)
	- [Image Picker](/Documentation/Usage.md#image-picker)
	- [Typing Indicator display](/Documentation/Usage.md#typing-indicator)
	- [Show/hide chat bar view](/Documentation/Usage.md#chat-bar-visible)
	- [Pull to refresh and load more feature](/Documentation/Usage.md#pull-to-refresh-and-load-more)
- [Example](/Documentation/Example.md)
- [Contributing](#contributing)
- [License](#license)

## Features
- [x] Growing Text View from UIPlaceholderTextView
- [x] Flexible UI built with Auto Layout
- [x] Inverted Mode for displaying cells upside-down (using CATransform)
- [x] Customizable: change chat bar view layout style
- [x] Tap gesture for dismissing the keyboard
- [x] Slack Image Picker
- [x] Typing Indicator display
- [x] Show/hide chat bar view
- [x] Pull to refresh and load more feature
- [x] Example: Facebook Bubble style
- [x] Example: Instagram Bubble style
- [x] Example: Text chat cell
- [x] Example: Image chat cell
- [ ] Example: Link chat cell
- [ ] Example: Document chat cell
- [ ] Example: Image Viewer
- [ ] Example: Document Viewer
- [ ] Example: Custom Image Picker
- [ ] [Complete Documentation](/Documentation/Usage.md)

## Compatibility
* CocoaPods
* Swift 4.2 or later
* iOS 10 or later
* iPhone & iPad

## CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate ChatViewController into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ChatViewController'
end
```

Then, run the following command:

```bash
$ pod install
```

## Contributing

Please feel free to help out with this project! If you see something that could be made better or want a new feature, open up an issue or send a Pull Request! 

## License

ChatViewController is released under the MIT license. [See LICENSE](LICENSE) for details.