//
//  SpinningWheel.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import UIKit

class SpinningWheel: UIView {
    
    var enableSpinning = false
    var isSpinning = false
    
    var angle: CGFloat = 0.0 {
        didSet {
            delegate?.spinWheelAngleDidChange(self)
        }
    }
    
    
    var drag: CGFloat = 0.0
    var angularVelocity: CGFloat = 0.0
    var initialAngle: CGFloat = 0.0
    
    var delegate: SpinWheelDelegate?
    
    var lastTimerDate: NSDate?
    var displayTimer: CADisplayLink?
    
    var previousTouchDate: NSDate?
    
    var currentTouch: UITouch?
    
    var isAnimating = false

    func startAnimating() {
        
        delegate?.spinWheelDidStartSpinningFromInertia(self)
        
        isSpinning = false
        lastTimerDate = nil
        displayTimer = CADisplayLink(target: self, selector: Selector("animationTimer"))
        displayTimer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func stopAnimating() {
        delegate?.spinWheelDidFinishSpinning(self)
        
        isSpinning = false
        
        displayTimer?.invalidate()
        displayTimer = nil
    }
    
    func animationTimer() {
        
        if lastTimerDate == nil {
            lastTimerDate = NSDate()
        }
        else if lastTimerDate != nil && angularVelocity == 0 {
            lastTimerDate = NSDate()
            self.stopAnimating()
        }
        else {
            
            if let timerDate = lastTimerDate {
                let passed = NSDate().timeIntervalSinceDate(timerDate)
                let angleReduction = drag * CGFloat(passed) * abs(angularVelocity)
            
                if (angularVelocity < 0) {
                    angularVelocity += angleReduction
                }
                
                if angularVelocity > 0 {
                    angularVelocity = 0
                }
                else if angularVelocity > 0 {
                    angularVelocity -= angleReduction;
                
                    if angularVelocity < 0 {
                        angularVelocity = 0
                    }
                }
            
                if abs(angularVelocity) < 0.01 {
                    angularVelocity = 0;
                }
            
                var useAngle = self.angle
                
                useAngle += angularVelocity * CGFloat(passed)
            
                // limit useAngle to +/- 2*PI
            
                let pi = CGFloat(2 * M_PI)
                
                if useAngle < 0 {
                    while useAngle < -pi {
                        useAngle += pi
                    }
                } else {
                    while useAngle > pi {
                        useAngle -= pi
                    }
                }
            
                self.angle = useAngle
                
                lastTimerDate = NSDate()
                
                self.setNeedsDisplay()
            }
        }
    }
    
    func calculateFinalAngularVelocity(touch: UITouch) -> CGFloat {
        var finalVelocity: CGFloat = 0.0
        
        if let touchedDate = previousTouchDate {
            let today = NSDate()
            let delay = today.timeIntervalSinceDate(touchedDate)
            let prevAngle = self.angleForPoint(touch.previousLocationInView(self))
            let endAngle = self.angleForPoint(touch.locationInView(self))
            finalVelocity = CGFloat(endAngle - prevAngle) / CGFloat(delay)
        }
        return finalVelocity
    }
    
    func angleForPoint(point: CGPoint) -> CGFloat {
        
        var newAngle = atan2(point.y - self.frame.size.height / 2, point.x - self.frame.size.width / 2)
        
        if (newAngle < 0) {
            newAngle += CGFloat(M_PI * 2)
        }
        return newAngle
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print("touchesBegan")
        
        var shouldReact = true
        
        if let delegate = delegate {
            shouldReact = delegate.spinWheelShouldBeginTouch(self)
        }
        
        if shouldReact && (currentTouch != nil || currentTouch?.phase == UITouchPhase.Cancelled || currentTouch?.phase == UITouchPhase.Ended) {
            currentTouch = touches.first
            angularVelocity	= 0;
            initialAngle = angle;
            previousTouchDate = NSDate()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print("touchesMoved")
        
        if let touch = currentTouch {
            
            if touches.contains(touch) {
                let touchPoint	= touch.locationInView(self)
                let prevPoint	= touch.previousLocationInView(self)
                let	touchAngle	= self.angleForPoint(touchPoint)
                let prevAngle	= self.angleForPoint(prevPoint)
                
                previousTouchDate = NSDate()
                
                var change = touchAngle - prevAngle
                
                let pi = CGFloat(M_PI)
                
                if change > pi {
                    change -= 2 * pi
                } else if change < -pi {
                    change += 2 * pi
                }
                
                self.angle += change
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print("touchesEnded")
        
        if let touch = currentTouch {
            
            if touches.contains(touch) {
                self.angularVelocity = self.calculateFinalAngularVelocity(touch)
                
                if angularVelocity != 0 {
                    previousTouchDate = nil
                }
                
                self.startAnimating()
                
                currentTouch = nil
                
            } else {
                
                let point = self.currentTouch?.locationInView(self)
                let leftTapZone = CGRect(x: 0, y: 20, width: 130, height: 200)
                let rightTapZone = CGRect(x: 172, y: 20, width: 130, height: 200)
                
                if let point = point {
                    if CGRectContainsPoint(leftTapZone, point) {
                        //left tap
                        self.moveFromAngle(self.angle, toAngle:self.angle - CGFloat(M_PI_4))
                    } else if CGRectContainsPoint(rightTapZone, point) {
                        //right tap
                        self.moveFromAngle(self.angle, toAngle:self.angle + CGFloat(M_PI_4))
                    }
                }
            }
        }
    }
    
    func moveFromAngle(fromAngle:CGFloat, toAngle:CGFloat) {
        if(fromAngle>toAngle) {
            print("left")
        }
        
        self.angle = toAngle
        
        delegate?.spinWheelAngleDidChange(self)
    }
}
