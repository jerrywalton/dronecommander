//
//  HotPointMissionVC.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/21/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import MapKit

class HotPointMissionVC: UIViewController {
    
    @IBOutlet weak var minimizeBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!

    @IBOutlet weak var altitudeBtn: UIButton!
    @IBOutlet weak var velocityBtn: UIButton!
    @IBOutlet weak var headingBtn: UIButton!
    @IBOutlet weak var hotPointBtn: UIButton!
    @IBOutlet weak var radiusBtn: UIButton!
    @IBOutlet weak var startPointBtn: UIButton!
    var hotPointCoord: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initForm()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifPointingTouchViewCoordOfLastTouch(notif:)), name: NSNotification.Name(rawValue: NotifPointingTouchViewCoordOfLastTouch), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifCloseSetHotPointView(notif:)), name: NSNotification.Name(rawValue: NotifCloseSetHotPointView), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initForm() {
        self.view.layer.borderColor = UIColor.lightGray.cgColor
        self.view.layer.borderWidth = 2.0
        
        self.styleButton(button: self.altitudeBtn)
        self.styleButton(button: self.velocityBtn)
        self.styleButton(button: self.headingBtn)
        self.hotPointBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.styleButton(button: self.hotPointBtn)
        self.styleButton(button: self.radiusBtn)
        self.startPointBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.styleButton(button: self.startPointBtn)
        
        resetForm()
    }
    
    func styleButton(button: UIButton) {
        button.layer.borderColor = self.altitudeBtn.titleLabel?.textColor.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 11.0
    }

    @IBAction func handleAltitudeBtn() {
        self.showNumberInputAlert(title: "Altitude", message: "Enter altitude in meters.", placeHolder: "Altitude (meters)", receivingButton: self.altitudeBtn)
    }
    @IBAction func handleVelocityBtn() {
        self.showNumberInputAlert(title: "Velocity", message: "Enter angular velocity in degrees/second.", placeHolder: "Angluar Velocity (deg/s)", receivingButton: self.velocityBtn)
    }
    @IBAction func handleHeadingBtn() {
        self.showHeadingPicker()
    }
    @IBAction func handleHotPointBtn() {
        self.showSetHotPointView()
    }
    @IBAction func handleRadiusBtn() {
        self.showNumberInputAlert(title: "Radius", message: "Enter radius in meters.", placeHolder: "Radius (meters)", receivingButton: self.radiusBtn)
    }
    @IBAction func handleStartPointBtn() {
        self.showStartPointPicker()
    }
    
    @IBAction func handleResetBtn() {
        
        let alert = UIAlertController.init(title: "Confirmation", message: "Are you sure you want to RESET the Hot Point Mission view? (This cannot be undone)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { [weak self] (action) in

            self?.resetForm()
            
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: { (action) in
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func resetForm() {
        self.altitudeBtn.setTitle(TextNotSelected, for: .normal)
        self.velocityBtn.setTitle(TextNotSelected, for: .normal)
        self.headingBtn.setTitle(TextNotSelected, for: .normal)
        self.hotPointBtn.setTitle(TextNotSelected, for: .normal)
        self.radiusBtn.setTitle(TextNotSelected, for: .normal)
        self.startPointBtn.setTitle(TextNotSelected, for: .normal)
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
        self.headingBtn.setTitle(heading.toString(), for: .normal)
    }
    
    func setStartPoint(startPoint: HotpointStartPoint) {
        self.startPointBtn.setTitle(startPoint.toString(), for: .normal)
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
        let title = String(format: "%3.5f, %3.5f", self.hotPointCoord.latitude, self.hotPointCoord.longitude)
        self.hotPointBtn.setTitle(title, for: .normal)
        self.toggleMinimize()
        
    }
    
    @IBAction func toggleMinimize() {
        
        let minHt = CGFloat(88.0)
        let maxHt = CGFloat(260.0)
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
    
    func showNumberInputAlert(title: String, message: String, placeHolder: String, receivingButton: UIButton) {
        
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
        //weak var weakReceivingButton = receivingButton
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { [weak weakReceivingButton = receivingButton] (action) -> Void in
            // populate the receiving text field with the entered value
            let textField = alert.textFields![0]
            weakReceivingButton?.setTitle(textField.text, for: .normal)
        })
        
        // add Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // add action buttons and present the alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    


    

}

