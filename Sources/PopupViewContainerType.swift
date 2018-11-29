//
//  PopupViewContainerType.swift
//  PopupView
//
//  Created by Jinsei Shima on 2018/11/29.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import Foundation

public protocol PopupViewContainerType {

    func set(appearance: PopupViewAppearance)
    func set(contentView: UIView, appearance: PopupViewAppearance)

    func show()
}
