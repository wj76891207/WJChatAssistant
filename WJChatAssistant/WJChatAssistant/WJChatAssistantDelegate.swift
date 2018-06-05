//
//  WJChatAssistantDelegate.swift
//  WJChatAssistant
//
//  Created by wangjian on 25/05/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import Foundation

public protocol WJChatAssistantDelegate: AnyObject {
    
    // MARK: Optional
    func wjChatAssistantUpdateVoicePower(_ averagePower: Float?, peakPower: Float?)
    
    
    // MARK: Required
    func wjChatAssistantUpdateSpeechRecognizeResult(_ result: WJSpeechRecognitionResult)
    
    func wjChatAssistantSpeechRecognizeComplate(_ isSuceessful: Bool, _ error: NSError?)
    
}

public extension WJChatAssistantDelegate {
    
    func wjChatAssistantUpdateVoicePower(_ averagePower: Float?, peakPower: Float?) {
        print("Not implement delegate : \(#function)")
    }

}
