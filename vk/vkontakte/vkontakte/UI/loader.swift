//
//  loader.swift
//  vkontakte
//
//  Created by Администратор on 19.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class loader: UIView {
    @IBOutlet weak var loader1: RoundView!
    @IBOutlet weak var loader2: RoundView!
    @IBOutlet weak var loader3: RoundView!
    
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
                        self.loader1.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            self.loader1.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        UIView.animate(withDuration: 0.6,
                       delay: 0.3,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
                        self.loader2.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            self.loader2.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        UIView.animate(withDuration: 0.6,
                       delay: 0.6,
                       options: [.repeat, .autoreverse, .curveLinear],
                       animations: {
                        self.loader3.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            self.loader3.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    func xibSetup() {
        contentView = loadFromXIB()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    func loadFromXIB() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return xib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
