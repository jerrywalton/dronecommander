//
//  HotPointManager.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/27/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import DJISDK

enum HotPointHeading: Int {
    
    case HotpointHeadingAlongCircleLookingForward,
    HotpointHeadingAlongCircleLookingBackward,
    HotpointHeadingTowardHotpoint,
    HotpointHeadingAwayFromHotpoint,
    HotpointHeadingControlledByRemoteController,
    HotpointHeadingUsingInitialHeading
    
    func toDJIHotPointHeading() -> DJIHotpointHeading {
        switch self {
        case .HotpointHeadingAlongCircleLookingForward:
            return DJIHotpointHeading.alongCircleLookingForward
        case .HotpointHeadingAlongCircleLookingBackward:
            return DJIHotpointHeading.alongCircleLookingBackward
        case .HotpointHeadingTowardHotpoint:
            return DJIHotpointHeading.towardHotpoint
        case .HotpointHeadingAwayFromHotpoint:
            return DJIHotpointHeading.awayFromHotpoint
        case .HotpointHeadingControlledByRemoteController:
            return DJIHotpointHeading.controlledByRemoteController
        case .HotpointHeadingUsingInitialHeading:
            return DJIHotpointHeading.usingInitialHeading
        }
    }
    
    func toString() -> String {
        switch self {
        case .HotpointHeadingAlongCircleLookingForward:
            return "Along Circle Looking Forward"
        case .HotpointHeadingAlongCircleLookingBackward:
            return "Along Circle Looking Backward"
        case .HotpointHeadingTowardHotpoint:
            return "Toward Hotpoint"
        case .HotpointHeadingAwayFromHotpoint:
            return "Away From Hotpoint"
        case .HotpointHeadingControlledByRemoteController:
            return "Controlled By Remote Controller"
        case .HotpointHeadingUsingInitialHeading:
            return "Using Initial Heading"
        }
    }
    
    func minRawValue() -> Int {
        return HotPointHeading.HotpointHeadingAlongCircleLookingForward.rawValue
    }
    func maxRawValue() -> Int {
        return HotPointHeading.HotpointHeadingUsingInitialHeading.rawValue
    }
    func defRawValue() -> Int {
        return HotPointHeading.HotpointHeadingControlledByRemoteController.rawValue
    }
}

enum HotpointStartPoint: Int {
    
    case HotpointStartPointNorth,
    HotpointStartPointSouth,
    HotpointStartPointWest,
    HotpointStartPointEast,
    HotpointStartPointNearest
    
    func toDJIStartPoint() -> DJIHotpointStartPoint {
        switch self {
        case .HotpointStartPointNorth:
            return DJIHotpointStartPoint.north
        case .HotpointStartPointSouth:
            return DJIHotpointStartPoint.south
        case .HotpointStartPointWest:
            return DJIHotpointStartPoint.west
        case .HotpointStartPointEast:
            return DJIHotpointStartPoint.east
        case .HotpointStartPointNearest:
            return DJIHotpointStartPoint.nearest
        }
    }
    
    func toString() -> String {
        switch self {
        case .HotpointStartPointNorth:
            return "North"
        case .HotpointStartPointSouth:
            return "South"
        case .HotpointStartPointWest:
            return "West"
        case .HotpointStartPointEast:
            return "East"
        case .HotpointStartPointNearest:
            return "Nearest"
        }
    }
    
    func minRawValue() -> Int {
        return HotpointStartPoint.HotpointStartPointNorth.rawValue
    }
    func maxRawValue() -> Int {
        return HotpointStartPoint.HotpointStartPointNearest.rawValue
    }
    func defRawValue() -> Int {
        return HotpointStartPoint.HotpointStartPointNearest.rawValue
    }
}

class HotPointManager: NSObject {
    
    var lastEvent: DJIHotpointMissionEvent!
    var savedHotPointLatitude: Double!
    var savedHotPointLongitude: Double!
    
    // singleton access
    static let shared = HotPointManager()
    
    // private initialization
    private override init() {
        super.init()
    }
    
    func setup() {
        initEventListener()
    }
    
