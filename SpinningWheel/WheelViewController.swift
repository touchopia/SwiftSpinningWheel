//
//  WheelViewController.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import UIKit

class WheelViewController: UIViewController, SpinWheelDelegate {

    var tipImage = UIImageView()
    var wheelCover = SpinImageView()
    var wheelImage = SpinImageView()
    
    let wheelCoverImage = UIImage(named: "wheelCover")!
    let wheelTipsImage = UIImage(named: "wheelTips")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        self.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let wheelFrame = self.view.frame
        
        tipImage = UIImageView(image: wheelTipsImage)
        tipImage.userInteractionEnabled = false
        tipImage.frame = CGRect(x: 0, y: 86, width: 320, height: 196)
        
        tipImage.center = CGPoint(x:width / 2, y: 180)
        
        wheelImage = SpinImageView(frame: wheelFrame, image: wheelTipsImage)
        wheelImage.userInteractionEnabled = true
        wheelImage.delegate = self
        
        // Wheel Cover
        wheelCover = SpinImageView(frame: wheelFrame, image: wheelCoverImage)
        wheelCover.userInteractionEnabled = false
        
        self.view.addSubview(wheelImage)
        self.view.addSubview(wheelCover)
        
        self.showTipNumber(1)
    }
    
    func playClick() {
        
    }
    
    func spinWheelDidStartSpinningFromInertia(wheel: SpinningWheel) {
        
    }
    
    func showTipNumber(number: Int) {
        
        tipImage.hidden = false
        
        let tipImageString = "tip-\(number).png"
        
        if let tip = UIImage(named: tipImageString) {
            tipImage.image = tip
        }
    }
    
    func spinWheelDidFinishSpinning(wheel: SpinningWheel) {
        
        let ceilValue = CGFloat(ceil(fabs(wheel.angle)))
        let floorValue = CGFloat(floor(fabs(wheel.angle)))
        
        var rounded : CGFloat = 0
        
        let calculatedFloorValue =  CGFloat(fabs(floorValue))*0.78 + 0.39
        let calculatedCeilValue  =  CGFloat(fabs(ceilValue))*0.78 + 0.39
        
        let theAngle = CGFloat(fabs(wheel.angle))
        
        if theAngle > calculatedFloorValue && theAngle > calculatedCeilValue {
            rounded = ceilValue + 1;
        }
        else if theAngle > calculatedFloorValue && theAngle < calculatedCeilValue {
            if theAngle - calculatedFloorValue > calculatedCeilValue - theAngle {
                rounded = ceilValue
            } else {
                rounded = floorValue
            }
        }
        else if theAngle < calculatedFloorValue {
            rounded = floorValue
        }
        
        if theAngle < 0 {
            rounded = -rounded;
        }
        
        let newAngle = CGFloat(rounded * 0.78)
        
        if (wheel.isSpinning) {
            wheel.moveFromAngle(wheel.angle, toAngle: newAngle)
        }
        
        if rounded >= 8 {
            rounded -= 8;
        }
        
        if rounded >= 0 {
            self.showTipNumber(Int(rounded) + 1)
        } else if rounded < 0 {
            self.showTipNumber(Int(rounded) + 9)
        }
    }
    
    func spinWheelAngleDidChange(wheel: SpinningWheel) {
        print("moving angle to \(wheel.angle)")
    }
    
    func spinWheelShouldBeginTouch(wheel: SpinningWheel) -> Bool {
        print("spinWheelShouldBeginTouch")
        
        tipImage.hidden = false
        return true
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
