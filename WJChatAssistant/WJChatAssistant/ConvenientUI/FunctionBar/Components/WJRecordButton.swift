//
//  WJCARecordButton.swift
//  WJChatAssistant
//
//  Created by Jian Wang on 2018/5/27.
//  Copyright © 2018年 wangjian. All rights reserved.
//

import UIKit

class WJRecordButton: UIControl {
    
    private let head = CAShapeLayer()
    private let torus = CAShapeLayer()
    private let stem = CAShapeLayer()
    
    enum Status {
        case waiting
        case recording
        case processing
    }
    var stauts: Status = .waiting {
        didSet {
            self.updateShape(forStatus: self.stauts)
        }
    }
    
    private lazy var stopIconLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInitialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func didInitialized() {
        
        backgroundColor = UIColor.white
        
        layer.addSublayer(head)
        layer.addSublayer(torus)
        layer.addSublayer(stem)
        
        layer.borderWidth = 1.0
        head.lineWidth = 2.0
        torus.lineWidth = 2.0
        stem.lineWidth = 2.0
        
        tintColor = _blueColor
    }
    
    override var isHighlighted: Bool {
        didSet {
            
            let opacity: Float = isHighlighted ? 0.5 : 1.0
            head.opacity = opacity
            torus.opacity = opacity
            stem.opacity = opacity
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        layer.cornerRadius = layer.bounds.width/2
        updateShape(forStatus: stauts)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        layer.borderColor = tintColor.cgColor
        head.strokeColor = nil
        head.fillColor = tintColor.cgColor
        torus.strokeColor = tintColor.cgColor
        torus.fillColor = nil
        stem.strokeColor = tintColor.cgColor
        stem.fillColor = nil
    }
    
    private func updateShape(forStatus status: Status) {
        
        func _animatedStokeHead(to newPath: CGPath) {
            let anim = CASpringAnimation(keyPath: "path")
            anim.fromValue = head.path
            anim.toValue = newPath
            anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            head.add(anim, forKey: nil)
            head.path = newPath
        }
        
        func _animatedStokeTorus(_ isShow: Bool) {
            let anim1 = CABasicAnimation(keyPath: "strokeStart")
            anim1.fromValue = torus.strokeStart
            anim1.toValue = isShow ? 0 : 0.5
            anim1.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            torus.add(anim1, forKey: nil)
            torus.strokeStart = isShow ? 0 : 0.5
            
            let anim2 = CABasicAnimation(keyPath: "strokeEnd")
            anim2.fromValue = torus.strokeEnd
            anim2.toValue = isShow ? 1 : 0.5
            anim2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            torus.add(anim2, forKey: nil)
            torus.strokeEnd = isShow ? 1 : 0.5
            
            let anim3 = CABasicAnimation(keyPath: "position")
            anim3.fromValue = torus.position
            anim3.toValue = isShow ? CGPoint(x: 0, y: 0) : CGPoint(x: 0, y: bounds.height/12)
            anim3.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            torus.add(anim3, forKey: nil)
            torus.position = isShow ? CGPoint(x: 0, y: 0) : CGPoint(x: 0, y: bounds.height/12)
        }
        
        func _animatedStokeStem(_ isShow: Bool) {
            let anim = CABasicAnimation(keyPath: "strokeStart")
            anim.fromValue = stem.strokeStart
            anim.toValue = isShow ? 0 : 1
            anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            stem.add(anim, forKey: nil)
            stem.strokeStart = isShow ? 0 : 1
        }
        
        let iconW = bounds.width / 3
        let iconH = bounds.height / 2
        let iconY = (bounds.height - iconH)/2
        
        let headW = iconW * 0.6
        let headH = iconH * 0.625
        let headR = headW * 0.5
        
        let torusR = iconW / 2
        
        if status == .waiting {
            _animatedStokeHead(to: CGPath.init(roundedRect: CGRect.init(x: (bounds.width - headW)/2, y: iconY, width: headW, height: headH), cornerWidth: headR, cornerHeight: headR, transform: nil))
            torus.path = UIBezierPath.init(arcCenter: CGPoint.init(x: bounds.width/2, y: iconY+headH-headR), radius: torusR, startAngle: 0, endAngle: CGFloat.pi, clockwise: true).cgPath
            _animatedStokeTorus(true)
            
            let stemPath = CGMutablePath()
            stemPath.move(to: CGPoint(x: bounds.width/2, y: iconY+headH-headR+torusR))
            stemPath.addLine(to: CGPoint(x: bounds.width/2, y: iconY+iconH))
            stemPath.move(to: CGPoint(x: (bounds.width-headW)/2, y: iconY+iconH))
            stemPath.addLine(to: CGPoint(x: (bounds.width+headW)/2, y: iconY+iconH))
            stem.path = stemPath
            _animatedStokeStem(true)
        }
        else if status == .recording {
            let offset = bounds.width / 3
            let cornerRadiu: CGFloat = 5
            _animatedStokeHead(to: CGPath.init(roundedRect: bounds.insetBy(dx: offset, dy: offset), cornerWidth: cornerRadiu, cornerHeight: cornerRadiu, transform: nil))
            
            _animatedStokeTorus(false)
            _animatedStokeStem(false)
        }
    }
}


