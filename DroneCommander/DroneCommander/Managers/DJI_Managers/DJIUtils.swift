//
//  DJIUtils.swift
//  DroneCommander
//
//  Created by Jerry Walton on 2/28/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//

import DJISDK
import VideoPreviewer

class DJIUtils {
    
    class func fetchAircraft() -> DJIAircraft? {
        if (DJISDKManager.product() != nil) {
            return nil
        }
        if (DJISDKManager.product()?.isKind(of: DJIAircraft.self))! {
            if let aircraft = DJISDKManager.product() as? DJIAircraft {
                return aircraft
            }
        }
        return nil
    }
    
    class func fetchCamera() -> DJICamera? {
        if let aircraft = fetchAircraft() {
            return aircraft.camera
        }
        return nil
    }
    
    class func fetchFlightController() -> DJIFlightController? {
        if let aircraft = fetchAircraft() {
            return aircraft.flightController
        }
        return nil
    }
    
    class func fetchGimbal() -> DJIGimbal? {
        if let aircraft = fetchAircraft() {
            return aircraft.gimbal
        }
        return nil
    }
    
//    + (CGPoint) pointToStreamSpace:(CGPoint)point withView:(UIView *)view
//    {
//    VideoPreviewer* previewer = [VideoPreviewer instance];
//    CGRect videoFrame = [previewer frame];
//    CGPoint videoPoint = [previewer convertPoint:point toVideoViewFromView:view];
//    CGPoint normalized = CGPointMake(videoPoint.x/videoFrame.size.width, videoPoint.y/videoFrame.size.height);
//    return normalized;
//    }
    class func pointToStreamSpace(point: CGPoint, withView view: UIView) -> CGPoint {
        let previewer = VideoPreviewer.instance()
        let videoFrame = previewer?.frame
        let videoPoint = previewer?.convert(point, toVideoViewFrom: view)
        let normalized = CGPoint(x: (videoPoint?.x)! / (videoFrame?.size.width)!,
                                 y: (videoPoint?.y)! / (videoFrame?.size.height)!)
        return normalized
    }
    
//
//    + (CGPoint) pointFromStreamSpace:(CGPoint)point{
//    VideoPreviewer* previewer = [VideoPreviewer instance];
//    CGRect videoFrame = [previewer frame];
//    CGPoint videoPoint = CGPointMake(point.x*videoFrame.size.width,
//    point.y*videoFrame.size.height);
//    return videoPoint;
//    }
    class func pointFromStreamSpace(point: CGPoint) -> CGPoint {
        let previewer = VideoPreviewer.instance()
        let videoFrame = previewer?.frame
        let videoPoint = CGPoint(x: point.x * (videoFrame?.size.width)!,
                                 y: point.y * (videoFrame?.size.height)!)
        return videoPoint
    }
    
//
//    + (CGPoint) pointFromStreamSpace:(CGPoint)point withView:(UIView *)view{
//    VideoPreviewer* previewer = [VideoPreviewer instance];
//    CGRect videoFrame = [previewer frame];
//    CGPoint videoPoint = CGPointMake(point.x*videoFrame.size.width, point.y*videoFrame.size.height);
//    return [previewer convertPoint:videoPoint fromVideoViewToView:view];
//    }
    class func pointFromStreamSpace(point: CGPoint, withView view: UIView) -> CGPoint {
        let previewer = VideoPreviewer.instance()
        let videoFrame = previewer?.frame
        let videoPoint = CGPoint(x: point.x * (videoFrame?.size.width)!,
                                 y: point.y * (videoFrame?.size.height)!)
        return (previewer?.convert(videoPoint, fromVideoViewTo:view))!
    }
    
//
//    + (CGSize) sizeToStreamSpace:(CGSize)size{
//    VideoPreviewer* previewer = [VideoPreviewer instance];
//    CGRect videoFrame = [previewer frame];
//    return CGSizeMake(size.width/videoFrame.size.width, size.height/videoFrame.size.height);
//    }
    class func sizeToStreamSpace(size: CGSize) -> CGSize {
        let previewer = VideoPreviewer.instance()
        let videoFrame = previewer?.frame
        return CGSize(width: size.width / (videoFrame?.size.width)!,
                      height: size.height / (videoFrame?.size.height)!)
    }
    
//
//    + (CGSize) sizeFromStreamSpace:(CGSize)size{
//    VideoPreviewer* previewer = [VideoPreviewer instance];
//    CGRect videoFrame = [previewer frame];
//    return CGSizeMake(size.width*videoFrame.size.width, size.height*videoFrame.size.height);
//    }
    class func sizeFromStreamSpace(size: CGSize) -> CGSize {
        let previewer = VideoPreviewer.instance()
        let videoFrame = previewer?.frame
        return CGSize(width: size.width * (videoFrame?.size.width)!,
                      height: size.height * (videoFrame?.size.height)!)
    }
    
//
//    + (CGRect) rectFromStreamSpace:(CGRect)rect
//    {
//    CGPoint origin = [DemoUtility pointFromStreamSpace:rect.origin];
//    CGSize size = [DemoUtility sizeFromStreamSpace:rect.size];
//    return CGRectMake(origin.x, origin.y, size.width, size.height);
//    }
    class func rectFromStreamSpace(rect: CGRect) -> CGRect {
        let origin = pointFromStreamSpace(point: rect.origin)
        let size = sizeFromStreamSpace(size: rect.size)
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }
    
//
//    + (CGRect) rectToStreamSpace:(CGRect)rect withView:(UIView *)view
//    {
//    CGPoint origin = [DemoUtility pointToStreamSpace:rect.origin withView:view];
//    CGSize size = [DemoUtility sizeToStreamSpace:rect.size];
//    return CGRectMake(origin.x, origin.y, size.width, size.height);
//    }
    class func rectToStreamSpace(rect: CGRect, withView view: UIView) -> CGRect {
        let origin = pointToStreamSpace(point: rect.origin, withView: view)
        let size = sizeToStreamSpace(size: rect.size)
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }
    
//
//    + (CGRect) rectFromStreamSpace:(CGRect)rect withView:(UIView *)view
//    {
//    CGPoint origin = [DemoUtility pointFromStreamSpace:rect.origin withView:view];
//    CGSize size = [DemoUtility sizeFromStreamSpace:rect.size];
//    return CGRectMake(origin.x, origin.y, size.width, size.height);
//    }
    class func rectFromStreamSpace(rect: CGRect, withView view: UIView) -> CGRect {
        let origin = pointFromStreamSpace(point: rect.origin, withView: view)
        let size = sizeFromStreamSpace(size: rect.size)
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }
    
//
//    + (CGRect) rectWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2
//    {
//    CGFloat origin_x = MIN(point1.x, point2.x);
//    CGFloat origin_y = MIN(point1.y, point2.y);
//    CGFloat width = fabs(point1.x - point2.x);
//    CGFloat height = fabs(point1.y - point2.y);
//    CGRect rect = CGRectMake(origin_x, origin_y, width, height);
//    return rect;
//    }
    class func rectWithPoint(point1: CGPoint, point2: CGPoint) -> CGRect {
        let origin_x = min(point1.x, point2.x)
        let origin_y = min(point1.y, point2.y)
        let width = fabs(point1.x - point2.x)
        let height = fabs(point1.y - point2.y)
        let rect = CGRect(x: origin_x, y: origin_y, width: width, height: height)
        return rect
    }

}

