//
//  HotPointMissionVC_old.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/3/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import DJISDK
import DJIUILibrary


let TextFieldCellIdentifier = "TextFieldCell"
class TextFieldCell : UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
}
let TextFieldUnitsCellIdentifier = "TextFieldUnitsCell"
class TextFieldUnitsCell : UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var unitsLbl: UILabel!
}
let ComboTextFieldUnitsCellIdentifier = "ComboTextFieldUnitsCell"
class ComboTextFieldUnitsCell : UITableViewCell {
    @IBOutlet weak var titleLbl1: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var unitsLbl1: UILabel!
    @IBOutlet weak var titleLbl2: UILabel!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var unitsLbl2: UILabel!
}

class HotPointMissionVC_old: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var minimizeBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!

    weak var altitudeTxtfld: UITextField!
    weak var angularVelocityTxtFld: UITextField!
    weak var headingTxtFld: UITextField!
    weak var hotPointTxtFld: UITextField!
    weak var radiusTxtFld: UITextField!
    weak var startPointTxtFld: UITextField!
    var hotPointCoord: CLLocationCoordinate2D!
    var doneToolbar: UIToolbar!
    var currentTextField: UITextField!
    var currentIndexPath: IndexPath!
    
    let numberOfRows = 5
    
    enum ParamCellType: Int {
        case hotPoint           //mission.hotpoint = hotPoint: CLLocationCoordinate2D
        case altitude           //mission.altitude = altitude: Float
        case angularVelocity    //mission.angularVelocity = angularVelocity: Float
        case heading            //mission.heading = heading: HotPointHeading
        case radius             //mission.radius = radius: Float
        case startPoint         //mission.startPoint = startPoint: HotpointStartPoint
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.layer.borderColor = UIColor.lightGray.cgColor
        self.view.layer.borderWidth = 2.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifPointingTouchViewCoordOfLastTouch(notif:)), name: NSNotification.Name(rawValue: NotifPointingTouchViewCoordOfLastTouch), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifCloseSetHotPointView(notif:)), name: NSNotification.Name(rawValue: NotifCloseSetHotPointView), object: nil)
        
        
        initDoneButtonAboveKeyboard()   // init the toolbar with done button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        var textFieldCell: TextFieldCell!
        var textFieldUnitsCell: TextFieldUnitsCell!
        var comboTextFieldUnitsCell: ComboTextFieldUnitsCell!
        
        switch indexPath.row {
        case 0:
            textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCellIdentifier, for: indexPath) as! TextFieldCell
            textFieldCell.titleLbl.text = "Hot Point"
            self.hotPointTxtFld = textFieldCell.textField
            self.hotPointTxtFld.delegate = self
            cell = textFieldCell
            break
        case 1:
            comboTextFieldUnitsCell = tableView.dequeueReusableCell(withIdentifier: ComboTextFieldUnitsCellIdentifier) as! ComboTextFieldUnitsCell
            
            comboTextFieldUnitsCell.titleLbl1.text = "Altitude"
            comboTextFieldUnitsCell.unitsLbl1.text = "m"
            self.altitudeTxtfld = comboTextFieldUnitsCell.textField1
            self.altitudeTxtfld.delegate = self
            self.altitudeTxtfld.inputAccessoryView = self.doneToolbar
            
            comboTextFieldUnitsCell.titleLbl2.text = "Radius"
            comboTextFieldUnitsCell.unitsLbl2.text = "m"
            self.radiusTxtFld = comboTextFieldUnitsCell.textField2
            self.radiusTxtFld.delegate = self
            self.radiusTxtFld.inputAccessoryView = self.doneToolbar

            cell = comboTextFieldUnitsCell
            break
        case 2:
            textFieldUnitsCell = tableView.dequeueReusableCell(withIdentifier: TextFieldUnitsCellIdentifier) as! TextFieldUnitsCell
            textFieldUnitsCell.titleLbl.text = "Ang. Velocity"
            textFieldUnitsCell.unitsLbl.text = "deg/s"
            self.angularVelocityTxtFld = textFieldUnitsCell.textField
            self.angularVelocityTxtFld.delegate = self
            cell = textFieldUnitsCell
            self.angularVelocityTxtFld.inputAccessoryView = self.doneToolbar
            break
        case 3:
            textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCellIdentifier, for: indexPath) as! TextFieldCell
            textFieldCell.titleLbl.text = "Heading"
            self.headingTxtFld = textFieldCell.textField
            self.headingTxtFld.delegate = self
            cell = textFieldCell
            break
        case 4:
            textFieldUnitsCell = tableView.dequeueReusableCell(withIdentifier: TextFieldUnitsCellIdentifier) as! TextFieldUnitsCell
            textFieldUnitsCell.titleLbl.text = "Radius"
            textFieldUnitsCell.unitsLbl.text = "m"
            self.radiusTxtFld = textFieldUnitsCell.textField
            self.radiusTxtFld.delegate = self
            cell = textFieldUnitsCell
            self.radiusTxtFld.inputAccessoryView = self.doneToolbar
            break
        case 5:
            textFieldCell = tableView.dequeueReusableCell(withIdentifier: TextFieldCellIdentifier) as! TextFieldCell
            textFieldCell.titleLbl.text = "Start Point"
            self.startPointTxtFld = textFieldCell.textField
            self.startPointTxtFld.delegate = self
            cell = textFieldCell
            break
        default:
            break
        }
    
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHt = CGFloat(44.0)
        switch indexPath.row {
        case 1:
            rowHt = CGFloat(88.0)
            break
        default:
            break
        }
        return rowHt
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.isEqual(self.hotPointTxtFld)) {
            textField.resignFirstResponder()
            self.radiusTxtFld.becomeFirstResponder()
        } else if (textField.isEqual(self.altitudeTxtfld)) {
            textField.resignFirstResponder()
            self.angularVelocityTxtFld.becomeFirstResponder()
            return false
        } else if (textField.isEqual(self.angularVelocityTxtFld)) {
            textField.resignFirstResponder()
            self.headingTxtFld.becomeFirstResponder()
            return false
        } else if (textField.isEqual(self.headingTxtFld)) {
            textField.resignFirstResponder()
            self.hotPointTxtFld.becomeFirstResponder()
            return false
        } else if (textField.isEqual(self.radiusTxtFld)) {
            textField.resignFirstResponder()
            self.startPointTxtFld.becomeFirstResponder()
            return false
        } else if (textField.isEqual(self.startPointTxtFld)) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.currentTextField = textField

        if (textField.isEqual(self.hotPointTxtFld)) {
            // show set hot point view
            textField.resignFirstResponder()
            showSetHotPointView()
        } else if (textField.isEqual(self.altitudeTxtfld)) {
            moveViewToTop()
            
            textField.resignFirstResponder()
            
            showNumberInputAlert(title: "Altitude", message: "Enter altitude in meters.", placeHolder: "Altitude meters", receivingTextField: self.altitudeTxtfld)
        } else if (textField.isEqual(self.angularVelocityTxtFld)) {
            moveViewToTop()
        } else if (textField.isEqual(self.headingTxtFld)) {
            // show heading picker
            textField.resignFirstResponder()
            showHeadingPicker()
        } else if (textField.isEqual(self.radiusTxtFld)) {
            moveViewToTop()
        } else if (textField.isEqual(self.startPointTxtFld)) {
            // show start point picker
            textField.resignFirstResponder()
            showStartPointPicker()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to:self.tableview)
        var contentOffset:CGPoint = self.tableview.contentOffset
        contentOffset.y = pointInTable.y
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        self.tableview.contentOffset = contentOffset
        
        if (textField.superview?.superview?.isKind(of:UITableViewCell.self))! {
            let buttonPosition = textField.convert(CGPoint(x: 0, y: 0), to: self.tableview)
            self.currentIndexPath = self.tableview.indexPathForRow(at: buttonPosition)
        }
        
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.superview?.superview?.isKind(of:UITableViewCell.self))! {
//            let buttonPosition = textField.convert(CGPoint(x: 0, y: 0), to: self.tableview)
//            let indexPath = self.tableview.indexPathForRow(at: buttonPosition)
//            self.tableview.scrollToRow(at: indexPath!, at: UITableViewScrollPosition.middle, animated: true)
            self.tableview.scrollToRow(at: self.currentIndexPath, at: UITableViewScrollPosition.top, animated: true)
        }
        return true
    }
    
    func showSetHotPointView() {
        toggleMinimize()
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotifShowSetHotPointView), object: nil)
    }
    
    func showHeadingPicker() {
        let alert = UIAlertController.init(title: "Heading", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: HotPointHeading.HotpointHeadingControlledByRemoteController.toString(), style: .default, handler: { [weak self] (action) in
            self?.setHeading(heading: HotPointHeading.HotpointHeadingControlledByRemoteController)
        }))
        alert.addAction(UIAlertAction.init(title: HotPointHeading.HotpointHeadingAlongCircleLookingForward.toString(), style: .default, handler: { [weak self] (action) in
            self?.setHeading(heading: HotPointHeading.HotpointHeadingAlongCircleLookingForward)
    }))
        alert.addAction(UIAlertAction.init(title: HotPointHeading.HotpointHeadingAlongCircleLookingBackward.toString(), style: .default, handler: { [weak self] (action) in
    self?.setHeading(heading: HotPointHeading.HotpointHeadingAlongCircleLookingBackward)
    }))
        alert.addAction(UIAlertAction.init(title: HotPointHeading.HotpointHeadingAwayFromHotpoint.toString(), style: .default, handler: { [weak self] (action) in
    self?.setHeading(heading: HotPointHeading.HotpointHeadingAwayFromHotpoint)
    }))
        alert.addAction(UIAlertAction.init(title: HotPointHeading.HotpointHeadingTowardHotpoint.toString(), style: .default, handler: { [weak self] (action) in
    self?.setHeading(heading: HotPointHeading.HotpointHeadingTowardHotpoint)
    }))
        alert.addAction(UIAlertAction.init(title: HotPointHeading.HotpointHeadingUsingInitialHeading.toString(), style: .default, handler: { [weak self] (action) in
    self?.setHeading(heading: HotPointHeading.HotpointHeadingUsingInitialHeading)
    }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showStartPointPicker() {
        let alert = UIAlertController.init(title: "Start Point", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: HotpointStartPoint.HotpointStartPointNearest.toString(), style: .default, handler: { [weak self] (action) in
            self?.setStartPoint(startPoint: HotpointStartPoint.HotpointStartPointNearest)
        }))
        alert.addAction(UIAlertAction.init(title: HotpointStartPoint.HotpointStartPointEast.toString(), style: .default, handler: { [weak self] (action) in
            self?.setStartPoint(startPoint: HotpointStartPoint.HotpointStartPointEast)
        }))
        alert.addAction(UIAlertAction.init(title: HotpointStartPoint.HotpointStartPointNorth.toString(), style: .default, handler: { [weak self] (action) in
            self?.setStartPoint(startPoint: HotpointStartPoint.HotpointStartPointNorth)
        }))
        alert.addAction(UIAlertAction.init(title: HotpointStartPoint.HotpointStartPointSouth.toString(), style: .default, handler: { [weak self] (action) in
            self?.setStartPoint(startPoint: HotpointStartPoint.HotpointStartPointSouth)
        }))
        alert.addAction(UIAlertAction.init(title: HotpointStartPoint.HotpointStartPointWest.toString(), style: .default, handler: { [weak self] (action) in
            self?.setStartPoint(startPoint: HotpointStartPoint.HotpointStartPointWest)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setHeading(heading: HotPointHeading) {
        self.headingTxtFld.text = heading.toString()
        self.headingTxtFld.resignFirstResponder()
        self.radiusTxtFld.becomeFirstResponder()
    }
    
    func setStartPoint(startPoint: HotpointStartPoint) {
        self.startPointTxtFld.text = startPoint.toString()
        self.startPointTxtFld.resignFirstResponder()
    }
    
    @IBAction func handleCloseBtn() {
        
        let alert = UIAlertController.init(title: "Confirmation", message: "Are you sure you want to close the Hot Point Mission view?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { (action) in
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotifCloseHotPointMissionView), object: nil)

        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: { (action) in
        }))

        self.present(alert, animated: true, completion: nil)
    }

    @objc func handleNotifPointingTouchViewCoordOfLastTouch(notif: NSNotification) {
        
        let coord = notif.object as! CLLocationCoordinate2D
        print("coord lat: \(coord.latitude) lon: \(coord.longitude)")
        
    }
    
    @objc func handleNotifCloseSetHotPointView(notif: NSNotification) {
        
        self.hotPointCoord = notif.object as! CLLocationCoordinate2D

        self.hotPointTxtFld.text = String(format: "%3.5f %3.5f", self.hotPointCoord.latitude, self.hotPointCoord.longitude)
        
        self.altitudeTxtfld.becomeFirstResponder()

        self.toggleMinimize()
        
    }

    @IBAction func toggleMinimize() {

        let minHt = CGFloat(88.0)
        let maxHt = CGFloat(320.0)
        var imageName: String!
        var height: CGFloat
        var origin_y: CGFloat
        var animDuration: TimeInterval
        
        var frame = self.view.frame
        if (frame.size.height < maxHt) {
            height = maxHt
            imageName = IconMinimizeView
            origin_y = ((view.superview?.frame.size.height)! - height) / 2
            animDuration = 0.75
        } else{
            height = minHt
            imageName = IconMaximizeView
            origin_y = (view.superview?.frame.size.height)! - height
            animDuration = 0.5
        }
        
        frame.size.height = height
        frame.origin.x = ((view.superview?.frame.size.width)! - frame.size.width) / 2
        frame.origin.y = origin_y

        UIView.animate(withDuration: animDuration) {
            self.view.frame = frame
        }
        self.minimizeBtn.setImage(UIImage(named: imageName), for: .normal)

    }
    
    func moveViewToTop() {
        var frame = self.view.frame
        frame.origin.x = ((view.superview?.frame.size.width)! - frame.size.width) / 2
        frame.origin.y = 0.0
        
        UIView.animate(withDuration: 0.5) {
            self.view.frame = frame
        }
    }
    
    func initDoneButtonAboveKeyboard()
    {
        self.doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        self.doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        self.doneToolbar.items = items
        self.doneToolbar.sizeToFit()
    }
    
    @objc func doneButtonAction()
    {
        if (self.currentTextField != nil) {
            self.currentTextField.resignFirstResponder()
        }
    }
    
    func showNumberInputAlert(title: String, message: String, placeHolder: String, receivingTextField: UITextField) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)

        // add textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .numberPad
            textField.autocorrectionType = .no
            textField.placeholder = placeHolder
            textField.clearButtonMode = .whileEditing
        }
        
        // add Submit button
        weak var weakReceivingTextField = receivingTextField
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // populate the receiving text field with the entered value
            let textField = alert.textFields![0]
            weakReceivingTextField?.text = textField.text
        })
        
        // add Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // add action buttons and present the alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
}


