# Usage

## Subclassing

`ChatViewController` is meant to be subclassed, like you would normally do with UITableViewController. This pattern is a convenient way of extending UIViewController. `ChatViewController` manages a lot behind the scenes while still providing the ability to add custom behaviours. You may override methods, and decide to call super and perform additional logic, or not to call super and override default logic.

Start by creating a new subclass of `ChatViewController`.

Override delegate function of UITableView

```swift
override func numberOfSections(in tableView: UITableView) -> Int {

}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
}
```

Override function `didPressSendButton`

```swift
override func didPressSendButton(_ sender: Any?) {
    // Create message
    let message = Message(id: UUID().uuidString, text: chatBarView.textView.text)
    // Add message
    addMessage(message)
    // Call super to update UI for Chat Bar
    super.didPressSendButton(sender)
}
```

Handle `ImagePickerView` call back 

```swift
/// Image Picker Result closure
imagePickerView?.pickImageResult = { image, url, error in
    if error != nil {
        return
    }

    guard let _ = image, let _ = url else {
        return
    }

    print("Pick image successfully")
}
```


## Image Picker
Currently, we support two style for ImagePicker. First one is Slack style and second one is action sheet style

### Slack style

<img src="https://github.com/hoangtaiki/ChatViewController/blob/master/images/slack-image-picker-one-row.jpg" width="33%">
<img src="https://github.com/hoangtaiki/ChatViewController/blob/master/images/slack-image-picker-two-rows.jpg" width="33%">

One or two rows depend on device and user turn on/off `predictive mode` for keyboard. To understand more clearly about how we implement it, see the [Image Picker](AdvancedUsage.md#image-picker) 

### Action Sheet style
<img src="https://github.com/hoangtaiki/ChatViewController/blob/master/images/action-sheet-image-picker.jpg" width="33%">

Action Sheet is the simplest way to pick an image.

To use default ImagePickerHelper to show `Action Sheet style`. Declare `imagePickerHelper` in YourViewController
```swift
open lazy var imagePickerHelper: ImagePickerHelper = {
    let imagePickerHelper = ImagePickerHelper()
    imagePickerHelper.delegate = self
    imagePickerHelper.parentViewController = self
    
    return imagePickerHelper
}()
```

Make YourViewController adopts ImagePickerHelperResultDelegate
```swift
extension YourViewController: ImagePickerHelperResultDelegate {
   
    public func didFinishPickingMediaWithInfo(_ image: UIImage?, _ imagePath: URL?, _ error: Error?) {
     
    }
}
```

Override `didPressGalleryButton` function
```swift
override func didPressGalleryButton(_ sender: Any?) {
    /// Dismiss keyboard if keyboard is showing
    if currentKeyboardType == .default {
        dismissKeyboard()
    }
    
    imagePickerHelper?.takeOrChoosePhoto()
}
```

## Typing Indicator

Create subclass `User` adopts `Userable` protocol
```swift
struct User: Userable, Mappable {

    var id: Int!
    var name: String = ""

    var idNumber: String {
        get {
            return id.description
        }
    }

    var displayName: String {
        get {
            return name
        }
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
```

Add an user who is typing
```swift
user = User(id: 1, name: "Harry")
typingIndicatorView.insertUser(user)
```

Remove an user who is typing
```swift
user = User(id: 1, name: "Harry")
typingIndicatorView.removeUser(user)
```

## Chat Bar Visible

Show Chat Bar
```swift
setChatBarHidden(false, animated: true)
```

Hide Chat Bar
```swift
setChatBarHidden(true, animated: true)
```

## Pull To Refresh And Load More

Add load more function
```swift
// Add function load more for table view
tableView.addLoadMore { in

}
```

Add pull to refresh function
```swift
// Add function refresh for table view
tableView.addFooterRefresh { in

}
```