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

        let contentView = ContainerView()
        contentView.bounds = CGRect(x: 0, y: 0, width: 160, height: 80)
        
        let ballonView = BalloonView()
        ballonView.frame = CGRect(x: 0, y: 0, width: 160, height: 80)
        
        let popupView = PopupView()
        popupView.show(
            contentView: ballonView,
            fromView: button,
            targetView: view,
            animated: true
        )

    }

}

