//
//  ShotInfoTVCell.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/22/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit

let ShotInfoTVCellIdentifier = "ShotInfoTVCell"

class ShotInfoTVCell : UITableViewCell {
    @IBOutlet weak var flightSequenceLbl: UILabel!
    @IBOutlet weak var actionItemsTextView: UITextView!
    @IBOutlet weak var tipsTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var packagingLbl: UILabel!
}
