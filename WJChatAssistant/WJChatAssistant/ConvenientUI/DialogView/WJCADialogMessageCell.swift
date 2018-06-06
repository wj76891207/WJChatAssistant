//
//  WJCADialogMessageView.swift
//  WJChatAssistant
//
//  Created by wangjian on 30/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

private let avatarSize: CGFloat = 40
private let marginBetweenAvatarAndBubble: CGFloat = 6

//protocol WJCADialogMessageBubbleViewProtocol {
//
//    /// 是否显示头像
//    var showAvatar: Bool { get set }
//
//    /// 头像图片
//    var avatar: UIImage? { get set }
//
//    var bubbleView: WJBubbleView? { get }
//
//    func update(withMessage msg: WJCADialogMessage)
//}

class WJCADialogMessageCell: UICollectionViewCell {
    
    var showAvatar: Bool = true {
        didSet {
            updateAvatar()
        }
    }
    
    var avatar: UIImage? = nil {
        didSet {
            let standerSize = CGSize(width: avatarSize, height: avatarSize)
            if let avatarSize = avatar?.size, avatarSize != standerSize {
                avatar = avatar?.scaleToFit(standerSize)
            }
            avatarView?.image = avatar
        }
    }
    
    private var avatarView: UIImageView? = nil

    lazy var bubbleView: WJBubbleView? = { return WJBubbleView(frame: .zero) }()
    
    private static var _defBotAvatar: UIImage? = nil
    fileprivate static var defBotAvatar: UIImage? {
        if _defBotAvatar == nil {
            _defBotAvatar = UIImage.init(named: "_avatar_bot", in: Bundle(for: self), compatibleWith: nil)
        }
        return _defBotAvatar
    }
    
    private static var _defUserAvatar: UIImage? = nil
    fileprivate static var defUserAvatar: UIImage? {
        if _defUserAvatar == nil {
            _defUserAvatar = UIImage.init(named: "_avatar_user", in: Bundle(for: self), compatibleWith: nil)
        }
        return _defUserAvatar
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let bubbleView = bubbleView {
            contentView.addSubview(bubbleView)
        }
        updateAvatar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//
//    }
    
    func update(withMessage msg: WJCADialogMessage) {
        bubbleView?.skinType = msg.skinType
        bubbleView?.position = msg.position
        bubbleView?.isProcessing = msg.status == .processing
        
        if showAvatar {
            avatar = msg.speaker == .bot ? WJCADialogMessageCell.defBotAvatar : WJCADialogMessageCell.defUserAvatar
        }
        
        setNeedsLayout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let bubbleView = bubbleView else {
            return WJBubbleView.suggestedMinSize
        }
        
        let bubbleConstraintSize = CGSize(width: bubbleMaxWidth(forConstraintWidth: size.width), height: size.height)
        let bubbleFitSize = bubbleView.sizeThatFits(bubbleConstraintSize)
        
        return CGSize(width: showAvatar ? bubbleFitSize.width+avatarSize+marginBetweenAvatarAndBubble : bubbleFitSize.width,
                      height: bubbleFitSize.height)
    }
    
    fileprivate func bubbleMaxWidth(forConstraintWidth width: CGFloat, includeHook: Bool = true) -> CGFloat {
        if showAvatar == false {
            return width
        }
        return width - avatarSize - marginBetweenAvatarAndBubble - (includeHook ? 0 : (bubbleView?.hookWidth ?? 0))
    }
    
//    /// subclass should call this at the end of init
//    func didInitialized() {
//
//    }
    
    private func updateAvatar() {
        if showAvatar && avatarView == nil {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize))
            imageView.layer.cornerRadius = avatarSize/2
            imageView.layer.masksToBounds = true
            contentView.addSubview(imageView)
            avatarView = imageView
            
            setNeedsLayout()
        }
        else if !showAvatar && avatarView != nil {
            avatarView?.removeFromSuperview()
            avatarView = nil
            
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let bubbleView = bubbleView else { return }
        let bubbleW = bubbleMaxWidth(forConstraintWidth: bounds.width)
        if !showAvatar {
            bubbleView.frame = bounds
        }
        else if bubbleView.position == .right {
            avatarView?.frame = CGRect(x: bounds.width-avatarSize, y: 0, width: avatarSize, height: avatarSize)
            bubbleView.frame = CGRect(x: 0, y: 0, width: bubbleW, height: bounds.height)
        }
        else {
            avatarView?.frame = CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)
            bubbleView.frame = CGRect(x: bounds.width-bubbleW, y: 0, width: bubbleW, height: bounds.height)
        }
    }
}

