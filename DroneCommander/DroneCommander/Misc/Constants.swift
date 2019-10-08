//
//  Constants.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/11/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit

//  misc
let degreeSymbol = "º"      // the degree symbol

// flight risk assessment
let IconPreFlightRiskAssessment = "file-list-tick-7" //"clipboard-outline"
let IconPreFlightRiskAssessmentLow = "clipboard-low"
let IconPreFlightRiskAssessmentModerate = "clipboard-mod"
let IconPreFlightRiskAssessmentHigh = "clipboard-high"

let IconNextArrow = "next_arrow_green" //"next_arrow_blue"
let IconPrevArrow = "prev_arrow_green" //"prev_arrow_blue"

let ColorNotSelected = UIColor.lightGray //UIColor(red: 0.00, green: 0.478, blue: 1.0, alpha: 1.0)
let ColorLow = UIColor(red: 196/255.0, green: 214/255.0, blue: 158/255.0, alpha: 1.0)
let ColorModerate = UIColor(red: 234/255.0, green: 231/255.0, blue: 53/255.0, alpha: 1.0)
let ColorHigh = UIColor(red: 249/255.0, green: 191/255.0, blue: 146/255.0, alpha: 1.0)

let ColorTotalPointsUnknown = ColorNotSelected
let ColorTotalPointsLow = ColorLow
let ColorTotalPointsModerate = ColorModerate
let ColorTotalPointsHigh = ColorHigh

let ColorOverallAssessmentUnknown = ColorNotSelected
let ColorOverallAssessmentLow = ColorLow
let ColorOverallAssessmentModerate = ColorModerate
let ColorOverallAssessmentHigh = ColorHigh

let ColorApprovalAuthorityUnknown = ColorNotSelected
let ColorApprovalAuthorityPIC1 = UIColor.gray
let ColorApprovalAuthorityPIC2 = UIColor.gray
let ColorApprovalAuthorityHigh = UIColor.red

// shotsheet
let IconShotSheet = "photo-book-tick-7" //"image-album"
let IconFlightSequenceShotStatusReset = "list_numbers"
let IconFlightSequenceShotStatusComplete = "checkmark_green"
let IconFlightSequenceShotStatusMissionComplete = "flag_finish"
let IconHotPointMission = "business-target-7"

//
let IconPreFlightChecklist = "check_list_48x48"
//let IconAirspace = "plane_takeoff_48x48" //"airplane_48x48"
let IconHardHat = "hard_hat_48x48"
let IconSafetyVest = "safety_vest_48x48"
let IconTrafficCone = "traffic_cone_48x48"
let IconWeatherBrief = "weather_partly_cloudy_48x48"
let IconBatteryCharge = "battery_charge_48x48"
let IconSdCard = "micro_sd_card_48x48" //"sd_card_48x48"
//let IconPropeller = "propeller"
let IconStartShotSequenceButton = "start_button"

let IconDroneSmall = "drone_16x16"
let IconDroneMedium = "drone_20x20"
let IconDroneLarge = "drone_24x24"
let IconCloseBtn = "close"
let IconEdit = "edit_pencil"
let IconClockwise = "clockwise_arrow"
let IconCounterClockwise = "counter_clockwise_arrow"
let IconMinimizeView = "minimize"
let IconMaximizeView = "maximize"

// notifs
let NotitPreFlightRiskAssessmentView = "NotitPreFlightRiskAssessmentView"
let NotifShowShotSheetView = "NotifShowShotSheetView"
let NotifShowSetHotPointView = "NotifShowSetHotPointView"
let NotifCloseSetHotPointView = "NotifCloseSetHotPointView"
let NotifShowHotPointMissionView = "NotifShowHotPointMissionView"
let NotifCloseHotPointMissionView = "NotifCloseHotPointMissionView"
let NotifResetShotSequence = "NotifResetShotSequence"
let NotifStartShotSequence = "NotifStartShotSequence"
let NotifCompleteMissionShotSequence = "NotifCompleteMissionShotSequence"
let NotifIncrementShotSequence = "NotifIncrementShotSequence"
let NotifFlightSequenceSelected = "NotifFlightSequenceSelected"
let NotifFlightControllerDidUpdateState = "NotifFlightControllerDidUpdateState"
let NotifPointingTouchViewCoordOfLastTouch = "NotifPointingTouchViewCoordOfLastTouch"

