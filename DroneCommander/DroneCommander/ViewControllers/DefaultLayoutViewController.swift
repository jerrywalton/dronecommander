//
//  DefaultLayoutViewController.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/3/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import UIKit
import DJISDK
import DJIUILibrary
import VideoPreviewer
import UIView_draggable

//class DefaultLayoutViewController: DULDefaultLayoutViewController, DJISDKManagerDelegate, DJIGimbalDelegate, DJIFlightControllerDelegate {
class DefaultLayoutViewController: DULDefaultLayoutViewController, DJIGimbalDelegate, DJIFlightControllerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var pointingTouchView: PointingTouchContainerView!
    var hotPointMissionVC: HotPointMissionVC! = nil
    
//    @IBOutlet var headingLabel: UILabel!
//    @IBOutlet var latitudeLabel: UILabel!
//    @IBOutlet var longitudeLabel: UILabel!
//    @IBOutlet var gimbalAttitudeLabel: UILabel!

//    let degreeSymbol = "º"      // the degree symbol
    var drone: DJIAircraft?
    var gimbalState: DJIGimbalState?
    var flightControllerState: DJIFlightControllerState?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(productCommunicationDidChange), name: Notification.Name(rawValue: ProductCommunicationManagerStateDidChange), object: nil)

        //DJISDKManager.registerApp(with: self)
        
        setInitialDisplay()

        NotificationCenter.default.addObserver(self, selector: #selector(showPreFlightRiskAssessmentView), name: NSNotification.Name(rawValue: NotitPreFlightRiskAssessmentView), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showShotSheetView), name: NSNotification.Name(rawValue: NotifShowShotSheetView), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showHotPointMissionView), name: NSNotification.Name(rawValue: NotifShowSetHotPointView), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showHotPointMissionView), name: NSNotification.Name(rawValue: NotifShowHotPointMissionView), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifCloseHotPointMissionViewController), name: NSNotification.Name(rawValue: NotifCloseHotPointMissionView), object: nil)

        //FlightControllerManager.shared      // init the flight controller listener
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initSetHotPointView() {
        self.pointingTouchView = PointingTouchContainerView.init(frame: PointingTouchContainerView.frameForView())
        self.view.addSubview(self.pointingTouchView)
        
        let dulMapView = self.previewViewController as? DULMapViewController
        if (dulMapView != nil) {
            self.pointingTouchView.mapView = dulMapView?.mapWidget.mapView
        }
    }

    func initHotPointMissionView() {
        self.hotPointMissionVC = self.storyboard?.instantiateViewController(withIdentifier: "HotPointMissionVC") as? HotPointMissionVC
        let dim = CGFloat(320.0)
        let frame = self.view.frame
        self.hotPointMissionVC?.view.frame = CGRect(x: (frame.size.width - dim) / 2, y: (frame.size.height - dim) / 2, width: dim, height: dim)
        self.hotPointMissionVC?.view.enableDragging()
        self.addChildViewController(self.hotPointMissionVC!)
        self.view.addSubview((self.hotPointMissionVC?.view)!)
        self.hotPointMissionVC?.didMove(toParentViewController: self)
    }
    
    @objc func handleNotifShowSetHotPointView() {
        initSetHotPointView()
    }
    
    @objc func handleNotifCloseHotPointMissionViewController() {
        if (self.hotPointMissionVC != nil) {
            self.hotPointMissionVC.view.removeFromSuperview()
            self.hotPointMissionVC.removeFromParentViewController()
            self.hotPointMissionVC = nil
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        if (self.pointingTouchView != nil && self.pointingTouchView.superview != nil) {
            self.pointingTouchView.center = self.view.center
        }
    }
    
    /*
    // DJISDKManagerDelegate Methods
    func productConnected(_ product: DJIBaseProduct?) {
        
        NSLog("Product Connected")
        
        //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
        DJISDKManager.userAccountManager().logIntoDJIUserAccount(withAuthorizationRequired: false) { (state, error) in
            if(error != nil){
                NSLog("Login failed: %@" + String(describing: error))
            }
        }
        
        //showAlertViewWithTitle(title: "Product connected", withMessage: String(format: "Product: %@", product!))
        
        setupConnectedProduct(product: product!)
        
    }
    
    func productDisconnected() {
        
        NSLog("Product Disconnected")
        
        setInitialDisplay()
        
    }
    
    func appRegisteredWithError(_ error: Error?) {
        
        var message = "Register App Successed!"
        if (error != nil) {
            message = "Register app failed! Please enter your app key and check the network."
        } else {
            DJISDKManager.startConnectionToProduct()
        }
        
        self.showAlertViewWithTitle(title:"Register App", withMessage: message)
    }
     */
    
    @objc func productCommunicationDidChange() {
        
        //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
        DJISDKManager.userAccountManager().logIntoDJIUserAccount(withAuthorizationRequired: false) { (state, error) in
            if(error != nil){
                NSLog("Login failed: %@" + String(describing: error))
            }
        }
        
        if self.appDelegate.productCommManager.registered {
//            self.registered.text = "YES"
//            self.register.isHidden = true
        } else {
//            self.registered.text = "NO"
//            self.register.isHidden = false
        }
        
        if self.appDelegate.productCommManager.connected {
//            self.connected.text = "YES"
//            self.connect.isHidden = true
        } else {
//            self.connected.text = "NO"
//            self.connect.isHidden = false
        }
    }
    
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    // DJIGimbalDelegate Methods
    
    /**
     *  Updates the gimbal's current state.
     *
     *  @param gimbal The gimbal object.
     *  @param state The gimbal state.
     */
    func gimbal(_ gimbal: DJIGimbal, didUpdate state: DJIGimbalState) {
        self.gimbalState = state;
        
        DispatchQueue.main.async { [weak self] in
            // update some UI
            self?.updateGimbalAttitudeDisplay()
        }
        
    }
    
    // DJIFlightControllerDelegate Methods
    
    /**
     *  Called when the flight controller's current state data has been updated. This
     *  method is called 10 times per second.
     *
     *  @param fc Instance of the flight controller for which the data will be updated.
     *  @param state Current state of the flight controller.
     */
    func flightController(_ fc: DJIFlightController, didUpdate state: DJIFlightControllerState) {
        
        self.flightControllerState = state;
        
        DispatchQueue.main.async { [weak self] in
            // update some UI
            self?.updateDroneAttitudeDisplay()
        }

        //showAlertViewWithTitle(title: "FlightController", withMessage: String(format: "%@", state))
    }
    
    
    func setupConnectedProduct(product: DJIBaseProduct) {
        if (product is DJIAircraft) {
            self.drone = product as? DJIAircraft
            //showAlertViewWithTitle(title: "DJIAircraft", withMessage: String(format: "%@", self.drone!))
            
            let gimbals: [DJIGimbal]! = drone?.gimbals
            if (gimbals != nil && gimbals.count > 0) {
                //showAlertViewWithTitle(title: "Gimbals", withMessage: String(format: "count: %d gimbals: %@", gimbals.count, gimbals))
                
                // become the gimbal delegate
                gimbals.first?.delegate = self
            }
            
            // become the flight controller delegate
            self.drone?.flightController?.delegate = self
        }
    }
    
    func setInitialDisplay() {
        // set initial display values to zeros
//        self.headingLabel.text = "-" + degreeSymbol
//        self.latitudeLabel.text = "--.------"
//        self.longitudeLabel.text = "--.------"
//        self.gimbalAttitudeLabel.text = "-" + degreeSymbol

        customizeLayout()
        
    }

    func customizeLayout() {
//        self.dockViewController?.dockView?.addWidget(AircraftHeadingWidget())
//        self.dockViewController?.dockView?.addWidget(AircraftCoordinatesWidget())
//        self.dockViewController?.dockView?.addWidget(GimbalAttitudeWidget())
        self.leadingViewController?.sideBarView?.addWidget(PreFlightRiskAssessmentWidget())
        
        self.leadingViewController?.sideBarView?.addWidget(ShotSheetWidget())
        self.leadingViewController?.sideBarView?.addWidget(HotPointMissionWidget())
    }
    
    func updateGimbalAttitudeDisplay() {
        
//        let gimbalStateStr = String(format: "%0.0f%@", (self.gimbalState?.attitudeInDegrees.pitch)!, degreeSymbol)
        
//        self.gimbalAttitudeLabel.text = gimbalStateStr
        
        //showAlertViewWithTitle(title: "Gimbal state", withMessage: gimbalStateStr)
    }

    func updateDroneAttitudeDisplay() {
        if (self.drone?.flightController?.compass != nil) {
            /*
                Represents the heading, in degrees.
                True North is 0 degrees, positive heading is East of North, and negative heading is West of North.
                Heading bounds are [-180, 180].
             */
            var heading = self.drone?.flightController?.compass?.heading
            if (heading! < Double(0)) {
                heading! = heading! + 360
            }
//            self.headingLabel.text = String(format: "%2.6f", heading!)
        }
        
        if ((self.flightControllerState?.aircraftLocation) != nil) {
//            let lat = self.flightControllerState?.aircraftLocation?.coordinate.latitude
//            let lon = self.flightControllerState?.aircraftLocation?.coordinate.longitude
//            self.latitudeLabel.text = String(format: "%2.6f", lat!)
//            self.longitudeLabel.text = String(format: "%2.6f", lon!)
        }
    }
    
    @objc func showPreFlightRiskAssessmentView() {
        self.performSegue(withIdentifier: SeguePreFlightRiskAssessmentView, sender: nil)
    }
    
    @objc func showShotSheetView() {
        self.performSegue(withIdentifier: SegueShotSheetView, sender: nil)
    }
    
    @objc func showHotPointMissionView() {
        if (self.hotPointMissionVC == nil) {
            initHotPointMissionView()
        }
    }
    
}

