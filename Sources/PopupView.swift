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
    
    private var contentView: UIView?
    private var fromView: UIView?
    private var targetView: UIView?
    
//    private let containerView = UIView()
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let fromView = fromView, let contentView = contentView else { return }

        // TODO: いい感じに位置を調整
        
        bounds = CGRect(origin: .zero, size: contentView.bounds.size)
        center = CGPoint(x: fromView.center.x, y: fromView.center.y - fromView.bounds.height / 2 - bounds.height / 2)
        
        contentView.frame = bounds
    }

    public func show(contentView: UIView, fromView: UIView, targetView: UIView, animated: Bool) {

        isHidden = false
        
        self.contentView = contentView
        self.fromView = fromView
        self.targetView = targetView
        
        targetView.addSubview(self)
        addSubview(contentView)
//        addSubview(containerView)
//        containerView.addSubview(contentView)

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


public class ContainerView: UIView {
    
    private let margin: CGFloat = 8
    
    private let label: UILabel = .init()
    
    public init() {
        super.init(frame: .zero)
        
        addSubview(label)

        label.text = "Hoge is hoge."
        label.textAlignment = .center
        
        backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 12
        layer.shadowOffset = .init(width: 0, height: 6)
        layer.shadowOpacity = 0.9
        layer.cornerRadius = 8
        clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(rect: bounds.insetBy(dx: 16, dy: 16)).cgPath
        label.frame = CGRect(x: margin, y: margin, width: bounds.width - margin * 2, height: bounds.height - margin * 2)
    }
    
    @objc private func didTapDoneButton() {
        print("tap done button")
    }
    
}


public class BalloonView: UIView {
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func radian(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat(CGFloat.pi) / 180
    }

    override public func draw(_ rect: CGRect) {
        
        let bezierPath = UIBezierPath()

        let topLeft: CGFloat = 8
        let topRight: CGFloat = 8
        let bottomRight: CGFloat = 8
        let bottomLeft: CGFloat = 8
        
        let arrowHeight: CGFloat = 10
        let arrowWidth: CGFloat = 20

        let arrowPositionX: CGFloat = rect.maxX / 2
            
        //Draw main body
        
        bezierPath.move(to: CGPoint(x: topLeft, y: 0))
        
        bezierPath.addLine(to: CGPoint(x: rect.maxX - topRight, y: 0))
        bezierPath.addArc(
            withCenter: CGPoint(x: rect.maxX - topRight, y: topRight),
            radius: topRight,
            startAngle: radian(-90),
            endAngle: radian(0),
            clockwise: true
        )
        
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight - arrowHeight))
        bezierPath.addArc(
            withCenter: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight - arrowHeight),
            radius: bottomRight,
            startAngle: radian(0),
            endAngle: radian(90),
            clockwise: true
        )
        
        bezierPath.addLine(to: CGPoint(x: bottomLeft, y: rect.maxY - arrowHeight))
        bezierPath.addArc(
            withCenter: CGPoint(x: bottomLeft, y: rect.maxY - bottomLeft - arrowHeight),
            radius: bottomLeft,
            startAngle: radian(90),
            endAngle: radian(180),
            clockwise: true
        )
        
        bezierPath.addLine(to: CGPoint(x: 0, y: topLeft))
        bezierPath.addArc(
            withCenter: CGPoint(x: topLeft, y: topLeft),
            radius: topLeft,
            startAngle: radian(180),
            endAngle: radian(270),
            clockwise: true
        )
        
        
        //Draw the tail
        bezierPath.move(to: CGPoint(x: arrowPositionX - arrowWidth / 2, y: rect.maxY - arrowHeight))
        bezierPath.addLine(to: CGPoint(x: arrowPositionX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: arrowPositionX + arrowWidth / 2, y: rect.maxY - arrowHeight))
        
        // Draw
        UIColor.lightGray.setFill()
        bezierPath.fill()
        bezierPath.close()
        
    }

}
