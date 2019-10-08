//
//  ShotSheetManager.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/22/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import UIKit

struct FlightSequence : Codable {
    
    enum ShotStatus {
        case Reset, Complete, MissionComplete
        
        func toImage() -> UIImage {
            switch self {
            case .Reset:
                return UIImage(named: IconFlightSequenceShotStatusReset)!
            case .Complete:
                return UIImage(named: IconFlightSequenceShotStatusComplete)!
            case .MissionComplete:
                return UIImage(named: IconFlightSequenceShotStatusMissionComplete)!
            }
        }
    }
    
    let flightSequence: String
    let actionItems: [String]!
    let notes: [String]!
    let tips: [String]!
    let packaging: String!
    var shotStatus: ShotStatus = ShotStatus.Reset
    
    enum CodingKeys: String, CodingKey {
        case flightSequence = "FlightSequence"
        case actionItems = "ActionItems"
        case notes = "Notes"
        case tips = "Tips"
        case packaging = "Packaging"
    }

    mutating func updateShotStatus(status: ShotStatus) {
        self.shotStatus = status
    }
}

class ShotSheetManager {
    
    enum ShotSequenceState {
        case Reset, Start, MissionComplete
    }
    
    var jsonFilename: String!
    var flightsequence: [FlightSequence]!
    var currentFlightSequenceNdx: Int!
    var shotSequenceState: ShotSequenceState!
    var startDate: Date!
    var completeDate: Date!
    var missionCompleteFlightSequence: FlightSequence!

    // singleton access
    static let shared = ShotSheetManager(jsonFilename: FilenameScopingShotSheet)

    // private initialization
    init(jsonFilename: String) {
        self.jsonFilename = jsonFilename
        readAndParseJSONFile()
        self.shotSequenceState = ShotSequenceState.Reset
        self.currentFlightSequenceNdx = 0
    }

    func readAndParseJSONFile() {
        
        if let filepath = Bundle.main.path(forResource: self.jsonFilename, ofType: nil) {
            do {
                let jsonString = try String(contentsOfFile: filepath)
                let jsonData = jsonString.data(using: .utf8)!
                let decoder = JSONDecoder()
                self.flightsequence = try! decoder.decode([FlightSequence].self, from: jsonData)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
    }
    
    func resetFlightSequence() {
        self.shotSequenceState = ShotSequenceState.Reset
        if (self.missionCompleteFlightSequence != nil) {
            self.flightsequence.popLast()
            self.missionCompleteFlightSequence = nil
        }
        for ndx in 0..<self.flightsequence.count {
            self.flightsequence[ndx].updateShotStatus(status: FlightSequence.ShotStatus.Reset)
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NotifResetShotSequence)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCurrentFlightSequenceIndex(index: 0)
        }
    }
    
    func startFlightSequence() {
        self.startDate = Date()
        self.shotSequenceState = ShotSequenceState.Start
        for ndx in 0..<self.flightsequence.count {
            self.flightsequence[ndx].updateShotStatus(status: FlightSequence.ShotStatus.Reset)
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NotifStartShotSequence)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCurrentFlightSequenceIndex(index: 0)
        }
    }

    func completeMission() {
        self.completeDate = Date()
        self.shotSequenceState = ShotSequenceState.MissionComplete
        self.missionCompleteFlightSequence = FlightSequence(flightSequence: "Mission Complete", actionItems: nil, notes: nil, tips: nil, packaging: nil, shotStatus: FlightSequence.ShotStatus.MissionComplete)
        self.flightsequence.append(self.missionCompleteFlightSequence)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NotifCompleteMissionShotSequence)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCurrentFlightSequenceIndex(index: self.currentFlightSequenceNdx + 1)
        }
    }
    
    func areAllFlightSequencesComplete() -> Bool {
        var allStepsCompleted = true
        for flightsequence in self.flightsequence {
            if (flightsequence.shotStatus != .Complete) {
                allStepsCompleted = false
                break
            }
        }
        return allStepsCompleted
    }
    
    func updateCurrentFlightSequenceIndex(index: Int) {
        if (index >= 0 && index <= self.flightsequence.count) {
            self.currentFlightSequenceNdx = index
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NotifFlightSequenceSelected)))
        }
    }
    
    func incrementFlightSequenceIndex() {
        if ((self.currentFlightSequenceNdx + 1) < self.flightsequence.count) {
            self.currentFlightSequenceNdx! += 1
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NotifFlightSequenceSelected)))
        }
    }
    
    func currentFlightSequence() -> FlightSequence? {
        if (self.flightsequence != nil && self.currentFlightSequenceNdx >= 0 && self.currentFlightSequenceNdx <= self.flightsequence.count) {
            return self.flightsequence[self.currentFlightSequenceNdx]
        }
        return nil
    }
    
}
