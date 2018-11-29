# Advanced Usage

## Image Picker

### How we implement?
Image Picker is built on UICollectionView. 

#### Different number of row on different devices
Default keyboard height on iPhone 6 and iPhone 5S or smaller iPhones is 216 point. With bigger iPhone, keyboard height is 226 point.
If `predictive bar` is enable, we will have more space for Image Picker.

So that, we decide that, Image Picker will have `one row` in case space height less that 226 point and have two row in case  space height more that 226 points


`Utils.swift`
```swift
let maxCollectionImageCellHeight: CGFloat = 226

var isGreaterThanMaxHeight: Bool {
    get {
        return getCacheKeyboardHeight() > maxCollectionImageCellHeight
    }
}   
```

`ImagePickerCollectionView.swift`
```swift
private func calculateProperties() {
    if Utils.shared.isGreaterThanMaxHeight {
        nColumns = 2
        let cellWidth = (bounds.height - spacing) / CGFloat(nColumns)
        cellSize = CGSize(width: cellWidth, height: cellWidth)
    } else {
        nColumns = 1
        cellSize = CGSize(width: bounds.height, height: bounds.height)
    }
}
```
We don't need layout Image Picker every showing, so that we implement function to cache keyboard height.
In some case user turn on/off `Predictive Mode` we will re-calculate and re-layout Image Picker.

#### Open Camera and Library
Currently, we are using default UIImagePickerViewController for two buttons in ImagePicker.
But we support to customize it.

##### Create your ImagePickerHelper
Your class adopt `ImagePickerHelperable` and have `delegate` attribute `ImagePickerHelperResultDelegate`
##### Override ImagePickerView
* Override `imagePickerHelper` attribute in `ImagePickerView`
* Override `openCamera` and `openLibrary` functions

We will have example for that feature

#### Photo Data Manager
Need update