class WJCADialogTextMessageCell: WJCADialogMessageCell {
    
    override lazy var bubbleView: WJBubbleView? = {
        return WJTextBubbleView(frame: bounds)
    }()
    
    fileprivate var textBubbleView: WJTextBubbleView { return bubbleView as! WJTextBubbleView }
    
    override func update(withMessage msg: WJCADialogMessage) {
        super.update(withMessage: msg)
        textBubbleView.text = msg.content as? String
    }
    
}

class WJCADialogImageMessageCell: WJCADialogMessageCell {
    
    override lazy var bubbleView: WJBubbleView? = {
        return WJImageBubbleView(frame: bounds)
    }()
    private var imageBubbleView: WJImageBubbleView { return bubbleView as! WJImageBubbleView }
    
    override func update(withMessage msg: WJCADialogMessage) {
        super.update(withMessage: msg)
        imageBubbleView.image = msg.content as? UIImage
    }
}

class WJCADialogOptionsMessageCell: WJCADialogTextMessageCell {
    
    private var optionsButtonView = WJButtonGroup()
    private let marginOfTitleAndOptions: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(optionsButtonView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withMessage msg: WJCADialogMessage) {
        super.update(withMessage: msg)
        
        if let content = msg.content as? WJCADialogOptionMessageContent {
            textBubbleView.text = content.title
            optionsButtonView.titles = content.options
        }
    }
    
    private func optionButtonViewSizeThatFits(_ size: CGSize) -> CGSize {
        let optionConstraintSize = CGSize(width: bubbleMaxWidth(forConstraintWidth: size.width, includeHook: false), height: size.height)
        return optionsButtonView.sizeThatFits(optionConstraintSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let bubbleView = bubbleView, !bubbleView.isProcessing else {
            return super.sizeThatFits(size)
        }
        
        let titleAreaSize = super.sizeThatFits(size)
        let optionAreaSize = optionButtonViewSizeThatFits(size)
        
        return CGSize(width: max(titleAreaSize.width, optionAreaSize.width),
                      height: titleAreaSize.height+optionAreaSize.height+marginOfTitleAndOptions)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let bubbleView = bubbleView else { return }

        let titleAreaSize = super.sizeThatFits(bounds.size)
        let optionAreaSize = optionButtonViewSizeThatFits(bounds.size)
        
        let bubbleFrame = bubbleView.frame
        bubbleView.frame = CGRect(x: bubbleFrame.minX,
                                  y: bubbleFrame.minY,
                                  width: bubbleFrame.width - (bounds.size.width - titleAreaSize.width - marginOfTitleAndOptions),
                                  height: bubbleFrame.height - optionAreaSize.height)
        
        let startX = bubbleView.position == .left ? bubbleFrame.minX+bubbleView.hookWidth : bubbleFrame.minX
        optionsButtonView.frame = CGRect(x: startX,
                                         y: bubbleView.frame.maxY+marginOfTitleAndOptions,
                                         width: optionAreaSize.width,
                                         height: optionAreaSize.height)
    }
}


class WJCADialogOptionListMessageCell: WJCADialogTextMessageCell {
    
    override lazy var bubbleView: WJBubbleView? = {
        return WJOptionListBubbleView(frame: bounds)
    }()
    private var optionListBubbleView: WJOptionListBubbleView { return bubbleView as! WJOptionListBubbleView }
    
    override func update(withMessage msg: WJCADialogMessage) {
        super.update(withMessage: msg)
        
        if let content = msg.content as? WJCADialogOptionMessageContent {
            optionListBubbleView.text = content.title
            optionListBubbleView.optionalTitles = content.options
        }
    }
    
}


extension WJCADialogMessage {
    
    var position: WJBubbleView.Position {
        switch self.speaker {
        case .user:
            return .right
        case .system:
            return .center
        default:
            return .left
        }
    }
    
    var skinType: WJBubbleView.SkinType {
        switch self.speaker {
        case .user:
            return .blue
        default:
            return .gray
        }
    }
}
