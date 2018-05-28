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
    func wjSpeechRecognizerUpdateVoicePower(_ averagePower: Float?, peakPower: Float?)
    
    func wjSpeechRecognizerOccurError(_ error: NSError)
    
    
    // MARK: Required
    func wjSpeechRecognizerUpdateRecognitionResult(_ result: WJSpeechRecognitionResult)
}

extension WJSpeechRecognizerDelegate {
    
    func wjSpeechRecognizerUpdateVoicePower(_ averagePower: Float?, peakPower: Float?) {
        // default do nothing
    }
    
    func wjSpeechRecognizerOccurError(_ error: NSError) {
        // default do nothing
    }
}
