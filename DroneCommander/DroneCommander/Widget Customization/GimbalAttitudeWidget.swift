//
//  GimbalAttitudeWidget.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/11/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

//
import UIKit
import DJIUILibrary

class GimbalAttitudeWidget: DULWidget {
    
    let attitudeLabel = UILabel()
    
    override func prepare() { // This is - (void)prepareWidget in Objective-C
        // We do not call super, because we are overriding the whole design aspect
        
        attitudeLabel.textColor = UIColor.green
        attitudeLabel.adjustsFontSizeToFitWidth = true
        //attitudeLabel.font = UIFont.systemFont(ofSize: 24)
        attitudeLabel.minimumScaleFactor = 0.1
        attitudeLabel.numberOfLines = 0
        attitudeLabel.textAlignment = .center
        attitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        attitudeLabel.text = String(format: "Gimbal: 0%@", degreeSymbol)
        self.addSubview(attitudeLabel)
        attitudeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        attitudeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        attitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        attitudeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.update()
    }
    
    override func update() {
        //        if self.battery1Percentage < 10 {
        //            self.attitudeLabel.textColor = UIColor.red
        //        } else {
        //            self.attitudeLabel.textColor = UIColor.green
        //        }
        //
        //        let uiString = String(format: "%.0f", self.battery1Percentage)
        //        self.attitudeLabel.text = "\(uiString)%"
    }
    
}



