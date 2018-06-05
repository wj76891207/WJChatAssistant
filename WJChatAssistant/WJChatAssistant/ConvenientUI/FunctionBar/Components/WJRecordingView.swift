//
//  WJCARecordingView.swift
//  WJChatAssistant
//
//  Created by wangjian on 04/06/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJRecordingView: UIView {

    lazy var waveView: WJSoundWaveView = {
        let waveView = WJSoundWaveView(frame: .zero, style: .halo)
        waveView.waveColor = _blueColor
        return waveView
    }()
    
    private lazy var tipsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "你可以说"
        label.textColor = _blueColor
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let maxContentLineNumber = 3
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "我要拜访门店"
        label.numberOfLines = maxContentLineNumber
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let closeBtnSize: CGFloat = 40
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "_close", in: Bundle.init(for: WJRecordingView.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(didClickCloseBtn(_:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    
    var closeHandler: (() -> Void)? = nil
    
    var tips: String? = nil {
        didSet {
            updateTipsView()
        }
    }
    
    var content: String? = nil {
        didSet {
            contentLabel.text = content
            updateTipsView()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        didInitialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        didInitialized()
    }
    
    func didInitialized() {
        addSubview(tipsTitleLabel)
        addSubview(contentLabel)
        addSubview(waveView)
        addSubview(closeButton)
        
        backgroundColor = UIColor.white
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.cornerRadius = 13
    }
    
    private func updateTipsView() {
        tipsTitleLabel.isHidden = content != nil
        if content == nil {
            tipsTitleLabel.text = tips
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let waveH: CGFloat = 80
        let tipsTitleH = tipsTitleLabel.font.lineHeight
        let contentH = contentLabel.font.lineHeight*CGFloat(maxContentLineNumber)
        let marginBetweenItems: CGFloat = 10
        let marginToBorderHorizontal: CGFloat = 15
        let marginToBorderVertical = ((bounds.height-waveH-tipsTitleH-contentH-2*marginBetweenItems)/2).flat
        
        closeButton.frame = CGRect(x: bounds.width-closeBtnSize, y: 0, width: closeBtnSize, height: closeBtnSize)
        tipsTitleLabel.frame = CGRect(x: marginToBorderHorizontal, y: marginToBorderVertical,
                                      width: bounds.width - 2*marginToBorderHorizontal, height: tipsTitleH)
        contentLabel.frame = CGRect(x: marginToBorderHorizontal, y: tipsTitleLabel.frame.maxY+marginBetweenItems,
                                      width: bounds.width - 2*marginToBorderHorizontal, height: contentH)
        waveView.frame = CGRect(x: 0, y: contentLabel.frame.maxY+marginBetweenItems,
                                width: bounds.width, height: waveH)
    }
    
    @objc private func didClickCloseBtn(_ sender: UIButton) {
        closeHandler?()
    }

}

//private class WJRecordingTipsView: UIView {
//
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    private func didInitialized() {
//        addSubview(titleLabel)
//        addSubview(contentLabel)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        titleLabel = CGRect(x: 20, y: 0, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//    }
//}

