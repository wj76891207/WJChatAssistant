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
    
    let cellClassMap: [WJCADialogMessage.ContentType: WJCADialogMessageView.Type] = [
        .text: WJCADialogTextMessageView.self,
        .image: WJCADialogImageMessageView.self
    ]
    
    private lazy var layout: WJCADialogViewLayout = {
        let layout = WJCADialogViewLayout()
        layout.dialogView = self
        return layout
    }()
    
    private lazy var msgListView: UICollectionView = {
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(msgListView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        if let msgView = cell as? WJCADialogMessageView {
            msgView.update(withMessage: msg)
        }
        
        let invalidationContext = UICollectionViewLayoutInvalidationContext.init()
        invalidationContext.invalidateItems(at: [indexPath])
        layout.invalidateLayout(with: invalidationContext)
        return cell
    }
    
   
    
}

extension WJCADialogView: UICollectionViewDelegate {
    
}



