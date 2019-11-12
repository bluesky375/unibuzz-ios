//
//  RoundProgressBar.swift
//  UniBuzz
//
//  Created by Asim Khan on 8/8/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundProgressBar: UIView {
    private var bgLayer = CAShapeLayer()
    private var fgLayer = CAShapeLayer()
    var minValue: Double = 0
    var maxValue: Double = 5.0
    var currentValue: Double = 0 {
        didSet{
            fgLayer.strokeEnd = currentValue > 0.01 ? CGFloat(currentValue) : 0.01
        }
    }
    
    @IBInspectable var progressBarWidth: CGFloat = 20.0 {
        didSet{
            configureView()
        }
    }
    
    @IBInspectable var progressBarTintColor: UIColor = UIColor.lightGray {
        didSet{
            configureView()
        }
    }
    
    @IBInspectable var progressBarProgressColor: UIColor = UIColor.clear {
        didSet{
            configureView()
        }
    }
    
    var gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
        setupCAShapeLayers(shapeLayer: bgLayer, startAngle: CGFloat(Double.pi), endAngle: 0)
        setupCAShapeLayers(shapeLayer: fgLayer, startAngle: CGFloat(Double.pi), endAngle: 0)
        setupCAShapeLayers(shapeLayer: gradient, startAngle: CGFloat(Double.pi), endAngle: 0)
    }
    
    func configureView() {
        
//        gradient.frame = self.bounds
//        gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
//        fgLayer.addSublayer(gradient)
        
        bgLayer.lineWidth = progressBarWidth
        bgLayer.fillColor = nil
        bgLayer.strokeEnd = CGFloat(maxValue)
        layer.addSublayer(bgLayer)
        fgLayer.lineWidth = progressBarWidth
        fgLayer.fillColor = nil
        fgLayer.strokeEnd = CGFloat(currentValue)
        layer.addSublayer(fgLayer)
//        l.
        fgLayer.fillRule = .evenOdd
        bgLayer.strokeColor = progressBarTintColor.cgColor
        fgLayer.strokeColor = progressBarProgressColor.cgColor
    }
    
    func setupCAShapeLayers(shapeLayer: CAShapeLayer, startAngle: CGFloat, endAngle: CGFloat) {
        shapeLayer.frame = self.bounds
        let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
        let radius = (self.bounds.width * 0.35)
        let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
    }
    
    func setupCAShapeLayers(shapeLayer: CAGradientLayer, startAngle: CGFloat, endAngle: CGFloat) {
        shapeLayer.frame = self.bounds
        let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
        let radius = (self.bounds.width * 0.35)
        let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//        shapeLayer.path = path.cgPath
    }
}
