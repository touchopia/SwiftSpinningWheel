//
//  SpinImageView.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import UIKit

class SpinImageView: SpinningWheel {
    
    override var angle: CGFloat {
        didSet {
            delegate?.spinWheelAngleDidChange(self)
            
            UIView.animateWithDuration(0.5) { () -> Void in
                self.imageView.layer.transform = CATransform3DMakeRotation(self.angle, 0, 0, 1)
            }
        }
    }
    
    var image = UIImage() {
        didSet {
            self.imageView.image = image
        }
    }
    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        self.image = image
        setupView()
    }
    
    func setupView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        imageView.contentMode = .ScaleAspectFit
        imageView.image = self.image
        self.addSubview(imageView)
    }
}
