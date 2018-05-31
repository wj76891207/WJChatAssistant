//
//  WJButtonGroup.swift
//  WJChatAssistant
//
//  Created by wangjian on 31/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJRoundButton: UIButton {
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        layer.borderColor = tintColor.cgColor
        setTitleColor(tintColor, for: .normal)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 0.5
            }
            else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1.0
                })
            }
        }
    }
}

class WJButtonGroup: UIView {

    var titles: [String] = [] {
        didSet {
            updateButtons()
        }
    }
    
    var buttonClickHandler: ((Int) -> Void)? = nil

    private var buttons: [WJRoundButton] = []
    private let titleFont = UIFont.systemFont(ofSize: 16)
    private let buttonH: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = titles.map {
            let button = WJRoundButton()
            button.setTitle($0, for: .normal)
            button.titleLabel?.font = titleFont
            button.layer.cornerRadius = buttonH/2
            button.layer.borderWidth = CGFloat.piexlOne
            button.addTarget(self, action: #selector(didClickButton(_:)), for: .touchUpInside)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: buttonH/2, bottom: 0, right: buttonH/2)
            button.tintColor = tintColor
            addSubview(button)
            
            return button
        }
        
        setNeedsLayout()
    }
    
    private let buttonMargin: CGFloat = 5
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {

        var fitSize = CGSize.zero
        buttonsFrameThatFits(bounds.size).forEach {
            fitSize.width = max($0.maxX, fitSize.width)
            fitSize.height = max($0.maxY, fitSize.height)
        }
        
        return fitSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frames = buttonsFrameThatFits(bounds.size)
        for i in 0..<buttons.count {
            buttons[i].frame = frames[i]
        }
    }
    
    private func buttonsFrameThatFits(_ size: CGSize) -> [CGRect] {
        
        let buttonsSize: [CGSize] = buttons.map {
            let fitSize = $0.sizeThatFits(CGSize(width: size.width, height: buttonH))
            return CGSize(width: min(fitSize.width, size.width), height: buttonH)
        }

        var curX: CGFloat = 0
        var curY: CGFloat = 0
        var btnFrames: [CGRect] = []
        buttonsSize.forEach {  btnSize in
            if curX + btnSize.width > size.width {
                curX = 0
                curY += buttonH + buttonMargin
            }
            
            btnFrames.append(CGRect(x: curX, y: curY, width: btnSize.width, height: btnSize.height))
            curX += btnSize.width + buttonMargin
        }
        
        return btnFrames
    }
    
    @objc private func didClickButton(_ button: WJRoundButton) {
        guard let index = buttons.index(of: button) else { return }
        
        buttonClickHandler?(index)
    }
}
