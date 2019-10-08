//
//  VideoPreviewerManager.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/3/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import Foundation
import DJISDK
import VideoPreviewer

class VideoPreviewerManager : NSObject, DJIVideoFeedListener {
    
    // singleton access
    static let shared = VideoPreviewerManager()
    
    // private initialization
    private override init() {
        super.init()
    }
    
    func setup(fpvView: UIView) {
//        [[VideoPreviewer instance] setView:self.fpvView];
//        [[DJISDKManager videoFeeder].primaryVideoFeed addListener:self withQueue:nil];
//        [[VideoPreviewer instance] start];
        VideoPreviewer.instance().setView(fpvView)
        DJISDKManager.videoFeeder()?.primaryVideoFeed.add(self, with: nil)
        VideoPreviewer.instance().start()
    }
    
    func tearDown() {
        // from DJI example app, productDisconnected method
        VideoPreviewer.instance().unSetView()
        DJISDKManager.videoFeeder()?.primaryVideoFeed.remove(self)
        // from DJI example app, viewWillDisAppear method
//        VideoPreviewer.instance().clearVideoData()
//        VideoPreviewer.instance().close()
    }
    
    // MARK: DJIVideoFeedListener
    
    func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData videoData: Data) {

        // Objective-c
        //[[VideoPreviewer instance] push:(uint8_t *)videoData.bytes length:(int)videoData.length];
        
        // Swift
        let nsVideoData = videoData as NSData
        
        let videoBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: nsVideoData.length)
        
        nsVideoData.getBytes(videoBuffer, length: nsVideoData.length)
        
        VideoPreviewer.instance().push(videoBuffer, length: Int32(nsVideoData.length))
        
    }

}
