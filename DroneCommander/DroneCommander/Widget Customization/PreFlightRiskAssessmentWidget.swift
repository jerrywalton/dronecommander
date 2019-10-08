//
//  PreFlightRiskAssessmentWidget.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/11/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import DJIUILibrary

class PreFlightRiskAssessmentWidget: DULWidget {
    
    let button = UIButton(type: UIButtonType.custom) as UIButton
    
    override func prepare() { // This is - (void)prepareWidget in Objective-C
        // We do not call super, because we are overriding the whole design aspect
        
        button.setImage(UIImage(named: IconPreFlightRiskAssessment), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
//        button.layer.cornerRadius = 30
//        button.clipsToBounds = true
//        button.layer.backgroundColor = ColorFlightRiskAssessmentLow.cgColor
//        button.layer.backgroundColor = ColorFlightRiskAssessmentModerate.cgColor
//        button.layer.backgroundColor = ColorFlightRiskAssessmentHigh.cgColor
        self.aspectRatio = 2.0
        self.update()
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        print("Button tapped")
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotitPreFlightRiskAssessmentView), object: nil)
    }
    
    override func update() {
    }
    
}

