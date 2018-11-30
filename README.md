# ChatViewController
[![Version](https://img.shields.io/cocoapods/v/ChatViewController.svg?style=flat)](http://cocoapods.org/pods/ChatViewController)
[![License](https://img.shields.io/cocoapods/l/ChatViewController.svg?style=flat)](http://cocoapods.org/pods/ChatViewController)
[![Platform](https://img.shields.io/cocoapods/p/ChatViewController.svg?style=flat)](http://cocoapods.org/pods/ChatViewController)
![Language](https://img.shields.io/badge/Language-%20swift%20%20-blue.svg)
[![Build Status](https://travis-ci.org/hoangtaiki/ChatViewController.svg)](https://travis-ci.org/hoangtaiki/ChatViewController)


ChatViewController is a library designed to simplify the development of UI for such a trivial task as chat. It has flexible possibilities for styling, customizing. It is also contains example for Facebook Messager and Instagram Chat.

<img src="/images/presenter.jpg" width="100%">

## Feature List
### Core
* Works out of the box with UITableView
* Growing Text View from UIPlaceholderTextView
* Flexible UI built with Auto Layout
* Customizable: change chat bar view layout style
* Tap gesture for dismissing the keyboard
* Inverted Mode for displaying cells upside-down (using CATransform)

### Additional
* Support chat bar view with Default style and Slack style
* [Image Picker](/Documentation/Usage.md#image-picker) 
* Typing Indicator display
* Show/hide chat bar view
* Pull to refresh and load more feature

### Compatibility
* CocoaPods
* Swift 4.2 or later
* iOS 10 or later
* iPhone & iPad

## Example
### Feature List
* Chat Text Cell, Chat Image Cell with Facebook and Instagram style
* Simulate typing indicator
* Simulate show/hide chat bar view
### Run example
Run pod install
```
cd path/to/project
pod install
```
Open `iOS Example.xcworkspace` by Xcode and run

## Installation
##### With [CocoaPods](https://cocoapods.org/):
```ruby
pod "ChatViewController"
```
