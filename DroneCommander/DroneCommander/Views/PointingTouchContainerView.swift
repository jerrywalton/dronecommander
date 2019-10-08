//
//  PointingTouchContainerView.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/10/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//
import UIKit
import MapKit

class PointingTouchContainerView: UIView {
    
    var pointingTouchView: PointingTouchView!
    var coordsLbl: UILabel!
    var mapView: MKMapView!
    var lastTouchPoint = INVALID_POINT
    var lastTouchCooord: CLLocationCoordinate2D!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.pointingTouchView = PointingTouchView()
        self.pointingTouchView.frame = self.bounds
        self.pointingTouchView.layer.borderColor = UIColor.green.cgColor
        self.pointingTouchView.layer.borderWidth = 1.0
        self.addSubview(self.pointingTouchView)

        self.clipsToBounds = false
        let closeBtn = UIButton.init(type: UIButtonType.custom)
        closeBtn.setImage(UIImage(named: IconCloseBtn), for: UIControlState.normal)
        closeBtn.sizeToFit()
        var btnFrame = closeBtn.frame
        btnFrame.origin.y = -1 * (btnFrame.size.height / 2)
        btnFrame.origin.x = self.frame.size.width - (btnFrame.size.width / 2)
        closeBtn.frame = btnFrame
        closeBtn.addTarget(self, action: #selector(handleCloseBtn), for: UIControlEvents.touchUpInside)
        self.addSubview(closeBtn)
        
        let margin = CGFloat(20.0)
        self.coordsLbl = UILabel(frame: CGRect(x: margin, y: 0, width: self.frame.size.width - margin, height: 40))
        self.coordsLbl.textAlignment = .center
        self.coordsLbl.font = UIFont.boldSystemFont(ofSize: 14)
        self.coordsLbl.textColor = UIColor.white
        var frame = self.coordsLbl.frame
        frame.origin.y = self.frame.size.height - (frame.size.height + (margin / 2))
        self.coordsLbl.frame = frame
        self.coordsLbl.text = TextNotSelected
        self.addSubview(self.coordsLbl)
        
        initTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func handleCloseBtn() {
        toggleView()
    }
    
    class func frameForView() -> CGRect {
        return CGRect(x: 0, y: 0, width: 320, height: 320)
    }
    
    func toggleView() {
        self.isHidden = !self.isHidden
        
        if (self.isHidden) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotifCloseSetHotPointView), object: self.lastTouchCooord)
        }
    }
    
    func updateCoordsLabel() {
        self.coordsLbl.text = String(format: "Lat: %.6f Lon: %.6f", self.lastTouchCooord.latitude, self.lastTouchCooord.longitude)
    }
    
    func initTapGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(PointingTouchContainerView.onScreenTouched(recognizer:)))
        self.pointingTouchView.addGestureRecognizer(tapGesture)
    }
    
    @objc func onScreenTouched(recognizer: UIGestureRecognizer) {
        let point = recognizer.location(in: self.pointingTouchView)
        self.pointingTouchView.updatePoint(point: point, color: UIColor.green.withAlphaComponent(0.5))
        self.lastTouchPoint = DJIUtils.pointToStreamSpace(point: point, withView: self.pointingTouchView)
        if (self.mapView != nil) {
            self.lastTouchCooord = self.mapView.convert(self.lastTouchPoint, toCoordinateFrom: self.pointingTouchView)
            
            updateCoordsLabel()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotifPointingTouchViewCoordOfLastTouch), object: self.lastTouchCooord)

        }
    }

}
