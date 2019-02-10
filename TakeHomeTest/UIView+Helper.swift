//
//  UIView+Helper.swift
//  TakeHomeTest
//
//  Created by Abbas on 2/10/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class RotatingView : UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: RotatingView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: RotatingView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: RotatingView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: RotatingView.kRotationAnimationKey)
        }
    }
}

