//
//  FlightControllerManager.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/1/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import DJISDK

class FlightControllerManager: BaseDJIProductListener, DJIFlightControllerDelegate {
    
    var fcState: DJIFlightControllerState!
    var imuState: DJIIMUState!
    
    // singleton access
    static let shared = FlightControllerManager()
    
    // private initialization
    private override init() {
        super.init()
    }
    
    func reset() {

        fcState = nil
        imuState = nil
        
        if let fc = DJIUtils.fetchFlightController() {
            fc.delegate = self
        }
    }

    // called when communication to DJI product has changed
    override func productCommunicationDidChange() {
        
//        if self.appDelegate.productCommManager.connected {
//            reset()
//        }
    }
    
    // MARK: DJIFlightControllerDelegate
    
    /**
     *  Called when the flight controller's current state data has been updated. This
     *  method is called 10 times per second.
     *
     *  @param fc Instance of the flight controller for which the data will be updated.
     *  @param state Current state of the flight controller.
     */
    func flightController(_ fc: DJIFlightController, didUpdate state: DJIFlightControllerState) {
        self.fcState = state
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotifFlightControllerDidUpdateState), object: state)
    }
    
    /**
     *  Called when the flight controller pushes an IMU state update. The callback
     *  method would not be called if the aircraft is flying.
     *
     *  @param fc Instance of the flight controller for which the data will be updated.
     *  @param imuState DJIIMUState object.
     */
    func flightController(_ fc: DJIFlightController, didUpdate imuState: DJIIMUState) {
        self.imuState = imuState
    }

}