    func tearDown() {
        DJISDKManager.missionControl()?.tapFlyMissionOperator().removeListener(self)
    }
    
    func initEventListener() {
        DJISDKManager.missionControl()?.hotpointMissionOperator().addListener(toEvents: self, with: nil, andBlock: { (event) in
            
            self.lastEvent = event
            
        })
    }
    
    func updateSavedHotPoint(latitude: Double, longitude: Double) {
        self.savedHotPointLatitude = latitude
        self.savedHotPointLongitude = longitude
    }
    
    func missionFactory(hotPoint: CLLocationCoordinate2D, altitude: Float, angularVelocity: Float, heading: DJIHotpointHeading, radius: Float, startPoint: DJIHotpointStartPoint) -> DJIHotpointMission {
        
        let mission = DJIHotpointMission.init()
        
        // video - 4 min orbit
        // photo - 1 min orbit
        
        mission.altitude = altitude
        mission.angularVelocity = angularVelocity
        mission.heading = heading
        mission.hotpoint = hotPoint
        mission.radius = radius
        mission.startPoint = startPoint
        
        return mission
        
    }
    
    func start(mission: DJIHotpointMission) {
        
        /**
         *  Starts to execute a Hotpoint mission. This only be called when  the
         *  `currentState`  is `DJIHotpointMissionStateReadyToStart`. After a mission is
         *  started  successfully, the `currentState` will  become
         *  `DJIHotpointMissionStateExecutingInitialPhase`  or
         *  `DJIHotpointMissionStateExecuting`.
         *
         *  @param mission An object of `DJIHotpointMission`.
         *  @param completion Completion block that will be called when the operator succeeds or fails to stop  the mission. If it fails, an error will be returned.
         */
        DJISDKManager.missionControl()?.hotpointMissionOperator().start(mission, withCompletion: { (error) in
        })
        
    }
    
    func pause() {
        
        /**
         *  Pauses the executing mission. It can only be called when  the `currentState`  is
         *  `DJIHotpointMissionStateExecutingInitialPhase` or
         *  `DJIHotpointMissionStateExecuting`.  If this method is called in the
         *  `DJIHotpointMissionStateExecutingInitialPhase` state, the aircraft will
         *  continue flying to the start point but it will not continue to circle  around
         *  the  hotpoint until the user resumes the mission. After a mission
         *  is paused successfully, the `currentState` will  become
         *  `DJIHotpointMissionStateExecutionPaused`.
         *
         *  @param completion Completion block that will be called when the operator succeeds or fails to stop  the mission. If it fails, an error will be returned.
         */
        DJISDKManager.missionControl()?.hotpointMissionOperator().pauseMission(completion: { (error) in
        })
        
    }
    
    func resume() {
        
        /**
         *  Resumes the paused mission. It can only be called when  the `currentState`  is
         *  `DJIHotpointMissionStateExecutionPaused`. After a mission is resumed
         *  successfully, the `currentState` will  become
         *  `DJIHotpointMissionStateExecutingInitialPhase`  or
         *  `DJIHotpointMissionStateExecuting`.
         *
         *  @param completion Completion block that will be called when the operator succeeds or fails to stop  the mission. If it fails, an error will be returned.
         */
        DJISDKManager.missionControl()?.hotpointMissionOperator().resumeMission(completion: { (error) in
        })

    }
    
    func stop() {
        
        /**
         *  Stops the executing or paused mission. It can only be called when
         *  `currentState` is one of the following:
         *   - `DJIHotpointMissionStateExecutingInitialPhase`
         *   - `DJIHotpointMissionStateExecuting`
         *   - `DJIHotpointMissionStateExecutionPaused`
         *   After a mission is stopped  successfully, `currentState` will  become
         *  `DJIHotpointMissionStateReadyToStart`.
         *
         *  @param completion Completion block that will be called when the operator succeeds or fails to stop  the mission. If it fails, an error will be returned.
         */
        DJISDKManager.missionControl()?.hotpointMissionOperator().stopMission(completion: { (error) in
        })
        
    }

}
