//
//  WJCADialogView.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

public class WJCADialogView: UIView {
    
    public weak var delegate: WJCADialogViewDelagate? = nil
    public weak var dataSource: WJCADialogViewDataSource? = nil
    
    let cellClassMap: [WJCADialogMessage.ContentType: WJCADialogMessageCell.Type] = [
        .text: WJCADialogTextMessageCell.self,
        .image: WJCADialogImageMessageCell.self,
        .options: WJCADialogOptionsMessageCell.self,
        .optionsList: WJCADialogOptionListMessageCell.self
    ]
    
    lazy var layout: WJCADialogViewLayout = {
        let layout = WJCADialogViewLayout()
        layout.dialogView = self
        return layout
    }()
    
    lazy var msgListView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        
        for (type, classType) in cellClassMap {
            collectionView.register(classType, forCellWithReuseIdentifier: type.rawValue)
        }
        
        return collectionView
    }()
    
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            msgListView.contentInset = contentInset
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(msgListView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        msgListView.frame = bounds
    }
    
    public func appendMsg() {
        let total = msgListView.numberOfItems(inSection: 0)
        msgListView.insertItems(at: [IndexPath(item: total, section: 0)])
        msgListView.scrollToItem(at: IndexPath(item: total, section: 0), at: .centeredVertically, animated: true)
    }
    
    public func updateMsg(at index: Int) {
        layout.reloadCells[IndexPath(item: index, section: 0)] = layout.msgViewFrames[index]
        layout.invalidateMsgViewSize(at: index)
        msgListView.reloadItems(at: [IndexPath(item: index, section: 0)])
        msgListView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: true)
        
//        guard let msg = dataSource?.dialogView(self, messageAtIndex: index) else { return }
//        guard let cell = msgListView.cellForItem(at: IndexPath(item: index, section: 0)) as? WJCADialogMessageCell else { return }
//
//        layout.updateMsgViewSize(<#T##size: CGSize##CGSize#>, at: <#T##Int#>, with: <#T##WJBubbleView.Position#>)
//
//
//        updateContent(forCell: cell, with: msg, at: index)
    }
    
    private func updateContent(forCell cell: WJCADialogMessageCell, with msg: WJCADialogMessage, at index: Int) {

        cell.update(withMessage: msg)
        
        if layout.msgViewSize(at: index) == nil {
            let fitSize = cell.sizeThatFits(layout.maxCellSize(forContentType: msg.contentType))
            layout.updateMsgViewSize(fitSize, at: index, with: msg.position)
            
            if index == self.collectionView(msgListView, numberOfItemsInSection: 0) - 1 {
                let invalidationContext = UICollectionViewLayoutInvalidationContext.init()
                invalidationContext.invalidateItems(at: [IndexPath.init(item: index, section: 0)])
                layout.invalidateLayout(with: invalidationContext)
            }
            else {
                layout.invalidateLayout()
            }
        }
    }
}

extension WJCADialogView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfMessage(inDialogView: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let msg = dataSource?.dialogView(self, messageAtIndex: indexPath.row) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: WJCADialogMessage.ContentType.text.rawValue, for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: msg.contentType.rawValue, for: indexPath)
        guard let msgCell = cell as? WJCADialogMessageCell else {
            return cell
        }
        
        if let cell = cell as? WJCADialogOptionsMessageCell {
            cell.delegate = self
        }
        else if let cell = cell as? WJCADialogOptionListMessageCell {
            cell.delegate = self
        }
        
        updateContent(forCell: msgCell, with: msg, at: indexPath.row)
        
        return msgCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension WJCADialogView: UICollectionViewDelegate {
    
}

extension WJCADialogView: WJCADialogOptionsMessageCellDelegate {
    
    func didSelectOption(in cell: WJCADialogMessageCell, at index: Int) {
        guard let msgIndex = msgListView.indexPath(for: cell)?.item else {
            return
        }
        
        delegate?.didSelectOption(inMessage: msgIndex, at: index)
    }
    
}