// segues
let SeguePreFlightRiskAssessmentView = "SeguePreFlightRiskAssessmentView"
let SegueShotSheetView = "SegueShotSheetView"
let SegueSetHotPointView = "SegueSetHotPointView"
let SegueStartShotSequenceView = "SegueStartShotSequenceView"

let TextNotSelected = "n/a"
let TextRiskAssessmentNotSelected = TextNotSelected
let TextApprovalAuthorityPIC = "PIC"
let TextApprovalAuthoritySupervisor = "Supervisor\n(Discussion)"

let IconRiskAssessmentGroupCrewHealth = "health_medical"
let IconRiskAssessmentGroupWeather = "weather_alert"
let IconRiskAssessmentGroupFlightConditions = "wind_sock"

//https://www.iconfinder.com/icons/463017/cancel_circle_close_delete_exit_remove_stop_icon#size=48

// risk assessment results
let TextRiskAssessmentTotalPointsLow = "16-23" //"16-23 (Low)"
let TextRiskAssessmentTotalPointsModerate = "24-32" //"24-32 (Moderate)"
let TextRiskAssessmentTotalPointsHigh = "33 or\nGreater" //"33 or Greater (High)"
let TextRiskAssessmentApprovalAuthorityLow = "PIC"
let TextRiskAssessmentApprovalAuthorityModerate = "PIC"
let TextRiskAssessmentApprovalAuthorityHigh = "Supervisor\n(Discussion)"
let TextRiskAssessmentOverallRiskLow = "LOW"
let TextRiskAssessmentOverallRiskModerate = "MODERATE"
let TextRiskAssessmentOverallRiskHigh = "HIGH"

// shot sheet
let FilenameScopingShotSheet = "scoping_profile_shot_sheet_v2.json"

//
let dateFormatString = "MMM. dd, yyyy HH:mm" //"yyyy/MMM/dd HH:mm:ss"

let INVALID_POINT = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.leastNormalMagnitude)

protocol EnumValueSpecifier {
    func minRawValue() -> Int
    func maxRawValue() -> Int
    func defRawValue() -> Int
    func allStringValues() -> [String]
    func stringToRawValue(stringValue: String) -> Int
    func rawValueToString(rawValue: Int) -> String
}

protocol Number {
    var floatValue: Float { get } // the { get } means that the variable must be read only
    var intValue: Int { get } // the { get } means that the variable must be read only
}

class ValueHolder : NSObject, Number {

    var value: Int = Int.max
    
    init(value: Int) {
        self.value = value
    }
    
    // BLOCK: protocol Number
    var floatValue: Float {
        return Float(self.value)
    } // the { get } means that the variable must be read only
    var intValue: Int {
        return self.value
    } // the { get } means that the variable must be read only
}

enum EnumSpecial : Int, EnumValueSpecifier {

    case UnknownValue = -1
    
    func minRawValue() -> Int {
        return EnumSpecial.UnknownValue.rawValue
    }
    
    func maxRawValue() -> Int {
        return EnumSpecial.UnknownValue.rawValue
    }
    
    func defRawValue() -> Int {
        return EnumSpecial.UnknownValue.rawValue
    }
    
    func allStringValues() -> [String] { return ["Unknown"] }
    func stringToRawValue(stringValue: String) -> Int { return EnumSpecial.UnknownValue.rawValue }
    func rawValueToString(rawValue: Int) -> String { return "Unknown" }
}

