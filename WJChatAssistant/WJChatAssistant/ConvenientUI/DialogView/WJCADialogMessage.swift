//
//  WJCADialogMessage.swift
//  WJChatAssistant
//
//  Created by wangjian on 29/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public struct WJCADialogOptionMessageContent {
    
    var title: String = ""
    var options: [String] = []

}

public struct WJCADialogMessage {
    
    enum Speaker {
        case user
        case bot
        case system
    }
    
    enum Status {
        case normal
        case processing
    }
    
    enum ContentType: String {
        case text
        case image
        case options
        case custom
    }
    
    var speaker: Speaker = .user
    var status: Status = .normal
    var contentType: ContentType = .text
    var content: Any = ""
    
}
