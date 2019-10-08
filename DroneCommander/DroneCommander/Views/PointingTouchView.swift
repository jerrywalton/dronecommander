//
//  PointingTouchView.swift
//  DroneCommander
//
//  Created by Jerry Walton on 3/7/18.
//  Copyright © 2018 Symbolic Languages. All rights reserved.
//
import UIKit

//
// ported to Swift from Objective-C,
// by yours truly: Jerry Walton
// on 3/7/18
//

//
//  PointingTouchView.m
//  P4MissionsDemo
//
//  Created by DJI on 16/2/23.
//  Copyright © 2016年 DJI. All rights reserved.
//

//#import "PointingTouchView.h"
//#import "DemoUtility.h"

//@interface PointingTouchView ()
//
//@property(nonatomic, assign) CGPoint point;
//@property(nonatomic, strong) UIColor* fillColor;
//
//@end

//@implementation PointingTouchView
class PointingTouchView: UIView {

//    let INVALID_POINT = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.leastNormalMagnitude)
    var point = CGPoint()
    var fillColor = UIColor.green //.withAlphaComponent(0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.point = INVALID_POINT
        self.fillColor = UIColor.green //.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//-(void) awakeFromNib
//{
//    [super awakeFromNib];
//
//    self.point = INVALID_POINT;
//    self.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
//}
    override func awakeFromNib() {
        self.point = INVALID_POINT
        self.fillColor = UIColor.green //.withAlphaComponent(0.5)
    }
    
//-(void) updatePoint:(CGPoint)point
//{
//    if (CGPointEqualToPoint(self.point, point)) {
//        return;
//    }
//
//    self.point = point;
//    [self setNeedsDisplay];
//}
    func updatePoint(point: CGPoint) {
        if (self.point.equalTo(point)) {
            return
        }
        
        self.point = point
        self.setNeedsDisplay()
    }

//-(void) updatePoint:(CGPoint)point andColor:(UIColor*)color
//{
//    if (CGPointEqualToPoint(self.point, point) && [self.fillColor isEqual:color]) {
//        return;
//    }
//
//    self.point = point;
//    self.fillColor = color;
//    [self setNeedsDisplay];
//}
    func updatePoint(point: CGPoint, color: UIColor) {
        if (self.point.equalTo(point) && self.fillColor.isEqual(color)) {
            return
        }

        self.point = point
        self.fillColor = color
        self.setNeedsDisplay()
    }

//-(void) drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    if (!CGPointEqualToPoint(self.point, INVALID_POINT)) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        UIColor* strokeColor = [UIColor grayColor];
//        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
//        UIColor* fillColor = self.fillColor;
//        CGContextSetFillColorWithColor(context, fillColor.CGColor); // Fill Color
//        CGContextSetLineWidth(context, 2.5);// Line width
//        CGContextAddArc(context, self.point.x, self.point.y, 40, 0, 2*M_PI, 0); // Draw a circle with radius 40
//        CGContextDrawPath(context, kCGPathFillStroke);
//    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if (!self.point.equalTo(INVALID_POINT)) {
            let context = UIGraphicsGetCurrentContext()
            let strokeColor = UIColor.green
            context?.setStrokeColor(strokeColor.cgColor)
            let fillColor = self.fillColor
            context?.setFillColor(fillColor.cgColor)
            context?.setLineWidth(1.0)  //2.5
            context?.move(to: self.point)
            let rectangle = CGRect(x: self.point.x, y: self.point.y, width: 10, height: 10)
            context?.addRect(rectangle)
            //context?.addArc(tangent1End: self.point, tangent2End: CGPoint(x: self.point.x + 40, y: self.point.y), radius: CGFloat(2*Double.pi))
            context?.drawPath(using: CGPathDrawingMode.fillStroke)
        }
    }
}


