//
//  RoundView.swift
//  vkontakte
//
//  Created by Администратор on 19.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class RoundView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = rect.width / 2
        clipsToBounds = true
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap() {
        roundImageCustomAnimation()
    }
    
    func roundImageCustomAnimation() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.1
        animation.toValue = 1
        animation.stiffness = 500
        animation.mass = 1
        animation.duration = 1
        //animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.both
        layer.add(animation, forKey: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
