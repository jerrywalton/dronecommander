//
//  AircraftCoordinatesWidget.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/11/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import DJIUILibrary

class AircraftCoordinatesWidget: DULWidget {
    
    let coordinatesLabel = UILabel()
    
    override func prepare() { // This is - (void)prepareWidget in Objective-C
        // We do not call super, because we are overriding the whole design aspect
        
        coordinatesLabel.textColor = UIColor.green
        coordinatesLabel.adjustsFontSizeToFitWidth = true
        //coordinatesLabel.font = UIFont.systemFont(ofSize: 24)
        coordinatesLabel.minimumScaleFactor = 0.1
        coordinatesLabel.numberOfLines = 0
        coordinatesLabel.textAlignment = .center
        coordinatesLabel.translatesAutoresizingMaskIntoConstraints = false
        coordinatesLabel.text = String(format: "Lat/Lon: 00.00000, 00.00000")
        self.addSubview(coordinatesLabel)
        coordinatesLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coordinatesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        coordinatesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        coordinatesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.update()
    }
    
    override func update() {
        //        if self.battery1Percentage < 10 {
        //            self.coordinatesLabel.textColor = UIColor.red
        //        } else {
        //            self.coordinatesLabel.textColor = UIColor.green
        //        }
        //
        //        let uiString = String(format: "%.0f", self.battery1Percentage)
        //        self.coordinatesLabel.text = "\(uiString)%"
    }
    
}


