//
//  CustomImageView.swift
//  vkontakte
//
//  Created by Администратор on 05.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class CustomImageView: UIView {
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
