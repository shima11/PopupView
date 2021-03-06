//
//  BalloonView.swift
//  PopupView
//
//  Created by Jinsei Shima on 2018/11/19.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit

public class PopupViewContainer: UIView, PopupViewContainerType {
    
    private var contentView: UIView?
    private var appearance: PopupViewAppearance?

    private let shapeLayer = CALayer()
    private let maskLayer = CAShapeLayer()

    // MARK: - initialize
    
    public init() {
        
        super.init(frame: .zero)

        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - functions

    public func set(appearance: PopupViewAppearance) {

        self.appearance = appearance

        setNeedsDisplay()
    }

    public func set(contentView: UIView, appearance: PopupViewAppearance) {

        self.contentView = contentView
        self.appearance = appearance
        
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

        let babblePath = makeBabblePath(rect: bounds, appearance: appearance)
        maskLayer.path = babblePath.cgPath

        shapeLayer.frame = bounds
        shapeLayer.backgroundColor = appearance.backgroundColor.cgColor
        shapeLayer.mask = maskLayer

    }

    public func show() {

        // TODO: animation

//        guard let appearance = appearance else { return }
//
//        let rect = CGRect(x: center.x + 5, y: center.y + 5, width: 10, height: 10)
//        let path1 = makeBabblePath(rect: rect, appearance: appearance).cgPath
//        guard let path2 = maskLayer.path else { return }
//
//        let pathKeyframe = CAKeyframeAnimation(keyPath: "path")
//        pathKeyframe.values = [path1, path2]
//        pathKeyframe.keyTimes = [0, 0.8]
//        pathKeyframe.duration = 1.0
//        pathKeyframe.repeatDuration = .infinity
//        pathKeyframe.isRemovedOnCompletion = false
//        maskLayer.add(pathKeyframe, forKey: "path")
    }

    private func makeBabblePath(rect: CGRect, appearance: PopupViewAppearance) -> UIBezierPath {

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

        // # main body

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

        // ## top right

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

        // ## bottom right

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

        // ## bottom left

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

        // ## top left

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


        // # arrow

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

        return bezierPath
    }
    
    private func radian(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat(CGFloat.pi) / 180
    }
    
}
