//
//  ChatViewConfiguration.swift
//  ChatViewController
//
//  Created by Hoangtaiki on 8/19/18.
//

import Foundation

public enum ChatBarStyle {
    case `default`
    case slack
    case other
}

/// Image Picker Type
/// We support Slack type and ActionSheet type
public enum ImagePickerType {
    case slack
    case actionSheet
}

public struct ChatViewConfiguration {

    public var chatBarStyle: ChatBarStyle = .default
    // Use Image Picker or not. Default value is true
    public var imagePickerType: ImagePickerType = .slack
    // Max Chat Bar height
    public var maxChatBarHeight: CGFloat = 200
    // Selected color for send button
    public var sendButtonSelectedColor = UIColor(red: 45/255, green: 158/255, blue: 224/255, alpha: 1)
    // Deselected color for send button
    public var sendButtonDeSelectedColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
    // Deselected color for gallery button
    public var galleryButtonDeSelectedColor: UIColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
    // Border color for text input bar
    public var textInputBarBorderColor: UIColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
    // Background color for chat bar
    public var chatBarBackgroundColor: UIColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    
    public static var `default`: ChatViewConfiguration { return ChatViewConfiguration() }
}
