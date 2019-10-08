//
//  AircraftHeadingWidget.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/11/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import DJIUILibrary

class AircraftHeadingWidget: DULWidget {
    
    let headingLabel = UILabel()
    
    override func prepare() { // This is - (void)prepareWidget in Objective-C
        // We do not call super, because we are overriding the whole design aspect
        
        headingLabel.textColor = UIColor.green
        headingLabel.adjustsFontSizeToFitWidth = true
        //headingLabel.font = UIFont.systemFont(ofSize: 24)
        headingLabel.minimumScaleFactor = 0.1
        headingLabel.numberOfLines = 0
        headingLabel.textAlignment = .center
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.text = String(format: "Head: 0%@", degreeSymbol)
        self.addSubview(headingLabel)
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.update()
    }
    
    override func update() {
        //        if self.battery1Percentage < 10 {
        //            self.headingLabel.textColor = UIColor.red
        //        } else {
        //            self.headingLabel.textColor = UIColor.green
        //        }
        //
        //        let uiString = String(format: "%.0f", self.battery1Percentage)
        //        self.headingLabel.text = "\(uiString)%"
    }
    
}

