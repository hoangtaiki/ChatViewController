## Usage

### Image Picker
Currently, we support two style for ImagePicker. First one is Slack style and second one is action sheet style

#### Slack style

<img src="/images/slack-image-picker-one-row.png" width="33%">
<img src="/images/slack-image-picker-two-rows.png" width="33%">

One or two rows depend on device and user turn on/off `predictive mode` for keyboard. To understand more clearly about how we implement it, see the [Image Picker](AdvancedUsage.md#image-picker) 

#### Action Sheet style
<img src="/images/action-sheet-image-picker.png" width="33%">

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