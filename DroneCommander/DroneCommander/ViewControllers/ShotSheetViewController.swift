//
//  ShotSheetViewController.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/3/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import DJISDK
import DJIUILibrary

class ShotSheetCVCell : UICollectionViewCell {
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}

class ShotSheetViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "ShotSheetCVCellId"
    
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var flightSequenceTitleLbl: UILabel!
    @IBOutlet weak var flightSequenceStatusImageView: UIImageView!
    @IBOutlet weak var flightSequenceInstructions: UITextView!
    @IBOutlet weak var flightSequenceStatusLbl: UILabel!
    @IBOutlet weak var flightSequenceStatusSwitch: UISwitch!

    var attribStrItalics: AttributedStringBuilder!
    var attribStrBold: AttributedStringBuilder!
    var attribStr: AttributedStringBuilder!
    
    var currentSelectionIndexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.allowsMultipleSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifResetShotSequence), name: NSNotification.Name(rawValue: NotifResetShotSequence), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifStartShotSequence), name: NSNotification.Name(rawValue: NotifStartShotSequence), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifFlightSequenceSelected), name: NSNotification.Name(rawValue: NotifFlightSequenceSelected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifCompleteMissionShotSequence), name: NSNotification.Name(rawValue: NotifCompleteMissionShotSequence), object: nil)

        resetFormControls()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleCloseBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleStartResetBtn() {
        switch ShotSheetManager.shared.shotSequenceState {
        case .Reset:
            promptForStart()
        case .Start:
            if (ShotSheetManager.shared.areAllFlightSequencesComplete()) {
                promptForMissionComplete()
            } else{
                promptForProceedWithoutFlightSequenceComplete()
            }
        case .MissionComplete:
            promptForReset()
        default:
            break
        }
    }
    
    @IBAction func handleFlightSequenceStatusChange(sender: UISwitch) {
        
        let updateStatus = sender.isOn ? FlightSequence.ShotStatus.Complete : FlightSequence.ShotStatus.Reset
        
        ShotSheetManager.shared.flightsequence[ShotSheetManager.shared.currentFlightSequenceNdx]
            .updateShotStatus(status: updateStatus)
        
        self.flightSequenceStatusImageView.image = ShotSheetManager.shared.currentFlightSequence()?.shotStatus.toImage()

        if (sender.isOn) {
            ShotSheetManager.shared.incrementFlightSequenceIndex()
        }
        
        self.collectionView.reloadData()
        
    }
    
    func promptForReset() {
        let alert = UIAlertController.init(title: "Reset Confirmation", message: "Are you sure you want to RESET the current flight sequence?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.destructive, handler: { [weak self] (action) in
            self?.doReset()
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func promptForStart() {
        let alert = UIAlertController.init(title: "Start Confirmation", message: "Are you sure you want to START the current flight sequence?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.destructive, handler: { [weak self] (action) in
            self?.doStart()
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func promptForProceedWithoutFlightSequenceComplete() {
        let alert = UIAlertController.init(title: "Confirmation", message: "Are you sure you want to PROCEED to the FINISH CONFIRMATION? All flight sequence are NOT marked complete!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.destructive, handler: { [weak self] (action) in
            self?.promptForMissionComplete()
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func promptForMissionComplete() {
        let alert = UIAlertController.init(title: "Finish Confirmation", message: "Are you sure you want to FINISH the current flight sequence?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.destructive, handler: { [weak self] (action) in
            self?.doCompleteMission()
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func doReset() {
        ShotSheetManager.shared.resetFlightSequence()
    }
    
    func doStart() {
        self.performSegue(withIdentifier: SegueStartShotSequenceView, sender: nil)
    }
    
    func doCompleteMission() {
        ShotSheetManager.shared.completeMission()
    }
    
    @objc func handleNotifResetShotSequence() {
        self.leftBarButtonItem.title = "Start"
        self.resetFormControls()
        self.collectionView.reloadData()
    }
    
    @objc func handleNotifStartShotSequence() {
        self.leftBarButtonItem.title = "Complete Mission"
        self.resetFormControls()
        self.collectionView.reloadData()
    }

    @objc func handleNotifCompleteMissionShotSequence() {
        self.leftBarButtonItem.title = "Reset"
        self.resetFormControls()
        self.collectionView.reloadData()
    }
    
    @objc func handleNotifFlightSequenceSelected() {

        let flightSequence = ShotSheetManager.shared.currentFlightSequence()

        if (flightSequence != nil) {
            
            self.flightSequenceTitleLbl.text = flightSequence?.flightSequence
            
            self.flightSequenceStatusImageView.image = flightSequence?.shotStatus.toImage()
            
            let periodChar: Character = "."
            let spaces = "  "
            
            let actionItemsTitle = "Actions:"
            let tipsTitle = "Tips:"
            let notesTitle = "Notes:"
            let startDateTitle = "Start:"
            let finishDateTitle = "Finish:"
            let durationDateTitle = "Duration:"

            let combinedInstructions = NSMutableAttributedString()
            var hasCombinedInstructions = false
            
            initAttribBuilders()

            if (flightSequence?.shotStatus == FlightSequence.ShotStatus.MissionComplete) {
                

                // flight sequence start date
                attribStrBold
                    .text(startDateTitle)
                    .space()
                attribStr.text(stringFromDate(ShotSheetManager.shared.startDate, format: dateFormatString)!)
                combinedInstructions.append(attribStrBold.attributedString)
                combinedInstructions.append(attribStr.attributedString)

                initAttribBuilders()

                // flight sequence start date
                attribStrBold
                    .newline()
                    .text(finishDateTitle)
                    .space()
                attribStr.text(stringFromDate(ShotSheetManager.shared.completeDate, format: dateFormatString)!)
                combinedInstructions.append(attribStrBold.attributedString)
                combinedInstructions.append(attribStr.attributedString)
                
                initAttribBuilders()

                let fsDur = ShotSheetManager.shared.completeDate.timeIntervalSince(ShotSheetManager.shared.startDate)

                // "2 min, 3 sec"
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .short
                formatter.allowedUnits = [.minute, .second]
                let durStr =  formatter.string(from: fsDur)

                // flight sequence duration
                attribStrBold
                    .newline()
                    .text(durationDateTitle)
                    .space()
                attribStr.text(durStr!)
                combinedInstructions.append(attribStrBold.attributedString)
                combinedInstructions.append(attribStr.attributedString)
                
            } else {
                
                // action items text
                var actionItems = String()
                var hasActionItems = false
                if (flightSequence?.actionItems != nil) {
                    for actionItem in (flightSequence?.actionItems)! {
                        if (hasActionItems) {
                            actionItems.append(spaces)
                        }
                        actionItems += actionItem
                        if !(actionItem.last == periodChar) {
                            actionItems.append(periodChar)
                        }
                        hasActionItems = true
                    }
                    if (hasActionItems) {
                        attribStrBold
                            .text(actionItemsTitle)
                            .space()
                        attribStr.text(actionItems)
                        combinedInstructions.append(attribStrBold.attributedString)
                        combinedInstructions.append(attribStr.attributedString)
                        hasCombinedInstructions = true
                    }
                }
                
                initAttribBuilders()
                
                // tips text
                var tips = String()
                var hasTips = false
                if (flightSequence?.tips != nil) {
                    for tip in (flightSequence?.tips)! {
                        if (hasTips) {
                            tips.append(spaces)
                        }
                        tips += tip
                        if !(tip.last == periodChar) {
                            tips.append(periodChar)
                        }
                        hasTips = true
                    }
                    if (hasTips) {
                        if (hasCombinedInstructions) {
                            self.attribStr.newline()
                            combinedInstructions.append(self.attribStr.attributedString)
                            self.attribStr = builderAttrib()
                        }
                        attribStrBold
                            .text(tipsTitle)
                            .space()
                        attribStrItalics.text(tips)
                        combinedInstructions.append(attribStrBold.attributedString)
                        combinedInstructions.append(attribStrItalics.attributedString)
                        hasCombinedInstructions = true
                    }
                }
                
                initAttribBuilders()
                
                // notes text
                var notes = String()
                var hasNotes = false
                if (flightSequence?.notes != nil) {
                    for note in (flightSequence?.notes)! {
                        if (hasNotes) {
                            notes.append(spaces)
                        }
                        notes += note
                        if !(note.last == periodChar) {
                            notes.append(periodChar)
                        }
                        hasNotes = true
                    }
                    if (hasNotes) {
                        if (hasCombinedInstructions) {
                            self.attribStr.newline()
                            combinedInstructions.append(self.attribStr.attributedString)
                            self.attribStr = builderAttrib()
                        }
                        attribStrBold
                            .text(notesTitle)
                            .space()
                        attribStr.text(notes)
                        combinedInstructions.append(attribStrBold.attributedString)
                        combinedInstructions.append(attribStr.attributedString)
                    }
                }
                
                self.flightSequenceStatusSwitch.setOn(flightSequence?.shotStatus == .Complete, animated: true)
            }
            
            self.flightSequenceInstructions.attributedText = combinedInstructions
        
        } else{
            
            resetFormControls()
        }
        
        self.collectionView.reloadData()

    }
    
    func resetFormControls() {
        
        self.flightSequenceStatusImageView.image = FlightSequence.ShotStatus.Reset.toImage()
        self.flightSequenceTitleLbl.text = ""
        self.flightSequenceInstructions.text = ""
        
        switch ShotSheetManager.shared.shotSequenceState {
        case .Reset:
            self.leftBarButtonItem.title = "Start Sequence"
            self.flightSequenceStatusLbl.isHidden = true
            self.flightSequenceStatusSwitch.isHidden = true
        case .Start:
            self.leftBarButtonItem.title = "Finish Sequence"
            self.flightSequenceStatusLbl.isHidden = false
            self.flightSequenceStatusSwitch.isHidden = false
            self.flightSequenceStatusSwitch.isEnabled = true
        case .MissionComplete:
            self.leftBarButtonItem.title = "Reset"
            self.flightSequenceStatusLbl.isHidden = true
            self.flightSequenceStatusSwitch.isEnabled = true
        default:
            break
        }
    }
    
    // MARK: attributed string builders
    
    func builderAttribItalics() -> AttributedStringBuilder {
        let builder = AttributedStringBuilder()
        builder.defaultAttributes = [
            .textColor(UIColor.black),
            .font( UIFont.italicSystemFont(ofSize: 16) ),
            .alignment(.left)
        ]
        return builder
    }
    
    func builderAttribBold() -> AttributedStringBuilder {
        let builder = AttributedStringBuilder()
        builder.defaultAttributes = [
            .textColor(UIColor.black),
            .font( UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold) ),
            .alignment(.left)
        ]
        return builder
    }
    
    func builderAttrib() -> AttributedStringBuilder {
        let builder = AttributedStringBuilder()
        builder.defaultAttributes = [
            .textColor(UIColor.black),
            .font( UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular) ),
            .alignment(.justified)
        ]
        return builder
    }
    
    func initAttribBuilders() {
        self.attribStrItalics = builderAttribItalics()
        self.attribStrBold = builderAttribBold()
        self.attribStr = builderAttrib()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cnt = ShotSheetManager.shared.flightsequence.count
        return cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShotSheetCVCell
        
        let flightSequence = ShotSheetManager.shared.flightsequence[indexPath.row]
        
        cell.titleLbl.text = flightSequence.flightSequence
        cell.imageView.image = UIImage(named: "movie_clapboard")
        
        cell.statusImageView.image = flightSequence.shotStatus.toImage()
        
        cell.layer.cornerRadius = 11.0
        cell.layer.backgroundColor = UIColor.lightGray.cgColor

        if (indexPath.row == ShotSheetManager.shared.currentFlightSequenceNdx) {
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 2.0
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            }

        } else{
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        removeSelectionHighlight()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ShotSheetManager.shared.updateCurrentFlightSequenceIndex(index: indexPath.row)
        
    }
    
    func removeSelectionHighlight() {
        for ndx in 0..<self.collectionView.numberOfItems(inSection: 0) {
            let cell = collectionView.cellForItem(at: IndexPath(row: ndx, section: 0))
            cell?.layer.borderWidth = 0
        }
    }
    
}

