//
//  PopupViewAppearance.swift
//  PopupView
//
//  Created by Jinsei Shima on 2018/11/19.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

public enum PopupPosition {
    case top, bottom
}

public struct PopupViewAppearance {
    
    let backgroundColor: UIColor
    let position: PopupPosition
    let arrowHeight: CGFloat
    let arrowWidth: CGFloat
    let cornerRadius: CGFloat
    
    public init(
        backgroundColor: UIColor,
        position: PopupPosition,
        arrowHeight: CGFloat,
        arrowWidth: CGFloat,
        cornerRadius: CGFloat
        ) {
        
        self.backgroundColor = backgroundColor
        self.position = position
        self.arrowHeight = arrowHeight
        self.arrowWidth = arrowWidth
        self.cornerRadius = cornerRadius
    }
}
