//
//  ViewController.swift
//  Demo
//
//  Created by Jinsei Shima on 2018/11/18.
//  Copyright © 2018 Jinsei Shima. All rights reserved.
//

import UIKit
import PopupView

class ViewController: UIViewController {
    
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        button.center = view.center
        button.setTitle("Hoge", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        button.backgroundColor = UIColor.groupTableViewBackground
        button.layer.cornerRadius = 8

        let label = UILabel()
        label.text = "hoge hoge hoge"
        label.textColor = .lightText
        label.textAlignment = .center
        
        let popupView = PopupView()
        popupView.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        popupView.show(
            contentView: label,
            fromView: button,
            targetView: view,
            appearance: .init(
                backgroundColor: .darkGray,
                position: .top,
                arrowHeight: 12,
                arrowWidth: 24,
                cornerRadius: 8
            ),
            animated: true
        )

    }

}

