//
//  WJCADialogMessageView.swift
//  WJChatAssistant
//
//  Created by wangjian on 30/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

private let avatarSize: CGFloat = 40
private let marginBetweenAvatarAndBubble: CGFloat = 10

protocol WJCADialogMessageBubbleViewProtocol {
    
    /// 是否显示头像
    var showAvatar: Bool { get set }
    
    /// 头像图片
    var avatar: UIImage? { get set }
    
    var bubbleView: WJBubbleView? { get }
    
    func update(withMessage msg: WJCADialogMessage)
    
    static func size(fitIn constraintSize: CGSize, withMessage msg: WJCADialogMessage) -> CGSize
}

class WJCADialogMessageView: UICollectionViewCell, WJCADialogMessageBubbleViewProtocol {
    
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
    
    func update(withMessage msg: WJCADialogMessage) {
        bubbleView?.skinType = msg.skinType
        bubbleView?.position = msg.position
        bubbleView?.isProcessing = msg.status == .processing
        
        if showAvatar {
            avatar = msg.speaker == .bot ? WJCADialogMessageView.defBotAvatar : WJCADialogMessageView.defUserAvatar
        }
        
        setNeedsLayout()
    }
    
    class func size(fitIn constraintSize: CGSize, withMessage msg: WJCADialogMessage) -> CGSize {
        return .zero
    }
    
    fileprivate static func bubbleWidth(forConstraintWidth width: CGFloat, showAvatar: Bool = false) -> CGFloat {
        if showAvatar == false {
            return width
        }
        return width - avatarSize - marginBetweenAvatarAndBubble
    }
    
    fileprivate static func bubbleSize(forConstraintWidth size: CGSize, showAvatar: Bool = false) -> CGSize {
        return CGSize(width: bubbleWidth(forConstraintWidth: size.width, showAvatar: showAvatar) , height: size.height)
    }
    
    /// subclass should call this at the end of init
    func didInitialized() {
        if let bubbleView = bubbleView {
            contentView.addSubview(bubbleView)
        }
        updateAvatar()
    }
    
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
        let bubbleW = WJCADialogMessageView.bubbleWidth(forConstraintWidth: bounds.width, showAvatar: showAvatar)
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

class WJCADialogTextMessageView: WJCADialogMessageView {
    
    private var textBubbleView: WJTextBubbleView { return bubbleView as! WJTextBubbleView }
    
    override init(frame: CGRect) {

        super.init(frame: frame)

        bubbleView = WJTextBubbleView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        didInitialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withMessage msg: WJCADialogMessage) {
        super.update(withMessage: msg)
        textBubbleView.text = msg.content as? String
    }
    
    override static func size(fitIn constraintSize: CGSize, withMessage msg: WJCADialogMessage) -> CGSize {
        let showAvatar = msg.position != .center
        
        let bubbleFitSize: CGSize
        if msg.status == .processing {
            bubbleFitSize = WJTextBubbleView.suggestedMinSize
        }
        else {
            let bubbleConstraintSize = WJCADialogMessageView.bubbleSize(forConstraintWidth: constraintSize, showAvatar: showAvatar)
            bubbleFitSize = WJTextBubbleView.fitSize(withText: msg.content as? String,
                                                     font: UIFont.systemFont(ofSize: 16),
                                                     position: msg.position,
                                                     constraintSize: bubbleConstraintSize)
        }
        
        return CGSize(width: showAvatar ? bubbleFitSize.width+avatarSize+marginBetweenAvatarAndBubble : bubbleFitSize.width,
                      height: bubbleFitSize.height)
    }
    
}

class WJCADialogImageMessageView: WJCADialogMessageView {
    
    private var imageBubbleView: WJImageBubbleView { return bubbleView as! WJImageBubbleView }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        bubbleView = WJImageBubbleView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        didInitialized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withMessage msg: WJCADialogMessage) {
        super.update(withMessage: msg)
        imageBubbleView.image = msg.content as? UIImage
    }
    
    override static func size(fitIn constraintSize: CGSize, withMessage msg: WJCADialogMessage) -> CGSize {
        let showAvatar = msg.position != .center
        
        let bubbleFitSize: CGSize
        if msg.status == .processing {
            bubbleFitSize = WJTextBubbleView.suggestedMinSize
        }
        else {
            let bubbleConstraintSize = WJCADialogMessageView.bubbleSize(forConstraintWidth: constraintSize, showAvatar: showAvatar)
            bubbleFitSize = WJImageBubbleView.fitSize(withImage: msg.content as? UIImage,
                                                      position: msg.position,
                                                      constraintSize: bubbleConstraintSize)
        }
        
        return CGSize(width: showAvatar ? bubbleFitSize.width+avatarSize+marginBetweenAvatarAndBubble : bubbleFitSize.width,
                      height: bubbleFitSize.height)
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
