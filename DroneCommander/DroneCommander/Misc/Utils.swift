//
//  Utils.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/23/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import UIKit

func stringFromDate(_ date: Date, format: String) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

func alert(title: String, text: String, handler: (() -> Void)? = nil) -> UIAlertController {
    let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in handler?() }))
    return alert
}

func animate(block: @escaping () -> Void, with delay: Double = 0.0) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
        UIView.animate(withDuration: 0.25, animations: {
            block()
        })
    })
}

func determineAngularVelocityForRotationalMotion(timeSeconds: Float) -> Double {
    
    // http://www.physicstutorials.org/home/rotational-motion/angular-velocity
    
    // 1) calc frequency
    // frequency = time (raised power -1)
    // frequency = 1/time
    let freq = 1/timeSeconds
    
    // 2) calc angular velocity
    // ω = 2.π.f = 2.3.4 = 24 radian/s
    // ω = 2π/T
    let T = 1/freq
    let W = (2 * Double.pi) / Double(T)
    let D = W * 57.29               // degrees/sec
    return D
}

extension UIColor {
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
