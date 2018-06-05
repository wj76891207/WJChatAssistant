//
//  WJSpeechRecognizerProtocol.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public struct WJSpeechRecognitionResult {
    
    public let bestTranscription: String
    public let transcriptions: [String]
    public let isFinal: Bool
}

public protocol WJSpeechRecognizerProtocol {
    
    weak var speechRecognizerDelegate: WJSpeechRecognizerDelegate? { get }
    
    func startListen(withDelegate delegate: WJSpeechRecognizerDelegate)
    
    func stopListen()
    
    func cancelListen()
}


public protocol WJSpeechRecognizerDelegate: AnyObject {
    
    // MARK: Optional
    
    func wjSpeechRecognizeStart()
    
    func wjSpeechRecognizerUpdateVoicePower(_ averagePower: Float?, peakPower: Float?)
    
    
    // MARK: Required
    func wjSpeechRecognizerUpdateRecognitionResult(_ result: WJSpeechRecognitionResult)
    
    /// 语音识别结束时调用该方法
    ///
    /// - Parameters:
    ///   - isSuceessful: 是否成功结束
    ///   - error: 当非正常结束时，该参数返回错误信息
    func wjSpeechRecognizerComplate(_ isSuceessful: Bool, _ error: NSError?)
    
    func wjSpeechRecognizeCancel()
}

public extension WJSpeechRecognizerDelegate {
    
    func wjSpeechRecognizeStart() {
        // default do nothing
    }
    
    func wjSpeechRecognizeCancel() {
        // default do nothing
    }
    
    func wjSpeechRecognizerUpdateVoicePower(_ averagePower: Float?, peakPower: Float?) {
        // default do nothing
    }
}
