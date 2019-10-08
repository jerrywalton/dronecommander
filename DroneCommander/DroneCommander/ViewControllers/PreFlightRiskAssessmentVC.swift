//
//  PreFlightRiskAssessmentVC.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/14/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import DJISDK
import DJIUILibrary
//import PagedHorizontalView

class PreFlightRiskAssessmentVC: UIViewController, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    enum ViewOption: Int {
        case OverallAssessment, RiskQuestions
    }
    
    var activeField: UITextField?
    
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var horizontalView: PagedHorizontalView!
    @IBOutlet weak var viewOptionsSegCtl: UISegmentedControl!
    @IBOutlet weak var totalPointsLbl: UILabel!
    @IBOutlet weak var approvalAuthorityLbl: UILabel!
    @IBOutlet weak var overallRiskLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var pilotTxtFld: UITextField!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let dateFormatter = DateFormatter()
    var selectedViewOption: ViewOption!
    
    var cellSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.resultsView.layer.cornerRadius = 11.0
        self.horizontalView.collectionView.layer.cornerRadius = 11.0
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.totalPointsLbl.layer.cornerRadius = self.totalPointsLbl.frame.size.width / 2
        self.totalPointsLbl.layer.borderWidth = 1.0
        self.totalPointsLbl.clipsToBounds = true
        
        self.overallRiskLbl.layer.cornerRadius = self.totalPointsLbl.frame.size.width / 2
        self.overallRiskLbl.layer.borderWidth = 1.0
        self.overallRiskLbl.clipsToBounds = true
        
        self.approvalAuthorityLbl.layer.cornerRadius = self.totalPointsLbl.frame.size.width / 2
        self.approvalAuthorityLbl.layer.borderWidth = 1.0
        self.approvalAuthorityLbl.clipsToBounds = true

        updateViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (PreFlightAssessmentManager.shared.isReset) {
            initResultsControls()
        } else{
            updateResultControls()
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.updateViews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            // do while animation
            self.updateViews()
        }, completion:{context in
            self.updateViews()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViews(){
        let itemSize = CGSize(width: self.horizontalView.collectionView.bounds.width - (self.flowLayout.minimumInteritemSpacing * 2), height: self.horizontalView.collectionView.bounds.height - (self.flowLayout.minimumLineSpacing * 2))

        // Only support single section for now.
        // Only support Horizontal scroll
        let count = self.horizontalView.collectionView?.dataSource?.collectionView(self.horizontalView.collectionView!, numberOfItemsInSection: 0)
        let canvasSize = self.horizontalView.collectionView!.bounds.size
        var contentSize = canvasSize
        let rowCount = Int((canvasSize.height - itemSize.height) / (itemSize.height + self.flowLayout.minimumInteritemSpacing) + 1)
        let columnCount = Int((canvasSize.width - itemSize.width) / (itemSize.width + self.flowLayout.minimumLineSpacing) + 1)
        let page = ceilf(Float(count!) / Float(rowCount * columnCount))
        contentSize.width = CGFloat(page) * canvasSize.width
        self.horizontalView.collectionView.contentSize = contentSize
        self.cellSize = CGSize(width: contentSize.width / CGFloat(page), height: contentSize.height)
        
        self.horizontalView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func initResultsControls() {
        
        self.selectedViewOption = ViewOption.OverallAssessment
        
        self.totalPointsLbl.text = PreFlightAssessmentManager.shared.totalPointsType.toString()
        self.totalPointsLbl.layer.backgroundColor =  PreFlightAssessmentManager.shared.totalPointsType.toColor().cgColor

        self.overallRiskLbl.text = PreFlightAssessmentManager.shared.overallAssessmentType.toString()
        self.overallRiskLbl.layer.backgroundColor =  PreFlightAssessmentManager.shared.overallAssessmentType.toColor().cgColor

        self.approvalAuthorityLbl.text = PreFlightAssessmentManager.shared.approvalAuthorityType.toString()
        self.approvalAuthorityLbl.layer.backgroundColor =  PreFlightAssessmentManager.shared.approvalAuthorityType.toColor().cgColor

        self.dateLbl.text = self.dateFormatter.string(from: Date())
        self.pilotTxtFld.text = ""
    }
    
    func updateResultControls() {
        PreFlightAssessmentManager.shared.calcResults()
        
        let tp = PreFlightAssessmentManager.shared.totalPointsType
        self.totalPointsLbl.text = tp?.toString()
        self.totalPointsLbl.layer.backgroundColor = tp?.toColor().cgColor
        
        let oa = PreFlightAssessmentManager.shared.overallAssessmentType
        self.overallRiskLbl.text = oa?.toString()
        self.overallRiskLbl.layer.backgroundColor = oa?.toColor().cgColor

        let aa = PreFlightAssessmentManager.shared.approvalAuthorityType
        self.approvalAuthorityLbl.text = aa?.toString()
        self.approvalAuthorityLbl.layer.backgroundColor = aa?.toColor().cgColor
        
        self.dateLbl.text = "fix me!"
        self.pilotTxtFld.text = "fix me!"
    }
    
    func updateViewOptionDisplay() {
        self.resultsView.isHidden = self.selectedViewOption != ViewOption.OverallAssessment
        self.horizontalView.isHidden = self.selectedViewOption != ViewOption.RiskQuestions
    }

    // MARK: action handling
    
    @IBAction func handleResetBtn() {
        let alert = UIAlertController.init(title: "Confirmation Required", message: "Are you sure you want to RESET the PreFlight Risk Assessment?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: UIAlertActionStyle.destructive, handler: { (action) in
            PreFlightAssessmentManager.shared.reset()
            self.updateResultControls()
            self.horizontalView.collectionView.reloadData()
            self.horizontalView.collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.left)
            self.horizontalView.pageControl?.currentPage = 0
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func handleDoneBtn() {
        //        let msg = PreFlightAssessmentManager.shared.riskAssessmentsToString()
        //        let alert = UIAlertController.init(title: "Pre-Flight Risk Assessment", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        //        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
        //            self.dismiss(animated: true, completion: nil)
        //        }))
        //        self.present(alert, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewOptionsSelected(_ sender: UISegmentedControl) {
        self.selectedViewOption = ViewOption.init(rawValue: sender.selectedSegmentIndex)
        updateViewOptionDisplay()
        PreFlightAssessmentManager.shared.calcResults()
        self.updateResultControls()
    }
    
    //
    @objc func riskAssessmentChoiceSelected(_ sender: RiskAssessmentChoiceSegCtl) {
        PreFlightAssessmentManager.shared.updateRiskAssessment(riskAssessmentNdx: sender.riskAssessmentNdx, selection: sender.selectedSegmentIndex)
    }
    
    // MARK: UITextFieldDelegate
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
//        let risktextField = textField as! RiskAssessmentWriteInTextField
//        PreFlightAssessmentManager.shared.updateRiskAssessment(riskAssessmentGroupNdx: risktextField.riskAssessmentNdxs.groupNdx, riskAssessmentNdx: risktextField.riskAssessmentNdxs.riskAssessmentNdx, writeInText: risktextField.text!)
    }
    
    // MARK: keyboard notif handling
    
    @objc func keyboardWasShown(_ aNotification: NSNotification) {
//        let info = aNotification.userInfo as! [String: AnyObject],
//        kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
//        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
//        self.tableView.contentInset = contentInsets
//        self.tableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
//        var aRect = self.view.frame
//        aRect.size.height -= kbSize.height
//
//        if !aRect.contains(activeField!.frame.origin) {
//            self.tableView.scrollRectToVisible(activeField!.frame, animated: true)
//        }
    }
    
    @objc func keyboardWillBeHidden(_ aNotification: NSNotification) {
//        let contentInsets = UIEdgeInsets.zero
//        self.tableView.contentInset = contentInsets
//        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cnt = PreFlightAssessmentManager.shared.riskAssessments.count
        return cnt
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RiskAssessmentCVCellIdentifier, for: indexPath) as! RiskAssessmentCVCell
        
        let riskAssessment = PreFlightAssessmentManager.shared.riskAssessments[indexPath.row];

        cell.riskAssessmentNdx = indexPath.row
        
        cell.groupIcon.image = riskAssessment.groupTitle.groupTitleIconImage()
        cell.groupLbl.text = riskAssessment.groupTitle.rawValue
        cell.titleLbl.text = riskAssessment.title
        for ndx in 0...riskAssessment.choices.count-1 {
            cell.riskChoicesSegCtl.setTitle(riskAssessment.choices[ndx], forSegmentAt: ndx)
        }
        cell.riskChoicesSegCtl.apportionsSegmentWidthsByContent = true
        cell.riskChoicesSegCtl.riskAssessmentNdx = indexPath.row
        cell.riskChoicesSegCtl.selectedSegmentIndex = riskAssessment.selection
        cell.riskChoicesSegCtl.addTarget(self, action: #selector(riskAssessmentChoiceSelected(_:)), for: .valueChanged)

        let hideWriteIn = riskAssessment.riskAssessmentType != .WriteIn
        cell.writeInLabel.isHidden = hideWriteIn
        cell.writeInTextField.isHidden = hideWriteIn
        
        cell.cardLbl.text = String(format: "%d of %d", indexPath.row + 1, PreFlightAssessmentManager.shared.riskAssessments.count)
        
        cell.layer.borderColor = UIColor.blue.cgColor
        cell.layer.borderWidth = 1.0

        return cell
    }
    
    // MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    // MARK: UITableViewDataSource
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PreFlightAssessmentManager.shared.riskAssessments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!

        let riskAssessment = PreFlightAssessmentManager.shared.riskAssessments[indexPath.row]
        
        switch riskAssessment.riskAssessmentType {
        case .Choice:
            
                let raCell = tableView.dequeueReusableCell(withIdentifier: RiskAssessmentResultsCellIdentifier) as! RiskAssessmentResultsCell
                
                raCell.titleLbl.text = riskAssessment.title
                raCell.riskLevelLbl.text = riskAssessment.choices[riskAssessment.selection]
                
                cell = raCell
            
        case .WriteIn:
            
            let rawiCell = tableView.dequeueReusableCell(withIdentifier: RiskAssessmentResultsWriteInCellIdentifier) as! RiskAssessmentResultsWriteInCell
            
            rawiCell.titleLbl.text = riskAssessment.title
            rawiCell.riskLevelLbl.text = riskAssessment.choices[riskAssessment.selection]
            rawiCell.writeInTextLbl.text = riskAssessment.writeInText
            
            cell = rawiCell
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let riskAssessment = PreFlightAssessmentManager.shared.riskAssessments[indexPath.row]

        switch riskAssessment.riskAssessmentType {
        case .Choice:
            return 60
        case .WriteIn:
            return 100
        }
        
    }
     */
    
}



