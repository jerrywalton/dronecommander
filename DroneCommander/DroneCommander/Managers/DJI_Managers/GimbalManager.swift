//
//  GimbalManager.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/1/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import DJISDK

class GimbalManager: BaseDJIProductListener, DJIGimbalDelegate {

    var gimbalState: DJIGimbalState!
    var remainingChargeInPercent: Int = 0
    
    // singleton access
    static let shared = GimbalManager()
    
    // private initialization
    private override init() {
        super.init()
        
        reset()
    }
    
    func reset() {
        if let gimbal = DJIUtils.fetchGimbal() {
            gimbal.delegate = self
        }
    }
    
    // called when communication to DJI product has changed
    override func productCommunicationDidChange() {
        reset()
    }
    
    // MARK: DJIGimbalDelegate
    
    /**
     *  Updates the gimbal's current state.
     *
     *  @param gimbal The gimbal object.
     *  @param state The gimbal state.
     */
    func gimbal(_ gimbal: DJIGimbal, didUpdate state: DJIGimbalState) {
        self.gimbalState = state
    }
    
    
    /**
     *  Update the gimbal's remaining energy in percentage.
     *
     *  @param gimbal An instance of `DJIGimbal`.
     *  @param remainingChargeInPercent An NSInteger value.
     */
    func gimbal(_ gimbal: DJIGimbal, didUpdateBatteryRemainingCharge remainingChargeInPercent: Int) {
        self.remainingChargeInPercent = remainingChargeInPercent
    }
    
}
