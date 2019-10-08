//
//  RiskAssessmentCVCell.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/16/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit

let RiskAssessmentCVCellIdentifier = "RiskAssessmentCVCell"

class RiskAssessmentChoiceSegCtl: UISegmentedControl {
    var riskAssessmentNdx: Int!
}

class RiskAssessmentCVCell: UICollectionViewCell {
    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var riskChoicesSegCtl: RiskAssessmentChoiceSegCtl!
    @IBOutlet weak var writeInLabel: UILabel!
    @IBOutlet weak var writeInTextField: UITextField!
    @IBOutlet weak var cardLbl: UILabel!
    var riskAssessmentNdx: Int!
}

