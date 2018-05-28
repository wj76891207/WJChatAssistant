//
//  WJCAFunctionBar.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public class WJCAFunctionBar: UIView {
    
    public weak var delegate: WJCAFunctionBarDelegate? = nil
    public weak var datasource: WJCAFunctionBarDatasource? = nil
    
    private let btnW: CGFloat = 100
    private func barShowHeight() -> CGFloat { return (bounds.height*2/3).flat }
    
    private lazy var typingBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: bounds.height-barShowHeight(), width: btnW, height: barShowHeight()))
        return button
    }()
    
    private lazy var additionBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: bounds.width-btnW, y: bounds.height-barShowHeight(), width: btnW, height: barShowHeight()))
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
