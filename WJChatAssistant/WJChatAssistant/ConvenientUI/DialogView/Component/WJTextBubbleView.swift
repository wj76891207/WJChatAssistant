//
//  WJTextBubbleView.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJTextBubbleView: WJBubbleView {

    var text: String? {
        get { return textLabel.text }
        set { textLabel.text = newValue }
    }
    
    var textColor: UIColor {
        get { return textLabel.textColor }
        set { textLabel.textColor = newValue }
    }
    
    var font: UIFont {
        get { return textLabel.font }
        set { textLabel.font = newValue }
    }
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override var skinType: WJBubbleView.SkinType {
        didSet {
            backgroundColor = skinType.color
            textColor = skinType.textColor
        }
    }
    
    override var contentEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: cornerRadiu*2/3,
                            left: (position == .left ? hookWidth : 0) + cornerRadiu*2/3,
                            bottom: cornerRadiu*2/3,
                            right: (position == .right ? hookWidth : 0) + cornerRadiu*2/3)
    }

//    /// 根据内容以及view的相关属性，计算合适的显示大小
//    class func fitSize(withText text: String?,
//                       font: UIFont,
//                       position: Position,
//                       constraintSize: CGSize? = nil,
//                       cornerRadiu: CGFloat = 15,
//                       hookWidth: CGFloat = 7.5) -> CGSize {
//        
//        let insets = contentEdgeInsets(withPosition: position, cornerRadiu: cornerRadiu, hookWidth: hookWidth)
//        var contentConstraintSize = suggestedMaxSize
//        if let constraintSize = constraintSize {
//            contentConstraintSize.width = constraintSize.width - insets.horizontal
//            contentConstraintSize.height = constraintSize.height - insets.vertival
//        }
//        
//        let strSize = text?.size(widthConstrainedSize: contentConstraintSize, font: font) ?? .zero
//        let bubbleSize = CGSize(width: (strSize.width+insets.horizontal).flat, height: (strSize.height+insets.vertival).flat)
//        return bubbleSize
//    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if isProcessing {
            return super.sizeThatFits(size)
        }
        
        let insets = contentEdgeInsets
        let contentConstraintSize = CGSize(width: size.width - insets.horizontal, height: size.height - insets.vertival)
        let strSize = text?.size(widthConstrainedSize: contentConstraintSize, font: font) ?? .zero
        let bubbleSize = CGSize(width: (strSize.width+insets.horizontal).flat, height: (strSize.height+insets.vertival).flat)
        return bubbleSize
    }
    
    override init(frame: CGRect, position: Position = .left) {
        super.init(frame: frame, position: position)
        
        self.invalidateIntrinsicContentSize()
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame = bounds.interact(withEdgeInsets: contentEdgeInsets)
    }
}

private extension WJBubbleView.SkinType {
    
    var textColor: UIColor {
        let color: UIColor
        
        switch self {
        case .blue:
            color = UIColor.white
        default:
            color = UIColor.black
        }
        
        return color
    }
    
}

