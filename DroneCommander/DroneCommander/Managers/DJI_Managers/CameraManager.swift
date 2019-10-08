//
//  CameraManager.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/1/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import DJISDK

class CameraManager: BaseDJIProductListener, DJICameraDelegate {
    
    // singleton access
    static let shared = CameraManager()
    
    // private initialization
    private override init() {
        super.init()
        
        reset()
    }
    
    func reset() {
        if let camera = DJIUtils.fetchCamera() {
            camera.delegate = self
        }
    }
    
    // called when communication to DJI product has changed
    override func productCommunicationDidChange() {
        reset()
    }
    
    // MARK: DJICameraDelegate
    
    /**
     *  Called when the camera's current state has been updated.
     *
     *  @param camera Camera that updates the current state.
     *  @param systemState The camera's system state.
     */
    func camera(_ camera: DJICamera, didUpdate systemState: DJICameraSystemState) {
    }
    
    /**
     *  Called when the camera's lens and focus state has been updated. This delegate
     *  method is only available when `isInterchangeableLensSupported` is `YES`.
     *
     *  @param camera Camera that sends out the updatd lens information.
     *  @param lensState The camera's lens and focus state.
     */
    func camera(_ camera: DJICamera, didUpdate lensState: DJICameraFocusState) {
    }
    
    /**
     *  Called when a new media file (photo or video) has been generated.
     *   In this delegate method, the `DJIMediaFile` instance properties `thumbnail`,
     *  `durationInSeconds` and `videoOrientation` require special consideration. The
     *  `thumbnail` property normally has a pointer to a UIImage of the thumbnail, but
     *  this is only available when the camera is in `DJICameraModeMediaDownload` work
     *  mode. Additionally, for this instance of `DJIMediaFile`, the `durationInSeconds`
     *  property is 0 and the `videoOrientation` property is
     *  `DJICameraOrientationLandscape`.
     *
     *  @param camera Camera that generates the new media file.
     *  @param newMedia The new media file.
     */
    func camera(_ camera: DJICamera, didGenerateNewMediaFile newMedia: DJIMediaFile) {
    }
    
    /**
     *  Called when the camera's SD card state has been updated.
     *
     *  @param camera Camera that sends out the updated SD card state.
     *  @param sdCardState The camera's SD card state.
     */
    func camera(_ camera: DJICamera, didUpdate sdCardState: DJICameraSDCardState) {
    }
    
    /**
     *  Called when the camera's SSD state has been updated. This method is available
     *  only when `isSSDSupported` is `YES`.
     *
     *  @param camera Camera that sends out the updated SSD state.
     *  @param ssdState The camera's SSD state.
     */
    func camera(_ camera: DJICamera, didUpdate ssdState: DJICameraSSDState) {
    }
    
    /**
     *  Called whenever the camera parameters change. In automatic exposure modes
     *  (Program, Shutter Priority and Aperture Priority) the camera may be
     *  automatically changing aperture, shutter speed and ISO (depending on the mode
     *  and camera) when lighting conditions change. In Manual mode, the exposure
     *  compensation is automatically updated to let the user know how much compensation
     *  the exposure needs to get to an exposure the camera calculates as correct.
     *
     *  @param camera Camera that sends out the video data.
     *  @param settings The updated real values for parameters.
     */
    //- (void)camera:(DJICamera *_Nonnull)camera didUpdateExposureSettings:(DJICameraExposureSettings)settings;
    func camera(_ camera: DJICamera, didUpdate settings: DJICameraExposureSettings) {
    }
    
}
