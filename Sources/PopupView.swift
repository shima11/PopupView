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

public protocol PopupViewContainerType {
    var position: PopupPosition { get set }
    var arrowHeight: CGFloat { get }
    var arrowWidth: CGFloat { get }
    var cornerRadius: CGFloat { get }
    func set(contentView: UIView)
    func set(backgroundColor: UIColor)
}

public class PopupView: UIView {

    private var containerView: (UIView & PopupViewContainerType) = BalloonView()
    private var contentView: UIView?
    private var fromView: UIView?
    private var targetView: UIView?
    
    private var position: PopupPosition = .top
    
    public init(backgroundColor: UIColor) {

        super.init(frame: .zero)
        
        addSubview(containerView)
        containerView.set(backgroundColor: backgroundColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let fromView = fromView else { return }

        // TODO: いい感じに位置を調整

        containerView.frame = bounds

        switch position {
        case .top:
            center = CGPoint(x: fromView.center.x, y: fromView.center.y - fromView.bounds.height / 2 - bounds.height / 2)
        case .bottom:
            center = CGPoint(x: fromView.center.x, y: fromView.center.y + fromView.bounds.height / 2 + bounds.height / 2)
        }
        
    }

    public func show(contentView: UIView, fromView: UIView, targetView: UIView, position: PopupPosition, animated: Bool) {

        isHidden = false
        
        self.contentView = contentView
        self.fromView = fromView
        self.targetView = targetView
        self.position = position
        
        targetView.addSubview(self)
//        containerView.addSubview(contentView)
        containerView.position = position
        containerView.set(contentView: contentView)
        
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
    
    private var balloonBackgroundColor: UIColor?
    private var contentView: UIView?
    
    public var cornerRadius: CGFloat {
        return 8
    }
    
    public var arrowWidth: CGFloat {
        return 24
    }
    
    public var arrowHeight: CGFloat {
        return 12
    }
    
    public var position: PopupPosition = .top {
        didSet {
            setNeedsDisplay()
        }
    }

    public func set(backgroundColor: UIColor) {
        balloonBackgroundColor = backgroundColor
        setNeedsDisplay()
    }
    
    public func set(contentView: UIView) {
        self.contentView = contentView
        addSubview(contentView)
        setNeedsDisplay()
    }

    // MARK: - initialize
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - functions
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        switch position {
        case .top:
            contentView?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - arrowHeight)
        case .bottom:
            contentView?.frame = CGRect(x: 0, y: arrowHeight, width: bounds.width, height: bounds.height - arrowHeight)
        }
    }

    override public func draw(_ rect: CGRect) {
        
        let bezierPath = UIBezierPath()

        let contentWidth: CGFloat = rect.maxX
        let contentHeight: CGFloat = rect.maxY - arrowHeight
        let arrowPositionX: CGFloat = rect.maxX / 2
        
        let offsetY: CGFloat
        switch position {
        case .top:
            offsetY = 0
        case .bottom:
            offsetY = arrowHeight
        }
        
        // main body
        
        bezierPath.move(
            to: .init(
                x: cornerRadius,
                y: offsetY
            )
        )
        
        bezierPath.addLine(
            to: .init(
                x: contentWidth - cornerRadius,
                y: offsetY
            )
        )
        
        // top right
        bezierPath.addArc(
            withCenter: .init(
                x: contentWidth - cornerRadius,
                y: cornerRadius + offsetY
            ),
            radius: cornerRadius,
            startAngle: radian(-90),
            endAngle: radian(0),
            clockwise: true
        )
        
        bezierPath.addLine(
            to: .init(
                x: contentWidth,
                y: contentHeight - cornerRadius + offsetY
            )
        )
        
        // bottom right
        bezierPath.addArc(
            withCenter: .init(
                x: contentWidth - cornerRadius,
                y: contentHeight - cornerRadius + offsetY
            ),
            radius: cornerRadius,
            startAngle: radian(0),
            endAngle: radian(90),
            clockwise: true
        )
        
        bezierPath.addLine(
            to: .init(
                x: cornerRadius,
                y: contentHeight + offsetY
            )
        )
        
        // bottom left
        bezierPath.addArc(
            withCenter: .init(
                x: cornerRadius,
                y: contentHeight - cornerRadius + offsetY
            ),
            radius: cornerRadius,
            startAngle: radian(90),
            endAngle: radian(180),
            clockwise: true
        )
        
        bezierPath.addLine(
            to: .init(
                x: 0,
                y: cornerRadius + offsetY
            )
        )
        
        // top left
        bezierPath.addArc(
            withCenter: .init(
                x: cornerRadius,
                y: cornerRadius + offsetY
            ),
            radius: cornerRadius,
            startAngle: radian(180),
            endAngle: radian(270),
            clockwise: true
        )
        
        
        // arrow
        switch position {
        case .top:
            bezierPath.move(to: .init(x: arrowPositionX - arrowWidth / 2, y: contentHeight))
            bezierPath.addLine(to: .init(x: arrowPositionX, y: rect.maxY))
            bezierPath.addLine(to: .init(x: arrowPositionX + arrowWidth / 2, y: contentHeight))
        case .bottom:
            bezierPath.move(to: .init(x: arrowPositionX - arrowWidth / 2, y: offsetY))
            bezierPath.addLine(to: .init(x: arrowPositionX, y: 0))
            bezierPath.addLine(to: .init(x: arrowPositionX + arrowWidth / 2, y: offsetY))
        }
    
        // Draw
        balloonBackgroundColor?.setFill()
        bezierPath.fill()
        bezierPath.close()
    }
    
    private func radian(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat(CGFloat.pi) / 180
    }

}
