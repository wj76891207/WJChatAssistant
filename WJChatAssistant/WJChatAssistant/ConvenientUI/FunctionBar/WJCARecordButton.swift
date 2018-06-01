//
//  WJCARecordButton.swift
//  WJChatAssistant
//
//  Created by Jian Wang on 2018/5/27.
//  Copyright © 2018年 wangjian. All rights reserved.
//

import UIKit

class WJCARecordButton: UIControl {

    typealias reactBlock = (_ sender: WJCARecordButton) -> Void
    
    var startHandler: reactBlock? = nil
    var stopHandler: reactBlock? = nil
    var cancelHandler: reactBlock? = nil
    
    private lazy var stopIconLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupControl() {
        addTarget(self, action: #selector(didClick(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = CGPath.init(ellipseIn: bounds, transform: nil)
        layer.mask = maskLayer
    }
    
    // MARK: - actions
    private var isRecording = false
    
    @objc private func didClick(_ sender: WJCARecordButton) {
        
    }
    
    func startRecord() {
        guard isRecording == false else { return }
        
        
    }
}

public class WJRecordIconLayer: CALayer {
    
    let head = CAShapeLayer()
    let torus = CAShapeLayer()
    let stem = CAShapeLayer()
    
    enum Status {
        case waiting
        case recording
        case processing
    }
    var status: Status = .waiting
    
    public override init() {
        super.init()
        
        addSublayer(head)
        addSublayer(torus)
        addSublayer(stem)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateShape(forStatus status: Status) {
        
        if status == .waiting {
            let iconW = bounds.width / 3
            let iconH = bounds.height / 2
            
            let headW = iconW * 0.6
            let headH = iconH * 0.625
            
            let lineW: CGFloat = 1.5
            let torusRadio = iconW / 2
            
            let stemH = iconH - headH - torusRadio + headW/2
        }
    }
}
