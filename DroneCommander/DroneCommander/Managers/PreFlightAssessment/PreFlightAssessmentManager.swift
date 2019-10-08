//
//  PreFlightAssessmentManager.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/12/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import DJIUILibrary

enum GroupTitle: String {
    case Crew_Health = "Crew Health"
    case Weather = "Weather"
    case Flight_Condiitons = "Flight Conditions"
    
    func groupTitleIconImage() -> UIImage {
        switch self {
        case .Crew_Health:
            return UIImage(named: IconRiskAssessmentGroupCrewHealth)!
        case .Weather:
            return UIImage(named: IconRiskAssessmentGroupWeather)!
        case .Flight_Condiitons:
            return UIImage(named: IconRiskAssessmentGroupFlightConditions)!
        }
    }
}

enum RiskAssessmentType {
    case Choice, WriteIn
}

enum TotalPointsType: Int {
    case Unknown, Low, Moderate, High
    
    init(totalPoints: Int) {
        if (totalPoints >= 16 && totalPoints <= 24) {
            self = .Low
        } else if (totalPoints >= 25 && totalPoints <= 32) {
            self = .Moderate
        } else if (totalPoints >= 33) {
            self = .High
        } else {
            self = .Unknown
        }
    }
    
    func toString() -> String {
        switch self {
        case .Unknown:
            return TextNotSelected
        case .Low:
            return TextRiskAssessmentTotalPointsLow
        case .Moderate:
            return TextRiskAssessmentTotalPointsModerate
        case .High:
            return TextRiskAssessmentTotalPointsHigh
        }
    }
    
    func toColor() -> UIColor {
        switch self {
        case .Unknown:
            return ColorTotalPointsUnknown
        case .Low:
            return ColorTotalPointsLow
        case .Moderate:
            return ColorTotalPointsModerate
        case .High:
            return ColorTotalPointsHigh
        }
    }
    
}

enum OverallAssessmentType: Int {
    case Unknown, Low, Moderate, High
    
    init?(totalPoints: Int) {
        switch totalPoints {
        case 0...15: self = .Unknown
        case 16...24: self = .Low
        case 25...32: self = .Moderate
        case 32...100: self = .High
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Unknown:
            return TextNotSelected
        case .Low:
            return TextRiskAssessmentOverallRiskLow
        case .Moderate:
            return TextRiskAssessmentOverallRiskModerate
        case .High:
            return TextRiskAssessmentOverallRiskHigh
        }
    }
    
    func toColor() -> UIColor {
        switch self {
        case .Unknown:
            return ColorOverallAssessmentUnknown
        case .Low:
            return ColorOverallAssessmentLow
        case .Moderate:
            return ColorOverallAssessmentModerate
        case .High:
            return ColorOverallAssessmentHigh
        }
    }

}

enum ApprovalAuthorityType: Int {
    case Unknown, PIC1, PIC2, Supervisor
    
    init?(totalPoints: Int) {
        switch totalPoints {
        case 0...15: self = .Unknown
        case 16...24: self = .PIC1
        case 25...32: self = .PIC2
        case 32...100: self = .Supervisor
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Unknown:
            return TextNotSelected
        case .PIC1:
            return TextApprovalAuthorityPIC
        case .PIC2:
            return TextApprovalAuthorityPIC
        case .Supervisor:
            return TextApprovalAuthoritySupervisor
        }
    }
    
    func toColor() -> UIColor {
        switch self {
        case .Unknown:
            return ColorApprovalAuthorityUnknown
        case .PIC1:
            return ColorApprovalAuthorityPIC1
        case .PIC2:
            return ColorApprovalAuthorityPIC2
        case .Supervisor:
            return ColorApprovalAuthorityHigh
        }
    }
    
}

struct RiskAssessment {
    let riskAssessmentType: RiskAssessmentType
    var groupTitle: GroupTitle
    let title: String
    var choices: [String]!
    var selection: Int = Int(0)
    var writeInText: String = String("")
    var riskAssessmentNdx: Int!

    init(type: RiskAssessmentType, groupTitle: GroupTitle, title: String, choices: [String]) {
        self.riskAssessmentType = type
        self.groupTitle = groupTitle
        self.title = title
        self.choices = [String]()
        self.choices.append(TextRiskAssessmentNotSelected)
        for choice in choices {
            self.choices.append(choice)
        }
    }
    
    mutating func updateSelection(selectionNdx: Int) {
        selection = selectionNdx
    }

    mutating func updateWriteInText(text: String) {
        writeInText = text
    }
    
}

class PreFlightAssessmentManager: NSObject {

