//
//  PieChartView.swift
//  PieChart
//
//  Created by Satoshi Ito on 2015/08/23.
//  Copyright © 2015年 Satoshi Ito. All rights reserved.
//

import UIKit

class PieChartView: UIView, CAAnimationDelegate {
    
    //  Public
    var pieColor: UIColor!
    var pieBackgroundColor: UIColor!
    var textColor: UIColor!
    var animationTime: CGFloat!
    var valueFontSize: CGFloat!
    var unitFontSize: CGFloat!
    var pielineWidth: CGFloat!
    var rate: NSInteger!
    var isAnimation: Bool!
    
    //  Private
    private var endValueString: String!
    private var endValue: CGFloat!
    private var valueLabel: UILabel!
    private var percnetLabel: UILabel!
    private var overPercent: NSInteger!
    private var circle: CAShapeLayer!
    private var backCircle: CAShapeLayer!
    
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingInit()
    }
    
    /**
     円グラフ描画
     */
    func drawPie() {
        
        if self.rate > 100 {
            return
        }
        
        if self.rate <= 100 {
            self.overPercent = -1
        }
        
        //
        self.endValue       = CGFloat(self.rate) / 100.0;
        self.endValueString = String(format:"%d", self.rate)
        
        //
        if self.circle != nil {
            self.circle.removeFromSuperlayer()
        }
        if self.backCircle != nil {
            self.backCircle.removeFromSuperlayer()
        }
        
        //
        self.drawAnimation()
        self.makeLabel()
    }
    
    
    // MARK: - PrivateMethod
    /**
     初期設定
     */
    private func settingInit() {
        self.backgroundColor    = UIColor.clear
        //self.pieColor           = UIColor(colorLiteralRed: 0.16, green: 0.66, blue: 0.86, alpha: 1.0)
        self.pieColor = UIColor(red: 0.16, green: 0.66, blue: 0.86, alpha: 1.0)
        //self.pieBackgroundColor = UIColor(colorLiteralRed: 0.85, green: 0.86, blue: 0.88, alpha: 1.0)
        self.pieBackgroundColor = UIColor(red: 0.85, green: 0.86, blue: 0.88, alpha: 1.0)
        self.textColor          = UIColor.darkGray
        self.valueFontSize      = 18.0
        self.unitFontSize       = 10.0
        self.pielineWidth       = 12.0
        self.animationTime      = 2.0
        self.overPercent        = -1
        self.isAnimation        = false
        self.rate               = 0
    }
    
    
    /**
     ラベル作成
     */
    private func makeLabel() {
        //  値ラベル
        if self.valueLabel != nil {
            self.valueLabel.removeFromSuperview()
        }
        self.valueLabel = UILabel()
        self.valueLabel.backgroundColor = UIColor.clear
        self.valueLabel.font = UIFont.systemFont(ofSize: self.valueFontSize)
        self.valueLabel.text = self.endValueString
        self.valueLabel.textColor = UIColor.darkGray
        self.valueLabel.sizeToFit()
        self.valueLabel.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2 - 5)
        self.addSubview(self.valueLabel)
        
        //  パーセントラベル
        if self.percnetLabel != nil {
            self.percnetLabel.removeFromSuperview()
        }
        self.percnetLabel = UILabel()
        self.percnetLabel.backgroundColor = UIColor.clear
        self.percnetLabel.font = UIFont.systemFont(ofSize: self.unitFontSize)
        self.percnetLabel.text = "%";
        self.percnetLabel.textColor = UIColor.darkGray
        self.percnetLabel.sizeToFit()
        self.percnetLabel.frame = CGRect(
            x: valueLabel.frame.minX + ((valueLabel.frame.size.width - percnetLabel.frame.size.width) / 2),
            y: valueLabel.frame.maxY - 4,
            width: percnetLabel.frame.size.width,
            height: percnetLabel.frame.size.height)
        self.addSubview(self.percnetLabel)
    }
    
    /**
     アニメーション描画
     */
    private func drawAnimation() {
        // 半径
        let radius = self.frame.size.width / 2 - self.pielineWidth / 2
        
        // 背景の円を生成
        let backRect = CGRect(x: self.pielineWidth / 2, y: self.pielineWidth / 2, width: 2.0 * radius, height: 2.0 * radius)
        self.backCircle             = CAShapeLayer()
        self.backCircle.path        = UIBezierPath(roundedRect: backRect, cornerRadius: radius).cgPath
        self.backCircle.fillColor   = UIColor.clear.cgColor
        self.backCircle.strokeColor = self.pieBackgroundColor.cgColor;
        self.backCircle.lineWidth   = self.pielineWidth;
        self.layer.addSublayer(self.backCircle)
        
        // 円グラフを生成
        let circleRect = CGRect(x: self.pielineWidth / 2, y: self.pielineWidth / 2, width: 2.0 * radius, height: 2.0 * radius)
        self.circle             = CAShapeLayer();
        self.circle.path        = UIBezierPath(roundedRect: circleRect, cornerRadius: radius).cgPath
        self.circle.fillColor   = UIColor.clear.cgColor
        self.circle.strokeColor = self.pieColor.cgColor;
        self.circle.lineWidth   = self.pielineWidth;
        self.layer.addSublayer(self.circle)
        
        //  アニメーション
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        if self.isAnimation==false {
            drawAnimation.beginTime = 1
        }
        if self.endValue > 1.0 {
            self.endValue = 1.0
        }
        drawAnimation.delegate            = self;
        drawAnimation.duration            = CFTimeInterval(self.animationTime * endValue)
        drawAnimation.fromValue           = NSNumber(value: 0.0)
        drawAnimation.toValue             = NSNumber(value: Float(self.endValue))
        drawAnimation.fillMode            = kCAFillModeForwards;
        drawAnimation.isRemovedOnCompletion = false;
        
        if overPercent != -1 {
            drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        } else {
            drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        }
        
        self.circle.add(drawAnimation, forKey: "drawCircleAnimation")
    }
}
