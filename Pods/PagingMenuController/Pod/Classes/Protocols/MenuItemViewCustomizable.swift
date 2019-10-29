//
//  MenuItemViewCustomizable.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/23/16.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

public protocol MenuItemViewCustomizable {
    var horizontalMargin: CGFloat { get }
    var displayMode: MenuItemDisplayMode { get }
}

public extension MenuItemViewCustomizable {
    var horizontalMargin: CGFloat {
        return 50
    }
    var displayMode: MenuItemDisplayMode {
        let title = MenuItemText()
        return .text(title: title)
    }
}

public enum MenuItemDisplayMode {
    case text(title: MenuItemText)
    case multilineText(title: MenuItemText, description: MenuItemText)
    case image(image: UIImage, selectedImage: UIImage?)
    case custom(view: UIView)
}

public struct MenuItemText {
    let text: String
    let color: UIColor
    let selectedColor: UIColor
    let font: UIFont
    let selectedFont: UIFont
    
    public init(text: String = "Menu",
                color: UIColor = UIColor.lightGray,
                selectedColor: UIColor = UIColor(red: 54.0 / 255.0, green: 96.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0),
                font: UIFont = UIFont.systemFont(ofSize: 16),
                selectedFont: UIFont = UIFont.systemFont(ofSize: 18)) {
        self.text = text
        self.color = color
        self.selectedColor = selectedColor
        self.font = font
        self.selectedFont = selectedFont
    }
}