//
//  WJCADialogViewLayout.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

class WJCADialogViewLayout: UICollectionViewLayout {
    
    weak var dialogView: WJCADialogView? = nil
    
    override func prepare() {
        super.prepare()
        
        maxMsgWidth = ((dialogView?.bounds.width ?? UIScreen.main.bounds.width) - 3*marginToBorder).flat
        maxImageWidth = ((dialogView?.bounds.width ?? UIScreen.main.bounds.width)*0.6).flat
        maxImageHeight = ((dialogView?.bounds.height ?? UIScreen.main.bounds.height)*0.4).flat

        initMsgViewEstimatedFrame()
    }
    
    override var collectionViewContentSize: CGSize {
        guard let dialogView = dialogView, let lastFrame = msgViewFrames.last else { return .zero }

        return CGSize(width: dialogView.bounds.width, height: lastFrame.maxY + marginToBorder)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let att = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        att.frame = msgViewFrames[indexPath.row]
        
        print("---- get cell layout at \(indexPath.row)")
        
        return att
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let att = layoutAttributesForItem(at: itemIndexPath) else { return nil }
        guard let dialogView = dialogView else { return att }
        guard let msg = dialogView.dataSource?.dialogView(dialogView, messageAtIndex: itemIndexPath.item) else { return att }
        
        let offsetX = msg.position == .right ? dialogView.frame.width-att.frame.minX : -att.frame.maxX
        att.frame = att.frame.offsetBy(dx: offsetX, dy: 0)
        
        return att
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var atts: [UICollectionViewLayoutAttributes] = []
        for itemIndex in 0 ..< msgViewFrames.count {
            if  msgViewFrames[itemIndex].intersects(rect),
                let att = layoutAttributesForItem(at: IndexPath(item: itemIndex, section: 0)) {
                
                atts.append(att)
            }
        }
        
        return atts
    }
    
    /// 记录所有已经根据内容计算好尺寸的cell的尺寸
    private var msgViewSizes: [Int: CGSize] = [:]
    /// 记录当前所有cell的frame，包括已经计算，和未计算并使用预估值的
    private var msgViewFrames: [CGRect] = []
    
    private let marginBetweenMsg: CGFloat = 20
    private let marginToBorder: CGFloat = 15
    
    private var maxMsgWidth: CGFloat = 200
    private var maxImageWidth: CGFloat = 200
    private var maxImageHeight: CGFloat = 200
}

// MARK: - Message Cell View Frame Management
extension WJCADialogViewLayout {
    
    func msgViewSize(at index: Int) -> CGSize? {
        return msgViewSizes[index]
    }
    
    func msgViewDisaplaySize(at index: Int) -> CGSize {
        return msgViewSizes[index] ?? WJBubbleView.suggestedMinSize
    }
    
    func updateMsgViewSize(_ size: CGSize, at index: Int) {
        msgViewSizes[index] = size
        
        let oldFrame = msgViewFrames[index]
        msgViewFrames[index] = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: size.width, height: size.height)
        
        let offsetY = size.height-oldFrame.height
        if offsetY != 0 {
            for curIndex in index+1 ..< msgViewFrames.count {
                msgViewFrames[curIndex] = msgViewFrames[curIndex].offsetBy(dx: 0, dy: offsetY)
            }
        }
    }
    
    private func initMsgViewEstimatedFrame() {
        guard let dialogView = dialogView else { return }
        
        let msgNumber = dialogView.dataSource?.numberOfMessage(inDialogView: dialogView) ?? 0
        
        msgViewFrames = []
        var curY = marginToBorder
        for index in 0..<msgNumber {
            let msgFrame = msgViewFrame(at: index, withOffsetY: curY)
            msgViewFrames.append(msgFrame)
            
            curY += msgFrame.height + marginBetweenMsg
        }
    }
    
    func maxCellSize(forContentType type: WJCADialogMessage.ContentType) -> CGSize {
        return type == .image ?
            CGSize(width: maxImageWidth, height: maxImageHeight) :
            CGSize(width: maxMsgWidth, height: CGFloat.greatestFiniteMagnitude)
    }
    
    private func msgViewFrame(at index: Int, withOffsetY offsetY: CGFloat) -> CGRect {
        guard
            let dialogView = dialogView,
            let msg = dialogView.dataSource?.dialogView(dialogView, messageAtIndex: index) else {
            return .zero
        }

        let size = msgViewDisaplaySize(at: index)
        var x: CGFloat
        switch msg.position {
        case .right:
            x = dialogView.bounds.width - marginToBorder - size.width
        case .center:
            x = ((dialogView.bounds.width - size.width)/2).flat
        default:
            x = marginToBorder
        }
        
        return CGRect(x: x, y: offsetY, width: size.width, height: size.height)
    }
}
