//
//  WJCAViewDialogDelegate.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public protocol WJCADialogViewDelagate: AnyObject {
    
    func didSelectOption(inMessage msgIndex: Int, at optionIndex: Int)
}
