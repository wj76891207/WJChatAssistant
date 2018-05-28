//
//  WJCADialogView.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation


public class WJCADialogView: UIView {
    
    public weak var delegate: WJCADialogViewDelagate? = nil
    public weak var datasource: WJCADialogViewDatasource? = nil
    
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewLayout()
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: bounds, collectionViewLayout: layout)
        return view
    }()
}



