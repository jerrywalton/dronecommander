//
//  StartShotSequenceVC.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/24/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit

class PreStartActivitySwitch: UISwitch {
    var preStartActivityNdx: Int!
}

class PreStartActivityCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var completedSwitch: PreStartActivitySwitch!
}

class StartShotSequenceCell : UICollectionViewCell {
    @IBOutlet weak var startButton: UIButton!
}

struct PreStartActivity {
    
    enum CompletionStatus {
        case Incomplete, Complete
    }
    
    let title: String
    let iconImage: String
    var completionStatus: CompletionStatus!
    
    init(title: String, iconImage: String) {
        self.title = title
        self.iconImage = iconImage
        self.completionStatus = CompletionStatus.Incomplete
    }
    
    mutating func updateStatus(status: CompletionStatus) {
        self.completionStatus = status
    }
}

class StartShotSequenceVC: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    
    let preStartActivityCellIdentifier = "PreStartActivityCellIdentifier"
    let startShotSequenceCellIdentifier = "StartShotSequenceCellIdentifier"
    var numberOfItems: Int!
    var preStartActivities: [PreStartActivity]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {

        self.preStartActivities = [PreStartActivity]()
        self.preStartActivities.append(PreStartActivity(title: "PreFlight Chk", iconImage: IconPreFlightChecklist))
        self.preStartActivities.append(PreStartActivity(title: "Traffic Cones", iconImage: IconTrafficCone))
        self.preStartActivities.append(PreStartActivity(title: "Hard Hat", iconImage: IconHardHat))
        self.preStartActivities.append(PreStartActivity(title: "Safety Vest", iconImage: IconSafetyVest))
        self.preStartActivities.append(PreStartActivity(title: "Battery Charge", iconImage: IconBatteryCharge))
        self.preStartActivities.append(PreStartActivity(title: "Sd Card", iconImage: IconSdCard))

        self.numberOfItems = self.preStartActivities.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleCancelBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleStartBtn() {
        self.dismiss(animated: true) {
            ShotSheetManager.shared.startFlightSequence()
        }
    }
    
    @IBAction func handleActivitySwitchChanged(sender: PreStartActivitySwitch) {
        
        let status = sender.isOn ? PreStartActivity.CompletionStatus.Complete : PreStartActivity.CompletionStatus.Incomplete
        self.preStartActivities[sender.preStartActivityNdx].updateStatus(status: status)
        
        checkForComplete()

    }
    
    func checkForComplete() {

        var allComplete = true
        for psa in self.preStartActivities {
            if (psa.completionStatus != PreStartActivity.CompletionStatus.Complete) {
                allComplete = false
                break
            }
        }
        
        if (allComplete) {
            self.numberOfItems = self.preStartActivities.count + 1
        } else{
            self.numberOfItems = self.preStartActivities.count
        }
        
        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell!
        
        switch indexPath.row {
        case 0...self.preStartActivities.count-1:
            let psaCell = collectionView.dequeueReusableCell(withReuseIdentifier: preStartActivityCellIdentifier, for: indexPath) as! PreStartActivityCell
            
            psaCell.imageView.image = UIImage(named: self.preStartActivities[indexPath.row].iconImage)
            psaCell.titleLbl.text = self.preStartActivities[indexPath.row].title
            psaCell.completedSwitch.isOn = self.preStartActivities[indexPath.row].completionStatus == PreStartActivity.CompletionStatus.Complete
            psaCell.completedSwitch.preStartActivityNdx = indexPath.row
            
            psaCell.layer.backgroundColor = UIColor.lightGray.cgColor

            cell = psaCell
        default:
            let sssCell = collectionView.dequeueReusableCell(withReuseIdentifier: startShotSequenceCellIdentifier, for: indexPath) as! StartShotSequenceCell

            sssCell.layer.backgroundColor = UIColor.green.cgColor
            
            cell = sssCell
            
        }
        
        cell.layer.cornerRadius = 11.0
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

}

