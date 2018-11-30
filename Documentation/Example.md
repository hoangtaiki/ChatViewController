**ChatViewController** is developed with main functions about: View Controller and ChatBarView. The core doesn't contain functions related about layout message. Because we understand that each chat application has different layout message. So that we didn't leave this part of the core.

With `iOS Example` project they want to bring you a specific chat application, which is based on ` ChatViewController`. The layout of our message is based on `Facebook Messenger` or `Instagram`.

Below we will explain in detail how we layout. It is an example for you to easily apply `ChatViewController` to your application.

## 1. Structure of MessageCell

### Structure of message cell UI

MessageCell is designed by using StackView. We aim to hide the components as easily as possible.
Why we need hide the components?
- We want to hide `Status StackView (Status Label)` for Incoming message.
- We want to hide `Avatar Container View (Avatar ImageView)` for Outgoing message.
```Swift
fileprivate func layoutForIncomingMessage() {
    statusStackView.isHidden = true
    statusSpaceView.isHidden = false
    avatarContainerView.isHidden = false
}

fileprivate func layoutForOutgoingMessage() {
    statusStackView.isHidden  = true
    statusSpaceView.isHidden = true
    avatarContainerView.isHidden = true
}
```

### How we layout MessageCell for both Incoming and Outgoing message?

We don't want use separated UI for each Incoming and Outgoing message. So that we update `tranform` of each components inside message cell.
```Swift
func tranformUI(_ isOutgoingMessage: Bool) {
    if isOutgoingMessage {
        layoutForOutgoingMessage()
        contentTranform = CGAffineTransform(scaleX: -1, y: 1)
        statusLabel.textAlignment = .right
    } else {
        layoutForIncomingMessage()
        contentTranform = CGAffineTransform.identity
        statusLabel.textAlignment = .left
    }
    contentView.transform = contentTranform
    statusLabel.transform = contentTranform
    avatarImageView.transform = contentTranform
}
```

`MessageCell` is abstract class. With `RoundedView` is designed as `Container View`. It holds each UI we want to display. With `MessageTextCell` we add `messageLabel` into it, with `MessageImageCell` we add `attachImageView` to show image. And to show right direction for incoming and outgoing message you just have to override `tranformUI` function.

### How to draw bubble behind message
We use UIBezierPath to draw Rectangle with corner. Then mask `RoundedView` by a `CAShapeLayer`
```Swift
fileprivate func roundViewWithStyle( _ style: RoundedViewType) {
    layoutIfNeeded()

    let bounds = roundedView.bounds
    let roundRadius: (tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat) = getRoundRadiusForStyle(style)
    let path = UIBezierPath(roundedRect: bounds,
                            topLeftRadius: roundRadius.tl,
                            topRightRadius: roundRadius.tr,
                            bottomLeftRadius: roundRadius.bl,
                            bottomRightRadius: roundRadius.br)
    path.lineJoinStyle = .round

    let maskLayer = CAShapeLayer()
    maskLayer.frame = bounds
    maskLayer.path = path.cgPath

    roundedView.layer.mask = maskLayer
}
```

## 2. MessageTextCell
To display text message we added an UILabel `messageLabel` inside `RoundedView`

As you see: We only add `leadingAnchor`, `topAnchor` and `bottomAnchor` for `OuterStackView`. So that to limit width of content. Here is width of `messageLabel` you have to set `widthAnchor for messageLabel`

You can set widthAnchor constant by specific value or depend on screen size width.


## 3. MessageImageCell
To display Image message we added an UIImageView `attachImageView` inside `RoundedView`. We want to display the image with the aspect ratio that corresponds to the actual size of the image. So that we calculate image size we want to display then set `widthAnchor` and `heightAnchor` for `attachImageView`.

```Swift
/// Display the image with the aspect ratio that corresponds to the actual size of the image.
fileprivate func updateImage(width: CGFloat, height: CGFloat) {
    let proportionalSize: (width: CGFloat, height: CGFloat) = calculateProportionalSize(width: width, height: height)

    widthAnchorImageView.constant = proportionalSize.width
    heightAnchorImageView.constant = proportionalSize.height
}

/// Calculate proportional size with same aspect ratio
fileprivate func calculateProportionalSize(width: CGFloat, height: CGFloat) -> (CGFloat, CGFloat) {
    var imageResizeHeight: CGFloat
    var imageResizeWidth = maxContentWidth
    let imageRatio = height / width

    if width > height {
        imageResizeHeight = CGFloat(Int(imageResizeWidth * imageRatio))
    } else {
        imageResizeHeight = imageResizeWidth
        imageResizeWidth = CGFloat(Int(imageResizeWidth / imageRatio))
    }

    return (imageResizeWidth, imageResizeHeight)
}
```


