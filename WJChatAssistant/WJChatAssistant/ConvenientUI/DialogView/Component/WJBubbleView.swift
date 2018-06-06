//
//  WJBubbleView.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJBubbleView: UIView {

    enum Position {
        case left
        case center
        case right
    }
    
    /// 用于控制气泡显示的颜色，子类还会通过该属性控制器内容的显示颜色
    enum SkinType {
        case none
        case blue
        case gray
        
        var color: UIColor? {
            let color: UIColor?
            
            switch self {
            case .blue:
                color = UIColor.init(red: 96/255.0, green: 143/255.0, blue: 233/255.0, alpha: 1)
            case .gray:
                color = UIColor.init(red: 242/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1)
            default:
                color = nil
            }
            
            return color
        }
    }
    
    var position: Position = .left {
        didSet {
            updateShape()
        }
    }
    
    var skinType: SkinType = .blue {
        didSet {
            if let color = skinType.color {
                backgroundColor = color
            }
        }
    }
    
    var cornerRadiu: CGFloat = 15 {
        didSet {
            updateShape()
        }
    }
    
    var hookWidth: CGFloat {
        return cornerRadiu*0.5 //既是宽度，也是高度
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    private var bgShapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    var borderColor: UIColor? {
        get { return bgShapeLayer.strokeColor == nil ? nil : UIColor(cgColor: bgShapeLayer.strokeColor!) }
        set { bgShapeLayer.strokeColor = newValue?.cgColor }
    }
    
    var borderWidth: CGFloat {
        get { return bgShapeLayer.lineWidth }
        set { bgShapeLayer.lineWidth = newValue }
    }
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.layer.mask = CAShapeLayer()
        return contentView
    }()
    
    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
    
    override var frame: CGRect {
        didSet {
            if frame.size != oldValue.size {
                updateShape()
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        get {
            if let fillColor = bgShapeLayer.fillColor {
                return UIColor(cgColor: fillColor)
            }
            return nil
        }
        set {
            bgShapeLayer.fillColor = newValue?.cgColor
        }
    }
    
    private var processingView: WJMarbleLoadingView? = nil
    var isProcessing = false {
        didSet {
            if !isProcessing {
                processingView?.removeFromSuperview()
                processingView = nil
            }
            else if processingView == nil {
                var size = type(of: self).suggestedMinSize
                if position != .center {
                    size.width -= hookWidth
                }
                let x = position != .left ? 0 : hookWidth
                processingView = WJMarbleLoadingView(frame: CGRect(x: x, y: 0, width: size.width, height: size.height), number: 3)
                addSubview(processingView!)
            }
        }
    }
    
    var contentEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (position == .left ? hookWidth : 0),
                            bottom: 0, right: (position == .right ? hookWidth : 0))
    }

    
    // 气泡建议的最大最小尺寸
    static var suggestedMinSize = CGSize(width: 60, height: 40)
    static var suggestedMaxSize = CGSize(width: (UIScreen.main.bounds.width*0.6).flat,
                                         height: (UIScreen.main.bounds.height*0.6).flat)
    
    init(frame: CGRect, position: Position = .left) {
        super.init(frame: frame)
        self.position = position
        super.addSubview(contentView)
        updateShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return type(of: self).suggestedMinSize
    }
    
    private func updateShape() {
//        guard let maskLayer = layer.mask as? CAShapeLayer else {
//            return
//        }

        let maskPath = CGMutablePath()

        let hookOffset = cornerRadiu*0.15 //为了视觉上更好看，适当加高高度
        let hookAngle = CGFloat.pi/7    //可以控制厚度

        
        if position == .left {
            // left top angle hook
            maskPath.move(to: CGPoint(x: hookWidth, y: cornerRadiu))
            let hookFootPoint = CGPoint(x: cornerRadiu - CGFloat(cos(hookAngle))*cornerRadiu + hookWidth,
                                        y: cornerRadiu - CGFloat(sin(hookAngle))*cornerRadiu)
            
            maskPath.addQuadCurve(to: CGPoint(x: 0, y: cornerRadiu-hookWidth-hookOffset),
                                  control: CGPoint(x: 0, y: cornerRadiu-2*hookOffset))
            maskPath.addQuadCurve(to: hookFootPoint,
                                  control: CGPoint(x: hookWidth/2, y: hookFootPoint.y))
            maskPath.addArc(center: CGPoint.init(x: hookWidth+cornerRadiu, y: cornerRadiu),
                            radius: cornerRadiu,
                            startAngle: CGFloat.pi+hookAngle,
                            endAngle: CGFloat.pi*3/2,
                            clockwise: false)
        }
        else {
            maskPath.move(to: CGPoint(x: 0, y: cornerRadiu))
            maskPath.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: cornerRadiu, y: 0), radius: cornerRadiu)
        }
        
        if position == .right {
            // right top angle hook
            
            let hookFootPoint = CGPoint(x: bounds.width - CGFloat(cos(hookAngle))*cornerRadiu - hookWidth,
                                        y: cornerRadiu - CGFloat(sin(hookAngle))*cornerRadiu)
            
            maskPath.addArc(center: CGPoint.init(x: bounds.width - hookWidth - cornerRadiu, y: cornerRadiu),
                            radius: cornerRadiu,
                            startAngle: CGFloat.pi*3/2,
                            endAngle: CGFloat.pi*2-hookAngle,
                            clockwise: false)
            maskPath.addQuadCurve(to: CGPoint(x: bounds.width, y: cornerRadiu-hookWidth-hookOffset),
                                  control: CGPoint(x: bounds.width-hookWidth/2, y: hookFootPoint.y))
            maskPath.addQuadCurve(to: CGPoint(x: bounds.width-hookWidth, y: cornerRadiu),
                                  control: CGPoint(x: bounds.width, y: cornerRadiu-2*hookOffset))
        }
        else {
            maskPath.addArc(tangent1End: CGPoint(x: bounds.width, y: 0), tangent2End: CGPoint(x: bounds.width, y: cornerRadiu), radius: cornerRadiu)
        }
        
        maskPath.addArc(tangent1End: CGPoint(x: bounds.width - (position == .right ? hookWidth : 0), y: bounds.height),
                        tangent2End: CGPoint(x: bounds.width - (position == .right ? hookWidth : 0) - cornerRadiu, y: bounds.height), radius: cornerRadiu)
        maskPath.addArc(tangent1End: CGPoint(x: (position == .left ? hookWidth : 0), y: bounds.height),
                        tangent2End: CGPoint(x: (position == .left ? hookWidth : 0), y: bounds.height-cornerRadiu), radius: cornerRadiu)
        
        maskPath.closeSubpath()
        (layer as? CAShapeLayer)?.path = maskPath
        (contentView.layer.mask as? CAShapeLayer)?.path = maskPath
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
}
