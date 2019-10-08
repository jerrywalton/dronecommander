//
//  FlightSequenceCVCell.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/22/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit

let FlightSequenceCVCellIdentifier = "FlightSequenceCVCell"

class FlightSequenceCVCell: UICollectionViewCell {
    @IBOutlet weak var flightSequenceImageView: UIImageView!
    @IBOutlet weak var flightSequenceLbl: UILabel!
    var flightSequenceNdx: Int!
}
