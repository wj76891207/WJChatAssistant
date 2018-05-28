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
    var position: Position = .left {
        didSet {
            updateShape()
        }
    }
    
    var cornerRadiu: CGFloat = 15 {
        didSet {
            updateShape()
        }
    }
    
    
    init(frame: CGRect, position: Position = .left) {
        super.init(frame: frame)
        self.position = position
        updateShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateShape() {
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()

        maskPath.move(to: CGPoint(x: cornerRadiu/2, y: cornerRadiu))
        if position == .left {
            maskPath.addArc(tangent1End: CGPoint(x: 0, y: cornerRadiu), tangent2End: CGPoint(x: 0, y: cornerRadiu/2), radius: cornerRadiu/2)
            let point = CGPoint(x: cornerRadiu - CGFloat(cos(Float.pi/8))*cornerRadiu + cornerRadiu/2, y: cornerRadiu*5/8)
            maskPath.addArc(tangent1End: CGPoint(x: 0, y: point.y), tangent2End: point, radius: cornerRadiu/2)
            maskPath.addArc(tangent1End: CGPoint(x: point.x, y: 0), tangent2End: CGPoint(x: cornerRadiu, y: 0), radius: cornerRadiu)
        }
        else {
            maskPath.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: cornerRadiu, y: 0), radius: cornerRadiu)
        }
        
        if position == .right {
            maskPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        }
        else {
            maskPath.addArc(tangent1End: CGPoint(x: bounds.width, y: 0), tangent2End: CGPoint(x: bounds.width, y: cornerRadiu), radius: cornerRadiu)
        }

        maskPath.addArc(tangent1End: CGPoint(x: bounds.width, y: bounds.height), tangent2End: CGPoint(x: bounds.width-cornerRadiu, y: bounds.height), radius: cornerRadiu)
        maskPath.addArc(tangent1End: CGPoint(x: cornerRadiu/2, y: bounds.height), tangent2End: CGPoint(x: cornerRadiu/2, y: bounds.height-cornerRadiu), radius: cornerRadiu)
        
        maskPath.closeSubpath()
        
        maskLayer.path = maskPath
        layer.mask = maskLayer
    }
}
