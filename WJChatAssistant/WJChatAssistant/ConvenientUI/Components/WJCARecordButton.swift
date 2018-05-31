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
    
    var start: WJCARecordButton? = nil
    var stop: WJCARecordButton? = nil
    var cancel: WJCARecordButton? = nil
    
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