    //  MARK: properties
    var riskAssessments = [RiskAssessment]()

    // singleton access
    static let shared = PreFlightAssessmentManager()
    
    var totalPointsType: TotalPointsType!
    var overallAssessmentType: OverallAssessmentType!
    var approvalAuthorityType: ApprovalAuthorityType!
    
    var isReset: Bool!
    
    // private initialization
    private override init() {
        super.init()
        reset()
    }

    func reset() {
        
        self.isReset = true
        
        // crew health
        riskAssessments = [
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Crew_Health, title: "Off Duty Hours", choices: ["Greater Than 10 Hours", "Eight To Ten Hours", "Less Than Eight Hours"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Crew_Health, title: "Medication", choices: ["None / Non-Drowsy", "Low-Moderate Effects", "High-Severe Effects"]),
        
        // weather
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Weather, title: "Clouds", choices: ["> 1000 ft AGL", "700-1000 ft AGL", "<700 ft AGL"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Weather, title: "Winds (Surface)", choices: ["Calm-10 mph", "10-20 mph", ">20 mph"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Weather, title: "Precip", choices: ["None", "Mist-Light in Area", "Moderate to Heavy"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Weather, title: "Temp", choices: ["40º to 80º", "<32º or >90º", "<25º or >100º"]),
        
        // flight conditions
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Pilot Currency", choices: ["2 Weeks or Less", "2-4 Weeks", "4 Weeks or Greater"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Safety Observer (if Applicable)", choices: ["2 Weeks or Less", "2-4 Weeks", "4 Weeks or Greater"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Structure Type", choices: ["Monopole or Lattice", "Guy Wire or Powerline", "Other"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Structure Height (Pt 107 Rules)", choices: ["Below 300 ft", "300-500 ft", "Above 500 ft"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Other Obstacles", choices: ["None", "Greater than 50 ft", "Within 50 ft"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Airports", choices: ["5 NM or Greater", "2-5 NM", "Within 2 NM"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Non-Participants", choices: ["Greater than 500 ft", "Within 500 ft", "On-Site"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Wildlife", choices: ["Urban", "Suburban", "Rural"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Safe Ditching Areas", choices: ["3 Sites or More", "2 Sites", "Only 1 LZ"]),
            RiskAssessment(type: RiskAssessmentType.Choice, groupTitle: GroupTitle.Flight_Condiitons, title: "Estimated Duty Day", choices: ["10 Hours of Less", "10-12 Hours", ">12 Hours"]),
            RiskAssessment(type: RiskAssessmentType.WriteIn, groupTitle: GroupTitle.Flight_Condiitons, title: "Other (Write-In)", choices: ["Low", "Moderate", "High"])
        ]
        
        self.totalPointsType = TotalPointsType.init(totalPoints: 0)
        self.overallAssessmentType = OverallAssessmentType.init(totalPoints: 0)
        self.approvalAuthorityType = ApprovalAuthorityType.init(totalPoints: 0)
        print("\(self.totalPointsType) \(self.overallAssessmentType) \(self.approvalAuthorityType)")
    }
    
    func updateRiskAssessment(riskAssessmentNdx: Int, selection: Int) {
        self.riskAssessments[riskAssessmentNdx].selection = selection
        self.isReset = false
    }
    
    func riskAssessmentsToString() -> String {
        var strbuf = String()
        for riskAssessment in riskAssessments {
            if (riskAssessment.riskAssessmentType == RiskAssessmentType.Choice) {
                strbuf += String("Risk: \(riskAssessment.title) Assessment: \(riskAssessment.choices[riskAssessment.selection])\n")
            } else if (riskAssessment.riskAssessmentType == RiskAssessmentType.WriteIn) {
                strbuf += String("Risk: \(riskAssessment.title) Assessment: \(riskAssessment.choices[riskAssessment.selection]) Text: \(riskAssessment.writeInText)\n")
            }
        }
        strbuf += String(format: "\n\nTotal Points: %d\n\n", self.overallRiskAssessmentGrade())
        return strbuf
    }
    
    func overallRiskAssessmentGrade() -> Int {
        var totalPoints = Int(0)
        for riskAssessment in riskAssessments {
            totalPoints += riskAssessment.selection
        }
        return totalPoints
    }
    
    func calcResults() {
        let totalPoints = self.overallRiskAssessmentGrade()
        self.totalPointsType = TotalPointsType.init(totalPoints: totalPoints)
        self.overallAssessmentType = OverallAssessmentType.init(totalPoints: totalPoints)
        self.approvalAuthorityType = ApprovalAuthorityType.init(totalPoints: totalPoints)
    }
    
}

