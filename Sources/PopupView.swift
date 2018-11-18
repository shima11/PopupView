//
//  PopupView.swift
//  PopupView
//
//  Created by Jinsei Shima on 2018/11/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

// TODO: dynamic interaction

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

public protocol PopupViewContainerType {
    
    func set(appearance: PopupViewAppearance)
    func set(contentView: UIView)
}

public class PopupView: UIView {

    private var containerView: (UIView & PopupViewContainerType)
    private var contentView: UIView?
    private var fromView: UIView?
    private var targetView: UIView?
    
    private var position: PopupPosition?
    
    public init(containerView: (UIView & PopupViewContainerType) = BalloonView()) {

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


public class BalloonView: UIView, PopupViewContainerType {
    
    private var contentView: UIView?
    private var appearance: PopupViewAppearance?
    
    // MARK: - initialize
    
    public init() {
        
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - functions
    
    public func set(appearance: PopupViewAppearance) {
        self.appearance = appearance
        setNeedsDisplay()
    }
    
    public func set(contentView: UIView) {
        self.contentView = contentView
        addSubview(contentView)
        setNeedsDisplay()
    }
    

    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        guard let appearance = appearance, let contentView = contentView else { return }
        
        switch appearance.position {
        case .top:
            contentView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - appearance.arrowHeight)
        case .bottom:
            contentView.frame = CGRect(x: 0, y: appearance.arrowHeight, width: bounds.width, height: bounds.height - appearance.arrowHeight)
        }
    }

    override public func draw(_ rect: CGRect) {

        guard let appearance = appearance else { return }

        let bezierPath = UIBezierPath()

        let contentWidth: CGFloat = rect.maxX
        let contentHeight: CGFloat = rect.maxY - appearance.arrowHeight
        let arrowPositionX: CGFloat = rect.maxX / 2
        
        let offsetY: CGFloat
        switch appearance.position {
        case .top:
            offsetY = 0
        case .bottom:
            offsetY = appearance.arrowHeight
        }
        
        // main body
        
        bezierPath.move(
            to: .init(
                x: appearance.cornerRadius,
                y: offsetY
            )
        )
        
        bezierPath.addLine(
            to: .init(
                x: contentWidth - appearance.cornerRadius,
                y: offsetY
            )
        )
        
        // top right
        bezierPath.addArc(
            withCenter: .init(
                x: contentWidth - appearance.cornerRadius,
                y: appearance.cornerRadius + offsetY
            ),
            radius: appearance.cornerRadius,
            startAngle: radian(-90),
            endAngle: radian(0),
            clockwise: true
        )
        
        bezierPath.addLine(
            to: .init(
                x: contentWidth,
                y: contentHeight - appearance.cornerRadius + offsetY
            )
        )
        
        // bottom right
        bezierPath.addArc(
            withCenter: .init(
                x: contentWidth - appearance.cornerRadius,
                y: contentHeight - appearance.cornerRadius + offsetY
            ),
            radius: appearance.cornerRadius,
            startAngle: radian(0),
            endAngle: radian(90),
            clockwise: true
        )
        
        bezierPath.addLine(
            to: .init(
                x: appearance.cornerRadius,
                y: contentHeight + offsetY
            )
        )
        
        // bottom left
        bezierPath.addArc(
            withCenter: .init(
                x: appearance.cornerRadius,
                y: contentHeight - appearance.cornerRadius + offsetY
            ),
            radius: appearance.cornerRadius,
            startAngle: radian(90),
            endAngle: radian(180),
            clockwise: true
        )
        
        bezierPath.addLine(
            to: .init(
                x: 0,
                y: appearance.cornerRadius + offsetY
            )
        )
        
        // top left
        bezierPath.addArc(
            withCenter: .init(
                x: appearance.cornerRadius,
                y: appearance.cornerRadius + offsetY
            ),
            radius: appearance.cornerRadius,
            startAngle: radian(180),
            endAngle: radian(270),
            clockwise: true
        )
        
        
        // arrow
        switch appearance.position {
        case .top:
            bezierPath.move(to: .init(x: arrowPositionX - appearance.arrowWidth / 2, y: contentHeight))
            bezierPath.addLine(to: .init(x: arrowPositionX, y: rect.maxY))
            bezierPath.addLine(to: .init(x: arrowPositionX + appearance.arrowWidth / 2, y: contentHeight))
        case .bottom:
            bezierPath.move(to: .init(x: arrowPositionX - appearance.arrowWidth / 2, y: offsetY))
            bezierPath.addLine(to: .init(x: arrowPositionX, y: 0))
            bezierPath.addLine(to: .init(x: arrowPositionX + appearance.arrowWidth / 2, y: offsetY))
        }
    
        // Draw
        appearance.backgroundColor.setFill()
        bezierPath.fill()
        bezierPath.close()
    }
    
    private func radian(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat(CGFloat.pi) / 180
    }

}
