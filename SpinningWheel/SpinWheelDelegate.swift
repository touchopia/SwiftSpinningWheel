//
//  SpinWheelDelegate.swift
//  SpinningWheel
//
//  Created by Phil Wright on 12/13/15.
//  Copyright © 2015 Touchopia. All rights reserved.
//

import Foundation

protocol SpinWheelDelegate {
    func spinWheelDidStartSpinningFromInertia(wheel: SpinningWheel)
    func spinWheelDidFinishSpinning(wheel: SpinningWheel)
    func spinWheelAngleDidChange(wheel: SpinningWheel)
    func spinWheelShouldBeginTouch(wheel: SpinningWheel) -> Bool
}
