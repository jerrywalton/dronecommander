//
//  BaseDJIProductListener.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/1/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import DJISDK

class BaseDJIProductListener: NSObject {
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(productCommunicationDidChange), name: Notification.Name(rawValue: ProductCommunicationManagerStateDidChange), object: nil)
    }
    
    @objc open func productCommunicationDidChange() {
        
        //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
        DJISDKManager.userAccountManager().logIntoDJIUserAccount(withAuthorizationRequired: false) { (state, error) in
            if(error != nil){
                NSLog("Login failed: %@" + String(describing: error))
            }
        }
        
    }
    
}
