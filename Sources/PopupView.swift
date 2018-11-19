//
//  PopupView.swift
//  PopupView
//
//  Created by Jinsei Shima on 2018/11/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

// TODO: dynamic interaction

public class PopupView: UIView {

    public typealias ContainerType = (UIView & PopupViewContainerType)
    
    private var containerView: ContainerType
    private var contentView: UIView?
    private var fromView: UIView?
    private var targetView: UIView?
    
    private var position: PopupPosition?
    
    public init(containerView: ContainerType = PopupViewContainer()) {

        self.containerView = containerView
        
        super.init(frame: .zero)
        
        addSubview(containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let fromView = fromView, let position = position else { return }

        containerView.frame = bounds

        switch position {
        case .top:
            center = CGPoint(x: fromView.center.x, y: fromView.center.y - fromView.bounds.height / 2 - bounds.height / 2)
        case .bottom:
            center = CGPoint(x: fromView.center.x, y: fromView.center.y + fromView.bounds.height / 2 + bounds.height / 2)
        }
        
    }

    public func show(contentView: UIView, fromView: UIView, targetView: UIView, appearance: PopupViewAppearance, animated: Bool) {

        isHidden = false
        
        self.contentView = contentView
        self.fromView = fromView
        self.targetView = targetView
        
        self.position = appearance.position
        
        targetView.addSubview(self)
        containerView.set(contentView: contentView)
        containerView.set(appearance: appearance)
        layoutIfNeeded()
        
        // TODO: show animation
        
    }
    
    public func dismiss(animated: Bool) {
        
        isHidden = true
        
        // TODO: dismiss animation
    }
    
    public func startAnimation() {
        // TODO:
    }
    
    public func stopAnimation() {
        // TODO:
    }
    
}
