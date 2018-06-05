//
//  WJCAFunctionBarDelegate.swift
//  WJChatAssistant
//
//  Created by wangjian on 28/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public protocol WJCAFunctionBarDelegate: AnyObject {
    
    func shouldStartRecording()
    func shouldCancelRecording()
    func shouldEndRecording()
    
    func shouldStartTyping()
    func shouldCancelTyping()
    func shouldEndTyping()
    
}
