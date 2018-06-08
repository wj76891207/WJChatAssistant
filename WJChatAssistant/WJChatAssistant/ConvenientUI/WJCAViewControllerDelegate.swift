//
//  WJCAViewControllerDelegate.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public protocol WJCAViewControllerDelegate: AnyObject {
    
    func didSelectOption(inMessage msgIndex: Int, at optionIndex: Int)
    func needExcusIntent(_ intent: String)
}
