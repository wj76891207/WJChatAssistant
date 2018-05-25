//
//  WJChatAssistant.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public class WJChatAssistant {
    
    
    
    /// 通常来讲同时只会有一个对话场景，所以只用该单例来访问即可
    public static let `default` = WJChatAssistant()
    
    /// 语音识别器，默认使用系统的语音识别库
    public lazy var speechRecognizer: WJSpeechRecognizerProtocol = {
        let defRecognizer = DefaultSpeechRecognizer()
        return defRecognizer
    }()
    
    /// 语义识别器
    public var intentRecognizer: WJIntentRecognizerProtocol? = nil
    
    /// 识别结果代理
    public weak var delegate: WJChatAssistantDelegate? = nil
    
    /// 是否需要语义识别
    public var isNeedIntent = true
    
    
    // MARK: - Public Functions
    
    public func startListen() {
        
    }
    
    public func endListen() {
        
    }
    
    public func cancelListen() {
        
    }
    
//    public func recognizeVoice() {
//
//    }

//    public func recognizeText() {
//
//    }
}
