//
//  WJCAViewDialogDataSource.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public protocol WJCADialogViewDataSource: AnyObject {
    
    func numberOfMessage(inDialogView dialogView: WJCADialogView) -> Int
    
    func dialogView(_ dialogView: WJCADialogView, messageAtIndex index: Int) -> WJCADialogMessage
    
    func dialogView(_ dialogView: WJCADialogView, customViewAtIndex index: Int) -> UIView
}

extension WJCADialogViewDataSource {
    
    public func dialogView(_ dialogView: WJCADialogView, customViewAtIndex index: Int) -> UIView {
        return UIView()
    }
}
