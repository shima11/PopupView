//
//  PopupView.swift
//  PopupView
//
//  Created by Jinsei Shima on 2018/11/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

// TODO: dynamic interaction
// TODO: resize target view
// TODO: arrow position (not center)

// https://github.com/corin8823/Popover
// https://github.com/mercari/BalloonView
// https://github.com/pjocprac/PTBalloonView

public class PopupView: UIView {

    enum Animation {
        
    }
    
    public typealias ContainerType = (UIView & PopupViewContainerType)
    
    private var containerView: ContainerType
    private var contentView: UIView?
    private var fromView: UIView?
    private var targetView: UIView?
    private var focusPoint: CGPoint?

    private var popupPosition: PopupPosition?
    
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
        
        guard let popupPosition = popupPosition else { return }

        containerView.frame = bounds

        if let fromView = fromView {
            switch popupPosition {
            case .top:
                center = CGPoint(x: fromView.center.x, y: fromView.center.y - fromView.bounds.height / 2 - bounds.height / 2)
            case .bottom:
                center = CGPoint(x: fromView.center.x, y: fromView.center.y + fromView.bounds.height / 2 + bounds.height / 2)
            }
        }
        else if let focusPoint = focusPoint {
            switch popupPosition {
            case .top:
                center = CGPoint(x: focusPoint.x, y: focusPoint.y - bounds.height / 2)
            case .bottom:
                center = CGPoint(x: focusPoint.x, y: focusPoint.y + bounds.height / 2)
            }
        }

    }

    public func show(contentView: UIView, focusPoint: CGPoint, targetView: UIView, appearance: PopupViewAppearance, animated: Bool) {

        isHidden = false

        self.contentView = contentView
        self.targetView = targetView
        self.focusPoint = focusPoint
        self.popupPosition = appearance.position

        targetView.addSubview(self)
        containerView.set(
            contentView: contentView,
            appearance: appearance
        )

        layoutIfNeeded()

        // TODO: show animation

    }

    public func show(contentView: UIView, fromView: UIView, targetView: UIView, appearance: PopupViewAppearance, animated: Bool) {

        isHidden = false
        
        self.contentView = contentView
        self.fromView = fromView
        self.targetView = targetView
        self.popupPosition = appearance.position
        
        targetView.addSubview(self)
        containerView.set(
            contentView: contentView,
            appearance: appearance
        )

        layoutIfNeeded()

        // TODO: show animation

        containerView.show()

    }
    
    public func dismiss(animated: Bool) {
        
        isHidden = true
        
        // TODO: dismiss animation
    }
    
    public func startAnimation() {
        // TODO: floating animatino
    }
    
    public func stopAnimation() {
        // TODO:
    }
    
}
